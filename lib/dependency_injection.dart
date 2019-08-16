import 'package:find_room/data/local/local_data_source.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Injector extends InheritedWidget {
  final FirebaseUserRepository userRepository;
  final FirestoreRoomRepository roomRepository;
  final NumberFormat priceFormat;
  final bool debug;
  final LocalDataSource localDataSource;

  Injector({
    Key key,
    @required this.userRepository,
    @required this.roomRepository,
    @required this.priceFormat,
    @required this.debug,
    @required this.localDataSource,
    @required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Injector);

  @override
  bool updateShouldNotify(Injector oldWidget) =>
      userRepository != oldWidget.userRepository &&
      roomRepository != oldWidget.roomRepository &&
      priceFormat != oldWidget.priceFormat &&
      debug != oldWidget.debug &&
      localDataSource != oldWidget.localDataSource;
}
