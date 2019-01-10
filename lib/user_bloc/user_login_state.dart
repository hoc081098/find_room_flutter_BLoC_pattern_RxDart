import 'package:meta/meta.dart';

@immutable
abstract class UserLoginState {
  const UserLoginState();
}

class UserLogin extends UserLoginState {
  final String id;
  final String email;
  final String fullName;
  final String avatar;

  const UserLogin({
    @required this.id,
    @required this.email,
    @required this.fullName,
    @required this.avatar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLogin &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          fullName == other.fullName &&
          avatar == other.avatar;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ fullName.hashCode ^ avatar.hashCode;

  @override
  String toString() =>
      'User{id: $id, email: $email, fullName: $fullName, avatar: $avatar}';
}

class NotLogin extends UserLoginState {
  const NotLogin();
}

class ErrorState extends UserLoginState{
  final Object error;

  const ErrorState(this.error);

  @override
  String toString() => 'Error{error: $error}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ErrorState &&
              runtimeType == other.runtimeType &&
              error == other.error;

  @override
  int get hashCode => error.hashCode;
}