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

  BuiltList<String> get utilities;

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
