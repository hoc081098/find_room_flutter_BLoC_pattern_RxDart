import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/banner_entity.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/shared_pref_util.dart';
import 'package:find_room/utitls/collection_equality_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

const _kLimitRoom = 20;

const _kBannerSliderInitial = const BannerSlider(
  images: <BannerEntity>[],
  selectedProvinceName: null,
);

const _kLatestRoomsInitial = Tuple2(
  HeaderItem(
    seeAllQuery: SeeAllQuery.newest,
    title: 'Mới nhất',
  ),
  <RoomItem>[],
);

const _kHottestInitial = Tuple2(
  HeaderItem(
    seeAllQuery: SeeAllQuery.hottest,
    title: 'Xem nhiều',
  ),
  <RoomItem>[],
);

enum BookmarkIconState { hide, showSaved, showNotSaved }

enum SeeAllQuery { newest, hottest }

@immutable
class BannerSlider {
  final List<BannerEntity> images;
  final String selectedProvinceName;

  const BannerSlider({
    @required this.images,
    @required this.selectedProvinceName,
  });

  @override
  String toString() =>
      'BannerSlider{images: $images, selectedProvinceName: $selectedProvinceName}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BannerSlider &&
              runtimeType == other.runtimeType &&
              kListBannerEntityEquality.equals(images, other.images) &&
              selectedProvinceName == other.selectedProvinceName;

  @override
  int get hashCode =>
      kListBannerEntityEquality.hash(images) ^ selectedProvinceName.hashCode;
}

@immutable
class HeaderItem {
  final String title;
  final SeeAllQuery seeAllQuery;

  const HeaderItem({@required this.title, @required this.seeAllQuery});

  @override
  String toString() => 'HeaderItem{title: $title, seeAllQuery: $seeAllQuery}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HeaderItem &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              seeAllQuery == other.seeAllQuery;

  @override
  int get hashCode => title.hashCode ^ seeAllQuery.hashCode;
}

@immutable
class RoomItem {
  final String id;
  final String title;
  final int price;
  final String address;
  final String districtName;
  final String image;
  final BookmarkIconState iconState;

  const RoomItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.address,
    @required this.districtName,
    @required this.iconState,
    @required this.image,
  });

  @override
  String toString() => 'RoomItem{id: $id, title: $title, price: $price, '
      'address: $address, districtName: $districtName, image: $image, iconState: $iconState}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RoomItem &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              price == other.price &&
              address == other.address &&
              districtName == other.districtName &&
              image == other.image &&
              iconState == other.iconState;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      address.hashCode ^
      districtName.hashCode ^
      image.hashCode ^
      iconState.hashCode;
}

class HomeBloc implements BaseBloc {
  static final _firestore = Firestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;

  final _addOrRemoveSavedController = PublishSubject<String>();
  final _bannerSlidersController =
  BehaviorSubject<BannerSlider>(seedValue: _kBannerSliderInitial);
  final _latestRoomsController =
  BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>(
      seedValue: _kLatestRoomsInitial);
  final _hottestRoomsController =
  BehaviorSubject<Tuple2<HeaderItem, List<RoomItem>>>(
      seedValue: _kHottestInitial);
  final _messageAddOrRemoveSavedRoomController = PublishSubject<String>();
  List<StreamSubscription<dynamic>> _subscriptions;

  Sink<String> get addOrRemoveSaved => _addOrRemoveSavedController.sink;

  ValueObservable<BannerSlider> get bannerSliders =>
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
        .doOnData((docRef) => print('doOnData HomeBloc#docRef=$docRef'));

    _subscriptions = <StreamSubscription<dynamic>>[
      selectedProvince$
          .map((province) => province.name)
          .switchMap(_toBannerSliders)
          .distinct()
          .doOnData((data) => print('doOnData HomeBloc#Banners=$data'))
          .listen(
        _bannerSlidersController.add,
        onError: _bannerSlidersController.addError,
      ),
      selectedProvinceDocumentRef$
          .switchMap(_toLatestRooms)
          .distinct()
          .doOnData((data) => print('doOnData HomeBloc#NewestRooms=$data'))
          .listen(
        _latestRoomsController.add,
        onError: _latestRoomsController.addError,
      ),
      selectedProvinceDocumentRef$
          .switchMap(_toHottestRooms)
          .distinct()
          .doOnData((data) => print('doOnData HomeBloc#HottersRooms=$data'))
          .listen(
        _hottestRoomsController.add,
        onError: _hottestRoomsController.addError,
      ),
      _addOrRemoveSavedController
          .flatMap(_addOrRemoveSavedRoom)
          .doOnData(
              (data) => print('doOnData HomeBloc#MessageAddOrRemoved=$data'))
          .listen(
        _messageAddOrRemoveSavedRoomController.add,
        onError: _messageAddOrRemoveSavedRoomController.addError,
      ),
    ];
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
        .doOnData((result) =>
        print('Add or removed saved roomId=$roomId, result=$result'))
        .map((_) => 'Thành công')
        .onErrorReturnWith((e) => 'Lỗi $e');
  }

  static Stream<BannerSlider> _toBannerSliders(String provinceName) {
    return _firestore
        .collection('banners')
        .orderBy('created_at', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) =>
        snapshot.documents
            .map((doc) => BannerEntity.fromDocument(doc))
            .toList())
        .map((images) =>
        BannerSlider(images: images, selectedProvinceName: provinceName));
  }

  static Stream<Tuple2<HeaderItem, List<RoomItem>>> _toHottestRooms(
      DocumentReference selectedProvinceRef,) {
    print('_toHottestRooms...');

    final hottestRoomsStream$ = _firestore
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('count_view', descending: true)
        .limit(_kLimitRoom)
        .snapshots();

    _firestore
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('count_view', descending: true)
        .limit(_kLimitRoom)
        .getDocuments()
        .then((snapshot) => print('##DEBUG $snapshot'))
        .catchError((dynamic e, StackTrace s) => print('#DEBUG $e, $s'));

    return Observable.combineLatest2(hottestRoomsStream$,
        _firebaseAuth.onAuthStateChanged, _querySnapshotToRooms)
        .map((rooms) => _kHottestInitial.withItem2(rooms))
        .doOnData((data) => print('_toHottestRooms $data'));
  }

  static List<RoomItem> _querySnapshotToRooms(QuerySnapshot snapshot,
      FirebaseUser user,) {
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
      DocumentReference selectedProvinceRef,) {
    final latestRooms$ = _firestore
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(_kLimitRoom)
        .snapshots();

    return Observable.combineLatest2(latestRooms$,
        _firebaseAuth.onAuthStateChanged, _querySnapshotToRooms)
        .map((rooms) => _kLatestRoomsInitial.withItem2(rooms))
        .doOnData((data) => print('_toLatestRooms $data'));
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
