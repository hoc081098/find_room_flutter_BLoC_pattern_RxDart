import 'package:meta/meta.dart';

///
/// Login message
///

@immutable
abstract class RegisterMessage {}

class RegisterMessageSuccess implements RegisterMessage {
  const RegisterMessageSuccess();
}

class RegisterMessageError implements RegisterMessage {
  final RegisterError error;

  const RegisterMessageError(this.error);
}

///
/// Login error response
///

@immutable
abstract class RegisterError {}

class NetworkError implements RegisterError {
  const NetworkError();
}

class OperationNotAllowedError implements RegisterError {
  const OperationNotAllowedError();
}

class UserDisabledError implements RegisterError {
  const UserDisabledError();
}

class TooManyRequestsError implements RegisterError {
  const TooManyRequestsError();
}

class UserNotFoundError implements RegisterError {
  const UserNotFoundError();
}

class WrongPasswordError implements RegisterError {
  const WrongPasswordError();
}

class InvalidEmailError implements RegisterError {
  const InvalidEmailError();
}

class EmailAlreadyInUseError implements RegisterError {
  const EmailAlreadyInUseError();
}

class WeakPasswordError implements RegisterError {
  const WeakPasswordError();
}

///

class UnknownError implements RegisterError {
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

@immutable
abstract class FullNameError {}

@immutable
abstract class AddressError {}

@immutable
abstract class PhoneError {}

class PasswordMustBeAtLeast6Characters implements PasswordError {
  const PasswordMustBeAtLeast6Characters();
}

class InvalidEmailAddress implements EmailError {
  const InvalidEmailAddress();
}

class InvalidPhone implements PhoneError {
  const InvalidPhone();
}

class FullNameMustBeAtLeast3Characters implements FullNameError {
  const FullNameMustBeAtLeast3Characters();
}

class AddressMustBeNotEmpty implements AddressError {
  const AddressMustBeNotEmpty();
}
