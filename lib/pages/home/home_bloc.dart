import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/banners/firestore_banner_repository.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/shared_pref_util.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'home_state.dart';

class HomeBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<String> addOrRemoveSaved;

  ///
  /// Streams
  ///
  final ValueObservable<List<BannerItem>> banner$;
  final ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> newestRooms$;
  final ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> mostViewedRooms$;
  final ValueObservable<Province> selectedProvince$;
  final Stream<String> messageAddOrRemoveSavedRoom$;

  ///
  /// Clean up
  ///
  final List<StreamSubscription<dynamic>> _subscriptions;
  final Function() _closeSink;

  HomeBloc._({
    @required this.newestRooms$,
    @required this.mostViewedRooms$,
    @required this.addOrRemoveSaved,
    @required this.banner$,
    @required this.messageAddOrRemoveSavedRoom$,
    @required this.selectedProvince$,
    @required List<StreamSubscription<dynamic>> subscriptions,
    @required Function() closeSink,
  })  : this._subscriptions = subscriptions,
        this._closeSink = closeSink;

  factory HomeBloc({
    @required FirestoreRoomRepository roomRepository,
    @required UserBloc userBloc,
    @required FirestoreBannerRepository bannerRepository,
    @required SharedPrefUtil sharedPrefUtil,
  }) {
    final addOrRemoveSavedController = PublishSubject<String>(sync: true);
    final newestRoomsController =
        BehaviorSubject(seedValue: kNewestRoomsInitial);
    final mostViewedRoomsController =
        BehaviorSubject(seedValue: kMostViewedRoomsInitial);

    final ValueConnectableObservable<List<BannerItem>> banner$ =
        Observable.fromFuture(bannerRepository.banners())
            .map(
              (bannerEntities) => bannerEntities
                  .map(
                    (bannerEntity) => BannerItem(
                          image: null,
                          description: null,
                        ),
                  )
                  .toList(),
            )
            .publishValue(seedValue: kBannerSliderInitial);

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

    final subscriptions = <StreamSubscription>[
      mostViewedRooms$.listen(mostViewedRoomsController.add),
      newestRooms$.listen(newestRoomsController.add),
      messageAddOrRemoveSavedRoom$.connect(),
      banner$.connect(),
    ];

    return HomeBloc._(
      selectedProvince$: sharedPrefUtil.selectedProvince$,
      newestRooms$: newestRoomsController.stream,
      mostViewedRooms$: mostViewedRoomsController.stream,
      addOrRemoveSaved: addOrRemoveSavedController.sink,
      banner$: banner$,
      messageAddOrRemoveSavedRoom$: messageAddOrRemoveSavedRoom$,
      subscriptions: subscriptions,
      closeSink: () {
        addOrRemoveSavedController.close();
        newestRoomsController.close();
        mostViewedRoomsController.close();
      },
    );
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
                  limit: kLimitRoom,
                ),
                userBloc.user$,
                HomeBloc._toRoomItems,
              ).map((rooms) => kMostViewedRoomsInitial.withItem2(rooms)),
        )
        .distinct(tuple2Equals);
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
                  limit: kLimitRoom,
                ),
                userBloc.user$,
                HomeBloc._toRoomItems,
              ).map((rooms) => kMostViewedRoomsInitial.withItem2(rooms)),
        )
        .distinct(tuple2Equals);
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
          'Bạn phải đăng nhập mới thực hiện được chức năng này');
    }
    return Observable.fromFuture(
            roomRepository.addOrRemoveSavedRoom(roomId: roomId, userId: userId))
        .doOnData(
          (result) =>
              _updateListRoomsAfterAddedOrRemovedSavedRoom(result, subjects),
        )
        .map((result) => result['message'])
        .onErrorReturnWith((e) => 'Đã có lỗi xảy ra. Hãy thử lại');
  }

  static void _updateListRoomsAfterAddedOrRemovedSavedRoom(
      Map<String, String> result,
      List<BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>> subjects) {
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
    if (_closeSink != null) {
      _closeSink();
    }
    _subscriptions.forEach((subscription) => subscription.cancel());
  }
}
