import 'package:meta/meta.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

class LoggedInUser implements LoginState {
  final String uid;
  final String email;
  final String phone;
  final String fullName;
  final String address;
  final String avatar;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoggedInUser({
    @required this.uid,
    @required this.email,
    @required this.fullName,
    @required this.avatar,
    @required this.phone,
    @required this.address,
    @required this.isActive,
    @required this.createdAt,
    @required this.updatedAt,
  });

  @override
  String toString() =>
      'LoggedInUser{uid: $uid, email: $email, phone: $phone, fullName: $fullName,'
      ' address: $address, avatar: $avatar, isActive: $isActive, createdAt: $createdAt,'
      ' updatedAt: $updatedAt}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedInUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          phone == other.phone &&
          fullName == other.fullName &&
          address == other.address &&
          avatar == other.avatar &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      fullName.hashCode ^
      address.hashCode ^
      avatar.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

class Unauthenticated implements LoginState {
  const Unauthenticated();
}

///
///  Message expose from UserBloc
///
@immutable
abstract class UserMessage {}

class UserLogoutMessage implements UserMessage {}

class UserLogoutMessageSuccess implements UserLogoutMessage {
  const UserLogoutMessageSuccess();
}

class UserLogoutMessageError implements UserLogoutMessage {
  final Object error;

  const UserLogoutMessageError(this.error);
}
