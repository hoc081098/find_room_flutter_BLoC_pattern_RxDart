import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'room_detail_tab_state.g.dart';

abstract class RoomDetailTabState
    implements Built<RoomDetailTabState, RoomDetailTabStateBuilder> {
  @nullable
  RoomDetailState get room;

  @nullable
  UserState get user;

  RoomDetailTabState._();

  factory RoomDetailTabState([updates(RoomDetailTabStateBuilder b)]) =
      _$RoomDetailTabState;

  factory RoomDetailTabState.initial() => RoomDetailTabState();
}

abstract class RoomDetailState
    implements Built<RoomDetailState, RoomDetailStateBuilder> {
  String get id;

  String get title;

  String get description;

  String get price;

  String get countView;

  String get size;

  String get address;

  BuiltList<String> get images;

  String get phone;

  bool get available;

  BuiltList<Utility> get utilities;

  String get categoryName;

  @nullable
  String get createdAt;

  @nullable
  String get updatedAt;

  RoomDetailState._();

  factory RoomDetailState([updates(RoomDetailStateBuilder b)]) =
      _$RoomDetailState;
}

abstract class UserState implements Built<UserState, UserStateBuilder> {
  @nullable
  String get avatar;

  String get id;

  String get fullName;

  @nullable
  String get phoneNumber;

  String get email;

  UserState._();

  factory UserState([updates(UserStateBuilder b)]) = _$UserState;
}

class Utility extends EnumClass {
  static const Utility wifi = _$wifi;
  static const Utility private_wc = _$private_wc;
  static const Utility bed = _$bed;
  static const Utility easy = _$easy;
  static const Utility parking = _$parking;
  static const Utility without_owner = _$without_owner;

  const Utility._(String name) : super(name);

  static BuiltSet<Utility> get values => _$values;

  static Utility valueOf(String name) => _$valueOf(name);
}
