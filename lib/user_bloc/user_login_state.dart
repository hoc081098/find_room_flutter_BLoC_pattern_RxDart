import 'package:meta/meta.dart';

@immutable
abstract class UserLoginState {
  const UserLoginState();
}

class UserLogin implements UserLoginState {
  final String uid;
  final String email;
  final String fullName;
  final String avatar;

  const UserLogin({
    @required this.uid,
    @required this.email,
    @required this.fullName,
    @required this.avatar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLogin &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          fullName == other.fullName &&
          avatar == other.avatar;

  @override
  int get hashCode =>
      uid.hashCode ^ email.hashCode ^ fullName.hashCode ^ avatar.hashCode;

  @override
  String toString() =>
      'User{uid: $uid, email: $email, fullName: $fullName, avatar: $avatar}';
}

class NotLogin implements UserLoginState {
  const NotLogin();
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
