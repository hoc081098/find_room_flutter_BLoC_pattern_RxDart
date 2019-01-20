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
  final ValueObservable<List<BannerItem>> banner$;
  final ValueObservable<List<RoomItem>> newestRooms$;
  final ValueObservable<List<RoomItem>> mostViewedRooms$;
  final ValueObservable<Tuple2<Province, List<Province>>>
      selectedProvinceAndAllProvinces$;
  final Stream<String> message$;

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
    @required UserBloc userBloc,
    @required FirestoreRoomRepository roomRepository,
    @required FirestoreBannerRepository bannerRepository,
    @required ProvinceDistrictWardRepository provinceDistrictWardRepository,
    @required SharedPrefUtil sharedPrefUtil,
    @required NumberFormat priceFormat,
  }) {
    ///Assert
    assert(userBloc != null, 'userBloc cannot be null');
    assert(roomRepository != null, 'roomRepository cannot be null');
    assert(bannerRepository != null, 'bannerRepository cannot be null');
    assert(provinceDistrictWardRepository != null,
        'provinceDistrictWardRepository cannot be null');
    assert(sharedPrefUtil != null, 'sharedPrefUtil cannot be null');
    assert(priceFormat != null, 'priceFormat cannot be null');

    ///Controller
    final addOrRemoveSavedController = PublishSubject<String>(sync: true);
    final changeProvinceController = PublishSubject<Province>(sync: true);
    final newestRoomsController =
        BehaviorSubject(seedValue: _kNewestRoomsInitial);
    final mostViewedRoomsController =
        BehaviorSubject(seedValue: _kMostViewedRoomsInitial);

    ///Streams
    final ValueConnectableObservable<List<BannerItem>> banner$ =
        _getBanners(bannerRepository);

    final Observable<List<RoomItem>> mostViewedRooms$ = _getMostViewedRooms(
      sharedPrefUtil,
      roomRepository,
      userBloc,
      priceFormat,
    );

    final Observable<List<RoomItem>> newestRooms$ = _getNewestRooms(
      sharedPrefUtil,
      roomRepository,
      userBloc,
      priceFormat,
    );

    final ValueConnectableObservable<Tuple2<Province, List<Province>>>
        selectedProvinceAndAllProvinces$ = _getSelectedProvinceAndAllProvinces(
      sharedPrefUtil,
      provinceDistrictWardRepository,
    );

    final ConnectableObservable<String> message$ = Observable.merge(
      <Stream<String>>[
        _getMessageAddOrRemoveSavedRoom(
          addOrRemoveSavedController,
          userBloc,
          roomRepository,
          [newestRoomsController, mostViewedRoomsController],
        ),
        _getMessageChangeProvince(changeProvinceController, sharedPrefUtil),
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

  static Observable<String> _getMessageChangeProvince(
    PublishSubject<Province> changeProvinceController,
    SharedPrefUtil sharedPrefUtil,
  ) {
    return changeProvinceController.stream.distinct().switchMap(
      (province) {
        return Observable.fromFuture(
                sharedPrefUtil.saveSelectedProvince(province))
            .map((result) => Tuple2(result, province));
      },
    ).map((tuple) {
      final result = tuple.item1;
      final province = tuple.item2;
      if (result) {
        return 'Chuyển sang ${province.name} thành công';
      }
      return 'Lỗi xảy ra khi chuyển sang ${province.name}!!';
    });
  }

  static ValueConnectableObservable<Tuple2<Province, List<Province>>>
      _getSelectedProvinceAndAllProvinces(
    SharedPrefUtil sharedPrefUtil,
    ProvinceDistrictWardRepository provinceDistrictWardRepository,
  ) {
    var seedValue = sharedPrefUtil.selectedProvince$.value;

    return sharedPrefUtil.selectedProvince$
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
        .publishValue(
          seedValue: Tuple2(
            seedValue,
            [seedValue],
          ),
        );
  }

  static ValueConnectableObservable<List<BannerItem>> _getBanners(
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
    return Observable.fromFuture(bannerRepository.banners())
        .map(convert)
        .publishValue(seedValue: _kBannerSliderInitial);
  }

  static Observable<String> _getMessageAddOrRemoveSavedRoom(
    PublishSubject<String> addOrRemoveSavedController,
    UserBloc userBloc,
    FirestoreRoomRepository roomRepository,
    List<BehaviorSubject<List<RoomItem>>> subjects,
  ) {
    return addOrRemoveSavedController.stream
        .throttle(Duration(milliseconds: 500))
        .withLatestFrom(
          userBloc.userLoginState$,
          (roomId, UserLoginState userLoginState) =>
              Tuple2(roomId, userLoginState),
        )
        .flatMap(
          (tuple2) => _addOrRemoveSavedRoom(
                tuple2,
                roomRepository,
                subjects,
              ),
        );
  }

  static Observable<List<RoomItem>> _getNewestRooms(
    SharedPrefUtil sharedPrefUtil,
    FirestoreRoomRepository roomRepository,
    UserBloc userBloc,
    NumberFormat priceFormat,
  ) {
    return sharedPrefUtil.selectedProvince$.switchMap((province) {
      return Observable.combineLatest2(
          roomRepository.newestRooms(
            selectedProvince: province,
            limit: _kLimitRoom,
          ),
          userBloc.userLoginState$,
          (List<RoomEntity> entities, UserLoginState loginState) =>
              HomeBloc._toRoomItems(
                entities,
                loginState,
                priceFormat,
              )).startWith(_kNewestRoomsInitial);
    }).distinct(
        (prev, next) => const ListEquality<RoomItem>().equals(prev, next));
  }

  static Observable<List<RoomItem>> _getMostViewedRooms(
    SharedPrefUtil sharedPrefUtil,
    FirestoreRoomRepository roomRepository,
    UserBloc userBloc,
    NumberFormat priceFormat,
  ) {
    return sharedPrefUtil.selectedProvince$.switchMap((province) {
      return Observable.combineLatest2(
          roomRepository.mostViewedRooms(
            selectedProvince: province,
            limit: _kLimitRoom,
          ),
          userBloc.userLoginState$,
          (List<RoomEntity> entities, UserLoginState loginState) =>
              HomeBloc._toRoomItems(
                entities,
                loginState,
                priceFormat,
              )).startWith(_kMostViewedRoomsInitial);
    }).distinct(
        (prev, next) => const ListEquality<RoomItem>().equals(prev, next));
  }

  static Stream<String> _addOrRemoveSavedRoom(
    Tuple2<String, UserLoginState> tuple,
    FirestoreRoomRepository roomRepository,
    List<BehaviorSubject<List<RoomItem>>> subjects,
  ) {
    final roomId = tuple.item1;
    final loginState = tuple.item2;

    final userId = loginState is UserLogin ? loginState.uid : null;
    if (userId == null) {
      return Observable.just(
        'Bạn phải đăng nhập mới thực hiện được chức năng này',
      );
    }

    final getMessageFromResult = (Map<String, String> result) {
      if (result['status'] == 'added') {
        return 'Thêm vào danh sách đã lưu thành công';
      }
      if (result['status'] == 'removed') {
        return 'Xóa khỏi danh sách đã lưu thành công';
      }
    };
    return Observable.fromFuture(
            roomRepository.addOrRemoveSavedRoom(roomId: roomId, userId: userId))
        .doOnData((result) =>
            _updateListRoomsAfterAddedOrRemovedSavedRoom(result, subjects))
        .map(getMessageFromResult)
        .onErrorReturnWith((e) => 'Đã có lỗi xảy ra. Hãy thử lại');
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
    UserLoginState loginState,
    NumberFormat priceFormat,
  ) {
    return roomEntities.map((roomEntity) {
      BookmarkIconState iconState;
      if (loginState is NotLogin) {
        iconState = BookmarkIconState.hide;
      } else if (loginState is UserLogin) {
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
