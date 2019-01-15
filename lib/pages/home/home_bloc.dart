import 'dart:async';

import 'package:collection/collection.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/banners/firestore_banner_repository.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/banner_entity.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/shared_pref_util.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

const _kLimitRoom = 20;

const _kBannerSliderInitial = <BannerItem>[];

const _kNewestRoomsInitial = Tuple2(
  HeaderItem(
    seeAllQuery: SeeAllQuery.newest,
    title: 'Mới nhất',
  ),
  <RoomItem>[],
);

const _kMostViewedRoomsInitial = Tuple2(
  HeaderItem(
    seeAllQuery: SeeAllQuery.mostViewed,
    title: 'Xem nhiều',
  ),
  <RoomItem>[],
);

bool _tuple2Equals<T>(
  Tuple2<dynamic, List<T>> previous,
  Tuple2<dynamic, List<T>> next,
) =>
    previous.item1 == next.item1 &&
    ListEquality<T>().equals(previous.item2, next.item2);

class HomeBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<String> addOrRemoveSaved;
  final Sink<Province> changeProvince;

  ///
  /// Streams
  ///
  final ValueObservable<List<BannerItem>> banner$;
  final ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> newestRooms$;
  final ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> mostViewedRooms$;
  final ValueObservable<Tuple2<Province, List<Province>>>
      selectedProvinceAndAllProvinces$;
  final Stream<String> messageAddOrRemoveSavedRoom$;

  ///
  /// Clean up
  ///
  final Function() _dispose;

  HomeBloc._({
    @required this.newestRooms$,
    @required this.mostViewedRooms$,
    @required this.addOrRemoveSaved,
    @required this.banner$,
    @required this.messageAddOrRemoveSavedRoom$,
    @required this.selectedProvinceAndAllProvinces$,
    @required this.changeProvince,
    @required Function() dispose,
  }) : this._dispose = dispose;

  factory HomeBloc({
    @required UserBloc userBloc,
    @required FirestoreRoomRepository roomRepository,
    @required FirestoreBannerRepository bannerRepository,
    @required ProvinceDistrictWardRepository provinceDistrictWardRepository,
    @required SharedPrefUtil sharedPrefUtil,
  }) {
    final addOrRemoveSavedController = PublishSubject<String>(sync: true);
    final changeProvinceController = PublishSubject<Province>(sync: true);
    final newestRoomsController =
        BehaviorSubject(seedValue: _kNewestRoomsInitial);
    final mostViewedRoomsController =
        BehaviorSubject(seedValue: _kMostViewedRoomsInitial);

    final ValueConnectableObservable<List<BannerItem>> banner$ =
        _getBanners(bannerRepository);

    final Observable<Tuple2<HeaderItem, List<RoomItem>>> mostViewedRooms$ =
        _getMostViewedRooms(sharedPrefUtil, roomRepository, userBloc);

    final Observable<Tuple2<HeaderItem, List<RoomItem>>> newestRooms$ =
        _getNewestRooms(sharedPrefUtil, roomRepository, userBloc);

    final ConnectableObservable<String> messageAddOrRemoveSavedRoom$ =
        _getMessageAddOrRemoveSavedRoom(
      addOrRemoveSavedController,
      userBloc,
      roomRepository,
      [newestRoomsController, mostViewedRoomsController],
    );

    final ValueConnectableObservable<Tuple2<Province, List<Province>>>
        selectedProvinceAndAllProvinces$ = _getSelectedProvinceAndAllProvinces(
      sharedPrefUtil,
      provinceDistrictWardRepository,
    );

    final Observable<bool> changeProvince$ =
        changeProvinceController.stream.switchMap(
      (province) {
        return Observable.fromFuture(
          sharedPrefUtil.saveSelectedProvince(province),
        );
      },
    );

    final subscriptions = <StreamSubscription>[
      mostViewedRooms$.listen(mostViewedRoomsController.add),
      newestRooms$.listen(newestRoomsController.add),
      messageAddOrRemoveSavedRoom$.connect(),
      banner$.connect(),
      selectedProvinceAndAllProvinces$.connect(),
      (changeProvince$.listen((result) => print('Change province $result'))),
    ];

    return HomeBloc._(
      selectedProvinceAndAllProvinces$: selectedProvinceAndAllProvinces$,
      newestRooms$: newestRoomsController.stream,
      mostViewedRooms$: mostViewedRoomsController.stream,
      addOrRemoveSaved: addOrRemoveSavedController.sink,
      banner$: banner$,
      messageAddOrRemoveSavedRoom$: messageAddOrRemoveSavedRoom$,
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

  static ValueConnectableObservable<Tuple2<Province, List<Province>>>
      _getSelectedProvinceAndAllProvinces(
    SharedPrefUtil sharedPrefUtil,
    ProvinceDistrictWardRepository provinceDistrictWardRepository,
  ) {
    return sharedPrefUtil.selectedProvince$
        .distinct()
        .switchMap((province) {
          final convert = (List<ProvinceEntity> provinceEntities) {
            return provinceEntities.map((entity) {
              return Province(
                name: entity.name,
                id: entity.id,
              );
            }).toList();
          };

          return Observable.fromFuture(
                  provinceDistrictWardRepository.getAllProvinces())
              .map(convert)
              .map((provinces) => Tuple2(province, provinces));
        })
        .distinct((prev, next) => _tuple2Equals<Province>(prev, next))
        .publishValue(
          seedValue: Tuple2(
            sharedPrefUtil.selectedProvince$.value,
            [],
          ),
        );
  }

  static ValueConnectableObservable<List<BannerItem>> _getBanners(
      FirestoreBannerRepository bannerRepository) {
    final convert = (List<BannerEntity> bannerEntities) {
      return bannerEntities.map(
        (bannerEntity) {
          return BannerItem(
            image: null,
            description: null,
          );
        },
      ).toList();
    };
    return Observable.fromFuture(bannerRepository.banners())
        .map(convert)
        .publishValue(seedValue: _kBannerSliderInitial);
  }

  static ConnectableObservable<String> _getMessageAddOrRemoveSavedRoom(
    PublishSubject<String> addOrRemoveSavedController,
    UserBloc userBloc,
    FirestoreRoomRepository roomRepository,
    List<BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>> subjects,
  ) {
    return addOrRemoveSavedController.stream
        .throttle(Duration(milliseconds: 500))
        .withLatestFrom(
          userBloc.user$,
          (roomId, UserLoginState userLoginState) =>
              Tuple2(roomId, userLoginState),
        )
        .flatMap(
          (tuple2) => _addOrRemoveSavedRoom(
                tuple2,
                roomRepository,
                subjects,
              ),
        )
        .publish();
  }

  static Observable<Tuple2<HeaderItem, List<RoomItem>>> _getNewestRooms(
    SharedPrefUtil sharedPrefUtil,
    FirestoreRoomRepository roomRepository,
    UserBloc userBloc,
  ) {
    return sharedPrefUtil.selectedProvince$
        .switchMap(
          (province) => Observable.combineLatest2(
                roomRepository.newestRooms(
                  selectedProvince: province,
                  limit: _kLimitRoom,
                ),
                userBloc.user$,
                HomeBloc._toRoomItems,
              ).map((rooms) => _kMostViewedRoomsInitial.withItem2(rooms)),
        )
        .distinct((prev, next) => _tuple2Equals<RoomItem>(prev, next));
  }

  static Observable<Tuple2<HeaderItem, List<RoomItem>>> _getMostViewedRooms(
    SharedPrefUtil sharedPrefUtil,
    FirestoreRoomRepository roomRepository,
    UserBloc userBloc,
  ) {
    return sharedPrefUtil.selectedProvince$
        .switchMap(
          (province) => Observable.combineLatest2(
                roomRepository.mostViewedRooms(
                  selectedProvince: province,
                  limit: _kLimitRoom,
                ),
                userBloc.user$,
                HomeBloc._toRoomItems,
              ).map((rooms) => _kMostViewedRoomsInitial.withItem2(rooms)),
        )
        .distinct((prev, next) => _tuple2Equals<RoomItem>(prev, next));
  }

  static Stream<String> _addOrRemoveSavedRoom(
    Tuple2<String, UserLoginState> tuple,
    FirestoreRoomRepository roomRepository,
    List<BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>> subjects,
  ) {
    final roomId = tuple.item1;
    final loginState = tuple.item2;

    final userId = loginState is UserLogin ? loginState.id : null;
    if (userId == null) {
      return Observable.just(
        'Bạn phải đăng nhập mới thực hiện được chức năng này',
      );
    }
    return Observable.fromFuture(
            roomRepository.addOrRemoveSavedRoom(roomId: roomId, userId: userId))
        .doOnData((result) =>
            _updateListRoomsAfterAddedOrRemovedSavedRoom(result, subjects))
        .map((result) => result['message'])
        .onErrorReturnWith((e) {
      print(e);
      return 'Đã có lỗi xảy ra. Hãy thử lại';
    });
  }

  static void _updateListRoomsAfterAddedOrRemovedSavedRoom(
    Map<String, String> result,
    List<BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>> subjects,
  ) {
    final String id = result['id'];
    final String status = result['status'];
    final BookmarkIconState iconState = status == 'added'
        ? BookmarkIconState.showSaved
        : status == 'removed'
            ? BookmarkIconState.showNotSaved
            : BookmarkIconState.hide;

    subjects.forEach((subject) {
      final value = subject.value;
      final newValue = value.withItem2(
        value.item2
            .map((room) => room.id == id ? room.withIconState(iconState) : room)
            .toList(),
      );
      subject.add(newValue);
    });
  }

  static List<RoomItem> _toRoomItems(
    List<RoomEntity> roomEntities,
    UserLoginState loginState,
  ) {
    return roomEntities.map((roomEntity) {
      BookmarkIconState iconState;
      if (loginState is NotLogin) {
        iconState = BookmarkIconState.hide;
      } else if (loginState is UserLogin) {
        if (roomEntity.userIdsSaved.contains(loginState.id)) {
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
        price: roomEntity.price,
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
