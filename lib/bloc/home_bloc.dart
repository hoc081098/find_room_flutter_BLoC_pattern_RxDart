import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/banner_entity.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/shared_pref_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class Province {
  final String id;
  final String name;

  Province({
    @required this.id,
    @required this.name,
  });
}

@immutable
abstract class HomeListItem {}

enum BookmarkIconState { hide, showSaved, showNotSaved }

class HeaderItem implements HomeListItem {
  final String title;

  HeaderItem({@required this.title});
}

class RoomItem implements HomeListItem {
  final String id;
  final String title;
  final int price;
  final String address;
  final String districtName;
  final String image;
  final BookmarkIconState iconState;

  RoomItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.address,
    @required this.districtName,
    @required this.iconState,
    @required this.image,
  });
}

class BannerItem implements HomeListItem {
  final List<BannerEntity> images;
  final String selectedProvinceName;

  BannerItem({
    @required this.images,
    @required this.selectedProvinceName,
  });
}

enum SeeAllQuery { newest, hottest }

class SeeAll implements HomeListItem {
  final SeeAllQuery seeAllQuery;

  SeeAll({this.seeAllQuery});
}

class HomeBloc implements BaseBloc {
  ///
  ///
  ///

  final _addOrRemoveSavedController = PublishSubject<String>();

  void Function(String) get addOrRemoveSaved =>
      _addOrRemoveSavedController.sink.add;

  ///
  ///
  ///

  final _homeListItemsController = BehaviorSubject<List<HomeListItem>>();

  Stream<List<HomeListItem>> get homeListItems =>
      _homeListItemsController.stream;

  ///
  ///
  ///

  final _bannersStream = Firestore.instance
      .collection('banners')
      .orderBy('created_at', descending: true)
      .limit(3)
      .snapshots();
  final _authStateChanged = FirebaseAuth.instance.onAuthStateChanged;

  HomeBloc() {
    Observable(SharedPrefUtil.instance.selectedProvince)
        .switchMap(_handleSelectedProvinceChanged)
        .distinct()
        .pipe(_homeListItemsController);
  }

  Stream<List<HomeListItem>> _handleSelectedProvinceChanged(province) {
    debugPrint('##DEBUG change province=$province');

    final selectedProvinceRef =
        Firestore.instance.document('provinces/${province.id}');

    var latestRoomsStream = Firestore.instance
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .orderBy('created_at', descending: true)
        .limit(20)
        .snapshots();

    var hottestRoomsStream = Firestore.instance
        .collection('motelrooms')
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .orderBy('count_view', descending: true)
        .limit(20)
        .snapshots();

    return Observable.combineLatest4(
      _bannersStream,
      latestRoomsStream,
      hottestRoomsStream,
      _authStateChanged,
      (bannersSnapshot, latestSnapshot, hottestSnapshot, user) =>
          _convertToHomeListItems(
            bannersSnapshot,
            province,
            latestSnapshot,
            user,
            hottestSnapshot,
          ),
    );
  }

  List<HomeListItem> _convertToHomeListItems(
    QuerySnapshot bannersSnapshot,
    province,
    QuerySnapshot latestSnapshot,
    FirebaseUser user,
    QuerySnapshot hottestSnapshot,
  ) {
    debugPrint('##DEBUG emit...');

    return [
      _querySnapshotToBanners(bannersSnapshot, province.name),
      HeaderItem(title: 'Mới nhất'),
      _querySnapshotToRooms(latestSnapshot, user),
      SeeAll(seeAllQuery: SeeAllQuery.newest),
      HeaderItem(title: 'Xem nhiều'),
      _querySnapshotToRooms(hottestSnapshot, user),
      SeeAll(seeAllQuery: SeeAllQuery.hottest)
    ]
        .expand(
            (i) => i is Iterable ? i.cast<HomeListItem>() : <HomeListItem>[i])
        .toList();
  }

  @override
  void dispose() {
    debugPrint('##DEBUG HomeBloc::dispose');
    _addOrRemoveSavedController.close();
    _homeListItemsController.close();
  }

  Iterable<BannerItem> _querySnapshotToBanners(
      QuerySnapshot bannersSnapshot, String name) {
    var images = bannersSnapshot.documents
        .map((doc) => BannerEntity.fromDocument(doc))
        .toList();

    return [
      BannerItem(
        images: images,
        selectedProvinceName: name,
      ),
    ];
  }

  Iterable<RoomItem> _querySnapshotToRooms(
      QuerySnapshot latestSnapshot, FirebaseUser user) {
    return latestSnapshot.documents.map((doc) {
      var roomEntity = RoomEntity.fromDocument(doc);
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
    });
  }
}
