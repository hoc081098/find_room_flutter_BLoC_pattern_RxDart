import 'package:built_value/built_value.dart';

part 'user_profile_state.g.dart';

abstract class UserProfileState
    implements Built<UserProfileState, UserProfileStateBuilder> {
  String get avatar;
  String get fullName => null;
  String get email => null;
  String get phone => null;
  DateTime get createdAt => null;
  String get address => null;
  bool get isActive => null;
  DateTime get updatedAt => null;

  UserProfileState._();

  factory UserProfileState([updates(UserProfileStateBuilder b)]) =
      _$UserProfileState;
}
