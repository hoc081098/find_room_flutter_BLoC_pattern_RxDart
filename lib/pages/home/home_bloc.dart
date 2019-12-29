import 'dart:async';

import 'package:collection/collection.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/banners/firestore_banner_repository.dart';
import 'package:find_room/data/local/local_data_source.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/banner_entity.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

const _kLimitRoom = 20;
const _kBannerSliderInitial = <BannerItem>[];
const _kNewestRoomsInitial = <RoomItem>[];
const _kMostViewedRoomsInitial = <RoomItem>[];

class HomeBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<String> addOrRemoveSaved;
  final Sink<Province> changeProvince;

  ///
  /// Streams
  ///
  final ValueStream<List<BannerItem>> banner$;
  final ValueStream<List<RoomItem>> newestRooms$;
  final ValueStream<List<RoomItem>> mostViewedRooms$;
  final ValueStream<Tuple2<Province, List<Province>>>
      selectedProvinceAndAllProvinces$;
  final Stream<HomeMessage> message$;

  ///
  /// Clean up
  ///
  final Function() _dispose;

  HomeBloc._({
    @required this.newestRooms$,
    @required this.mostViewedRooms$,
    @required this.addOrRemoveSaved,
    @required this.banner$,
    @required this.message$,
    @required this.selectedProvinceAndAllProvinces$,
    @required this.changeProvince,
    @required Function() dispose,
  }) : this._dispose = dispose;

  factory HomeBloc({
    @required AuthBloc authBloc,
    @required FirestoreRoomRepository roomRepository,
    @required FirestoreBannerRepository bannerRepository,
    @required ProvinceDistrictWardRepository provinceDistrictWardRepository,
    @required LocalDataSource localData,
    @required NumberFormat priceFormat,
  }) {
    ///Assert
    assert(authBloc != null, 'authBloc cannot be null');
    assert(roomRepository != null, 'roomRepository cannot be null');
    assert(bannerRepository != null, 'bannerRepository cannot be null');
    assert(provinceDistrictWardRepository != null,
        'provinceDistrictWardRepository cannot be null');
    assert(localData != null, 'localData cannot be null');
    assert(priceFormat != null, 'priceFormat cannot be null');

    ///Controller
    final addOrRemoveSavedController = PublishSubject<String>(sync: true);
    final changeProvinceController = PublishSubject<Province>(sync: true);
    final newestRoomsController = BehaviorSubject.seeded(_kNewestRoomsInitial);
    final mostViewedRoomsController =
        BehaviorSubject.seeded(_kMostViewedRoomsInitial);

    ///Streams
    final ValueConnectableStream<List<BannerItem>> banner$ =
        _getBanners(bannerRepository);

    final Stream<List<RoomItem>> mostViewedRooms$ = _getMostViewedRooms(
      localData,
      roomRepository,
      authBloc,
      priceFormat,
    );

    final Stream<List<RoomItem>> newestRooms$ = _getNewestRooms(
      localData,
      roomRepository,
      authBloc,
      priceFormat,
    );

    final ValueConnectableStream<Tuple2<Province, List<Province>>>
        selectedProvinceAndAllProvinces$ = _getSelectedProvinceAndAllProvinces(
      localData,
      provinceDistrictWardRepository,
    );

    final ConnectableStream<HomeMessage> message$ = Rx.merge(
      <Stream<HomeMessage>>[
        _getMessageAddOrRemoveSavedRoom(
          addOrRemoveSavedController,
          authBloc,
          roomRepository,
          [newestRoomsController, mostViewedRoomsController],
        ),
        _getMessageChangeProvince(changeProvinceController.stream, localData),
      ],
    ).publish();

    ///Subscriptions
    final subscriptions = <StreamSubscription<dynamic>>[
      /// Listen
      mostViewedRooms$.listen(mostViewedRoomsController.add),
      newestRooms$.listen(newestRoomsController.add),

      /// Connect
      banner$.connect(),
      selectedProvinceAndAllProvinces$.connect(),
      message$.connect(),
    ];

    ///Return
    return HomeBloc._(
      selectedProvinceAndAllProvinces$: selectedProvinceAndAllProvinces$,
      newestRooms$: newestRoomsController.stream,
      mostViewedRooms$: mostViewedRoomsController.stream,
      addOrRemoveSaved: addOrRemoveSavedController.sink,
      banner$: banner$,
      message$: message$,
      dispose: () {
        addOrRemoveSavedController.close();
        newestRoomsController.close();
        mostViewedRoomsController.close();
        changeProvinceController.close();
        subscriptions.forEach((subscription) => subscription.cancel());
      },
      changeProvince: changeProvinceController.sink,
    );
  }

  static Stream<ChangeSelectedProvinceMessage> _getMessageChangeProvince(
    Stream<Province> changeProvince$,
    LocalDataSource localData,
  ) {
    return changeProvince$.distinct().switchMap((province) {
      return Stream.fromFuture(localData.saveSelectedProvince(province))
          .map((result) => result
              ? ChangeSelectedProvinceMessageSuccess(province.name)
              : ChangeSelectedProvinceMessageError(province.name))
          .onErrorReturnWith(
              (e) => ChangeSelectedProvinceMessageError(province.name));
    });
  }

  static ValueConnectableStream<Tuple2<Province, List<Province>>>
      _getSelectedProvinceAndAllProvinces(
    LocalDataSource localData,
    ProvinceDistrictWardRepository provinceDistrictWardRepository,
  ) {
    final seedValue = localData.selectedProvince$.value;

    return localData.selectedProvince$
        .switchMap((province) {
          final convert = (List<ProvinceEntity> provinceEntities) {
            return provinceEntities.map((entity) {
              return Province(
                name: entity.name,
                id: entity.id,
              );
            }).toList();
          };

          return Stream.fromFuture(
                  provinceDistrictWardRepository.getAllProvinces())
              .map(convert)
              .map((provinces) => Tuple2(province, provinces))
              .startWith(Tuple2(province, [province]));
        })
        .distinct(
          (previous, next) =>
              previous.item1 == next.item1 &&
              const ListEquality<Province>().equals(
                previous.item2,
                next.item2,
              ),
        )
        .publishValueSeeded(
          Tuple2(
            seedValue,
            [seedValue],
          ),
        );
  }

  static ValueConnectableStream<List<BannerItem>> _getBanners(
      FirestoreBannerRepository bannerRepository) {
    final convert = (List<BannerEntity> bannerEntities) {
      return bannerEntities.map(
        (bannerEntity) {
          return BannerItem(
            image: bannerEntity.image,
            description: bannerEntity.description,
          );
        },
      ).toList();
    };
    return Stream.fromFuture(bannerRepository.banners())
        .map(convert)
        .publishValueSeeded(_kBannerSliderInitial);
  }

  static Stream<AddOrRemovedSavedMessage> _getMessageAddOrRemoveSavedRoom(
    Stream<String> addOrRemoveSaved$,
    AuthBloc authBloc,
    FirestoreRoomRepository roomRepository,
    List<BehaviorSubject<List<RoomItem>>> subjects,
  ) {
    return addOrRemoveSaved$
        .throttleTime(const Duration(milliseconds: 500))
        .withLatestFrom(
          authBloc.loginState$,
          (roomId, LoginState userLoginState) => Tuple2(roomId, userLoginState),
        )
        .flatMap(
          (tuple2) => _addOrRemoveSavedRoom(
            tuple2,
            roomRepository,
            subjects,
          ),
        );
  }

  static Stream<List<RoomItem>> _getNewestRooms(
    LocalDataSource localData,
    FirestoreRoomRepository roomRepository,
    AuthBloc authBloc,
    NumberFormat priceFormat,
  ) {
    return localData.selectedProvince$.switchMap((province) {
      return Rx.combineLatest2(
          roomRepository
              .newestRooms(
                selectedProvince: province,
                limit: _kLimitRoom,
              )
              .map((tuple) => tuple.item1),
          authBloc.loginState$,
          (List<RoomEntity> entities, LoginState loginState) =>
              HomeBloc._toRoomItems(
                entities,
                loginState,
                priceFormat,
              )).startWith(_kNewestRoomsInitial);
    }).distinct(
        (prev, next) => const ListEquality<RoomItem>().equals(prev, next));
  }

  static Stream<List<RoomItem>> _getMostViewedRooms(
    LocalDataSource localData,
    FirestoreRoomRepository roomRepository,
    AuthBloc authBloc,
    NumberFormat priceFormat,
  ) {
    return localData.selectedProvince$.switchMap((province) {
      return Rx.combineLatest2(
          roomRepository
              .mostViewedRooms(
                selectedProvince: province,
                limit: _kLimitRoom,
              )
              .map((tuple) => tuple.item1),
          authBloc.loginState$,
          (List<RoomEntity> entities, LoginState loginState) =>
              HomeBloc._toRoomItems(
                entities,
                loginState,
                priceFormat,
              )).startWith(_kMostViewedRoomsInitial);
    }).distinct(
        (prev, next) => const ListEquality<RoomItem>().equals(prev, next));
  }

  static Stream<AddOrRemovedSavedMessage> _addOrRemoveSavedRoom(
    Tuple2<String, LoginState> tuple,
    FirestoreRoomRepository roomRepository,
    List<BehaviorSubject<List<RoomItem>>> subjects,
  ) {
    final roomId = tuple.item1;
    final loginState = tuple.item2;

    final userId = loginState is LoggedInUser ? loginState.uid : null;
    if (userId == null) {
      return Stream.value(const AddOrRemovedSavedMessageError(NotLoginError()));
    }

    final getMessageFromResult = (Map<String, String> result) {
      if (result['status'] == 'added') {
        return const AddSavedMessageSuccess();
      }
      if (result['status'] == 'removed') {
        return const RemoveSavedMessageSuccess();
      }
      return null;
    };
    return Stream.fromFuture(
            roomRepository.addOrRemoveSavedRoom(roomId: roomId, userId: userId))
        .doOnData((result) =>
            _updateListRoomsAfterAddedOrRemovedSavedRoom(result, subjects))
        .map(getMessageFromResult)
        .onErrorReturnWith((e) => AddOrRemovedSavedMessageError(e));
  }

  static void _updateListRoomsAfterAddedOrRemovedSavedRoom(
    Map<String, String> result,
    List<BehaviorSubject<List<RoomItem>>> subjects,
  ) {
    print(result);
    final String id = result['id'];
    final String status = result['status'];

    final BookmarkIconState iconState = status == 'added'
        ? BookmarkIconState.showSaved
        : status == 'removed'
            ? BookmarkIconState.showNotSaved
            : BookmarkIconState.hide;

    subjects.forEach((subject) {
      final value = subject.value;
      final newValue = value
          .map((room) => room.id == id ? room.withIconState(iconState) : room)
          .toList();
      subject.add(newValue);
    });
  }

  static List<RoomItem> _toRoomItems(
    List<RoomEntity> roomEntities,
    LoginState loginState,
    NumberFormat priceFormat,
  ) {
    return roomEntities.map((roomEntity) {
      BookmarkIconState iconState;
      if (loginState is Unauthenticated) {
        iconState = BookmarkIconState.hide;
      } else if (loginState is LoggedInUser) {
        if (roomEntity.userIdsSaved.containsKey(loginState.uid)) {
          iconState = BookmarkIconState.showSaved;
        } else {
          iconState = BookmarkIconState.showNotSaved;
        }
      }

      return RoomItem(
        address: roomEntity.address,
        districtName: roomEntity.districtName,
        iconState: iconState,
        id: roomEntity.id,
        price: priceFormat.format(roomEntity.price),
        title: roomEntity.title,
        image: roomEntity.images.isEmpty ? null : roomEntity.images.first,
      );
    }).toList();
  }

  @override
  void dispose() {
    if (_dispose != null) {
      _dispose();
    }
  }
}
