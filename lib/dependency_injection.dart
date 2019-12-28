import 'package:find_room/data/local/local_data_source.dart';
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
    @required this.roomCommentsRepository,
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
          priceFormat == other.priceFormat &&
          debug == other.debug &&
          localDataSource == other.localDataSource;

  @override
  int get hashCode =>
      userRepository.hashCode ^
      roomRepository.hashCode ^
      roomCommentsRepository.hashCode ^
      priceFormat.hashCode ^
      debug.hashCode ^
      localDataSource.hashCode;
}
