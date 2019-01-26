import 'package:meta/meta.dart';

///
/// Login message
///

@immutable
abstract class LoginMessage {}

class LoginMessageSuccess implements LoginMessage {
  const LoginMessageSuccess();
}

class LoginMessageError implements LoginMessage {
  final LoginError error;

  const LoginMessageError(this.error);
}

///
/// Login error response
///

@immutable
abstract class LoginError {}

class NetworkError implements LoginError {
  const NetworkError();
}

class TooManyRequestsError implements LoginError {
  const TooManyRequestsError();
}

class UserNotFoundError implements LoginError {
  const UserNotFoundError();
}

class WrongPasswordError implements LoginError {
  const WrongPasswordError();
}

class InvalidEmailError implements LoginError {
  const InvalidEmailError();
}

class EmailAlreadyInUseError implements LoginError {
  const EmailAlreadyInUseError();
}

class WeakPasswordError implements LoginError {
  const WeakPasswordError();
}

class UserDisabledError implements LoginError {
  const UserDisabledError();
}

class UnknownError implements LoginError {
  final Object error;

  const UnknownError(this.error);

  @override
  String toString() => 'UnknownError{error: $error}';
}

///
/// Email edit text error and password edit text error
///

@immutable
abstract class EmailError {}

@immutable
abstract class PasswordError {}

class PasswordAtLeast6Characters implements PasswordError {
  const PasswordAtLeast6Characters();
}

class InvalidEmailAddress implements EmailError {
  const InvalidEmailAddress();
}
