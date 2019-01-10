import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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

  final _addOrRemoveSavedController = PublishSubject<String>(sync: true);
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

  Sink<String> get addOrRemoveSaved => _addOrRemoveSavedController.sink;

  ValueObservable<List<BannerItem>> get bannerSliders =>
      _bannerSlidersController.stream;

  ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> get latestRooms =>
      _latestRoomsController.stream;

  ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> get hottestRooms =>
      _hottestRoomsController.stream;

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
          .distinct(bannersListEquals)
          .listen(_bannerSlidersController.add),
      selectedProvinceDocumentRef$
          .switchMap(_toLatestRooms)
          .distinct(tuple2Equals)
          .listen(_latestRoomsController.add),
      selectedProvinceDocumentRef$
          .switchMap(_toHottestRooms)
          .distinct(tuple2Equals)
          .listen(_hottestRoomsController.add),
      _addOrRemoveSavedController
          .throttle(Duration(milliseconds: 500))
          .withLatestFrom(
            _firebaseAuth.onAuthStateChanged,
            (roomId, FirebaseUser user) => Tuple2(roomId, user),
          )
          .flatMap(_addOrRemoveSavedRoom)
          .listen(_messageAddOrRemoveSavedRoomController.add),
    ];
  }

  Stream<String> _addOrRemoveSavedRoom(Tuple2<String, FirebaseUser> tuple) {
    final roomId = tuple.item1;
    final userId = tuple.item2?.uid;

    if (userId == null) {
      return Observable.just(
        'Bạn phải đăng nhập mới thực hiện được chức năng này',
      );
    }

    final TransactionHandler transactionHandler = (transaction) async {
      final roomRef = _firestore.document('motelrooms/$roomId');
      final documentSnapshot = await transaction.get(roomRef);
      final roomEntity = RoomEntity.fromDocument(documentSnapshot);

      if (roomEntity.userIdsSaved.contains(userId)) {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved': FieldValue.arrayRemove([userId]),
          },
        );

        return <String, dynamic>{
          'message': 'Xóa khỏi đã lưu thành công',
          'updated': <String, String>{
            'id': documentSnapshot.documentID,
            'iconState': BookmarkIconState.showNotSaved.toString()
          },
        };
      } else {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved': FieldValue.arrayUnion([userId]),
          },
        );
        return <String, dynamic>{
          'message': 'Thêm vào đã lưu thành công',
          'updated': <String, String>{
            'id': documentSnapshot.documentID,
            'iconState': BookmarkIconState.showSaved.toString()
          },
        };
      }
    };

    return Observable.fromFuture(_firestore.runTransaction(transactionHandler,
            timeout: Duration(seconds: 10)))
        .doOnData(
          (result) {
            final updated = (result['updated'] as Map).cast<String, String>();
            _updateList(updated);
          },
        )
        .map((result) => result['message'] as String)
        .onErrorReturnWith((e) => 'Đã có lỗi xảy ra. Hãy thử lại');
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

  void _updateList(Map<String, String> result) {
    final id = result['id'];
    final iconState = result['iconState'];

    _latestRoomsController.add(
      kLatestRoomsInitial.withItem2(
        _latestRoomsController.value.item2
            .map((room) => room.id == id ? room.withIconState(iconState) : room)
            .toList(),
      ),
    );

    _hottestRoomsController.add(
      kHottestInitial.withItem2(
        _hottestRoomsController.value.item2
            .map((room) => room.id == id ? room.withIconState(iconState) : room)
            .toList(),
      ),
    );

    print('Updated $result');
  }
}
