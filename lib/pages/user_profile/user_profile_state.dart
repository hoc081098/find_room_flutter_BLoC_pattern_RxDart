import 'package:built_value/built_value.dart';

part 'user_profile_state.g.dart';

abstract class UserProfileState
    implements Built<UserProfileState, UserProfileStateBuilder> {
  // is null if user does not exist
  @nullable
  UserProfile get profile;
  bool get isCurrentUser;

  UserProfileState._();

  factory UserProfileState([updates(UserProfileStateBuilder b)]) =
      _$UserProfileState;
}

abstract class UserProfile implements Built<UserProfile, UserProfileBuilder> {
  @nullable
  String get avatar;
  String get fullName;
  String get email;
  @nullable
  String get phone;
  @nullable
  String get address;
  bool get isActive;
  DateTime get createdAt;
  DateTime get updatedAt;

  UserProfile._();

  factory UserProfile([updates(UserProfileBuilder b)]) = _$UserProfile;
}
