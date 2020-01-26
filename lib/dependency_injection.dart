import 'package:find_room/data/categories/firestore_categories_repository.dart';
import 'package:find_room/data/local/local_data_source.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository.dart';
import 'package:find_room/data/room_comments/room_comments_repository.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Injector extends InheritedWidget {
  final FirebaseUserRepository userRepository;
  final FirestoreRoomRepository roomRepository;
  final RoomCommentsRepository roomCommentsRepository;
  final FirestoreCategoriesRepository categoriesRepository;
  final NumberFormat priceFormat;
  final bool debug;
  final LocalDataSource localDataSource;
  final ProvinceDistrictWardRepository provinceDistrictWardRepository;

  Injector({
    Key key,
    @required this.userRepository,
    @required this.roomRepository,
    @required this.priceFormat,
    @required this.debug,
    @required this.localDataSource,
    @required Widget child,
    @required this.roomCommentsRepository,
    @required this.categoriesRepository,
    @required this.provinceDistrictWardRepository,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injector>();

  @override
  bool updateShouldNotify(Injector oldWidget) => this != oldWidget;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Injector &&
          runtimeType == other.runtimeType &&
          userRepository == other.userRepository &&
          roomRepository == other.roomRepository &&
          roomCommentsRepository == other.roomCommentsRepository &&
          categoriesRepository == other.categoriesRepository &&
          priceFormat == other.priceFormat &&
          debug == other.debug &&
          localDataSource == other.localDataSource &&
          provinceDistrictWardRepository ==
              other.provinceDistrictWardRepository;

  @override
  int get hashCode =>
      userRepository.hashCode ^
      roomRepository.hashCode ^
      roomCommentsRepository.hashCode ^
      categoriesRepository.hashCode ^
      priceFormat.hashCode ^
      debug.hashCode ^
      localDataSource.hashCode ^
      provinceDistrictWardRepository.hashCode;
}
