import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/banner_entity.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/shared_pref_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'home_state.dart';

class HomeBloc implements BaseBloc {
  static final _firestore = Firestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;

  final _addOrRemoveSavedController = PublishSubject<String>();
  final _bannerSlidersController =
      BehaviorSubject<List<BannerItem>>(seedValue: kBannerSliderInitial);
  final _latestRoomsController =
      BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>(
          seedValue: kLatestRoomsInitial);
  final _hottestRoomsController =
      BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>(
          seedValue: kHottestInitial);
  final _messageAddOrRemoveSavedRoomController = PublishSubject<String>();

  List<StreamSubscription<dynamic>> _subscriptions;
  ValueObservable<List<BannerItem>> _bannersSliders$;
  ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> _latestRooms$;
  ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> _hottestRooms$;

  Sink<String> get addOrRemoveSaved => _addOrRemoveSavedController.sink;

  ValueObservable<List<BannerItem>> get bannerSliders => _bannersSliders$;

  ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> get latestRooms =>
      _latestRooms$;

  ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> get hottestRooms =>
      _hottestRooms$;

  Stream<String> get messageAddOrRemoveSavedRoom =>
      _messageAddOrRemoveSavedRoomController.stream;

  HomeBloc() {
    final selectedProvince$ = SharedPrefUtil.instance.selectedProvince;
    final selectedProvinceDocumentRef$ = selectedProvince$
        .map((province) => province.id)
        .map((provinceId) => _firestore.document('provinces/$provinceId'))
        .share();

    _subscriptions = <StreamSubscription<dynamic>>[
      selectedProvince$
          .map((province) => province.name)
          .switchMap(_toBannerSliders)
          .listen(_bannerSlidersController.add),
      selectedProvinceDocumentRef$
          .switchMap(_toLatestRooms)
          .listen(_latestRoomsController.add),
      selectedProvinceDocumentRef$
          .switchMap(_toHottestRooms)
          .listen(_hottestRoomsController.add),
      _addOrRemoveSavedController
          .flatMap(_addOrRemoveSavedRoom)
          .listen(_messageAddOrRemoveSavedRoomController.add),
    ];

    _bannersSliders$ = _bannerSlidersController.stream
        .distinct(bannersListEquals)
        .shareValue(seedValue: kBannerSliderInitial);
    _latestRooms$ = _latestRoomsController.stream
        .distinct(tuple2Equals)
        .shareValue(seedValue: kLatestRoomsInitial);
    _hottestRooms$ = _hottestRoomsController.stream
        .distinct(tuple2Equals)
        .shareValue(seedValue: kHottestInitial);
  }

  static Stream<String> _addOrRemoveSavedRoom(String roomId) {
    final TransactionHandler transactionHandler = (transaction) async {
      final roomRef = _firestore.document('motelrooms/$roomId');
      final data =
          (await transaction.get(roomRef))?.data ?? <String, dynamic>{};
      final ids = ((data['user_ids_saved'] ?? []) as List).cast<String>();

      if (ids.contains(roomId)) {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved': FieldValue.arrayRemove([roomId]),
          },
        );
      } else {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved': FieldValue.arrayUnion([roomId]),
          },
        );
      }
    };

    return Observable.fromFuture(_firestore.runTransaction(transactionHandler))
        .doOnData((result) => print(
            '[DEBUG] Add or removed saved rooms, roomId=$roomId, result=$result'))
        .map((_) => 'Thành công')
        .onErrorReturnWith((e) => 'Lỗi $e');
  }

  static Stream<List<BannerItem>> _toBannerSliders(String provinceName) {
    return _firestore
        .collection('banners')
        .orderBy('created_at', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => BannerEntity.fromDocument(doc))
            .map((entity) => BannerItem(
                image: entity.image, description: entity.description))
            .toList());
  }

  static Stream<Tuple2<HeaderItem, List<RoomItem>>> _toHottestRooms(
      DocumentReference selectedProvinceRef) {
    final hottestRoomsStream$ = _firestore
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('count_view', descending: true)
        .limit(kLimitRoom)
        .snapshots();

    return Observable.combineLatest2(
      hottestRoomsStream$,
      _firebaseAuth.onAuthStateChanged,
      _querySnapshotToRooms,
    ).map((rooms) => kHottestInitial.withItem2(rooms));
  }

  static List<RoomItem> _querySnapshotToRooms(
    QuerySnapshot snapshot,
    FirebaseUser user,
  ) {
    return snapshot.documents.map((doc) {
      final roomEntity = RoomEntity.fromDocument(doc);

      BookmarkIconState iconState;
      if (user == null) {
        iconState = BookmarkIconState.hide;
      } else if (roomEntity.userIdsSaved.contains(user.uid)) {
        iconState = BookmarkIconState.showSaved;
      } else {
        iconState = BookmarkIconState.showNotSaved;
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

  static Stream<Tuple2<HeaderItem, List<RoomItem>>> _toLatestRooms(
      DocumentReference selectedProvinceRef) {
    final latestRooms$ = _firestore
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(kLimitRoom)
        .snapshots();

    return Observable.combineLatest2(
      latestRooms$,
      _firebaseAuth.onAuthStateChanged,
      _querySnapshotToRooms,
    ).map((rooms) => kLatestRoomsInitial.withItem2(rooms));
  }

  @override
  void dispose() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    _messageAddOrRemoveSavedRoomController.close();
    _addOrRemoveSavedController.close();
    _latestRoomsController.close();
    _bannerSlidersController.close();
    _hottestRoomsController.close();
  }
}
