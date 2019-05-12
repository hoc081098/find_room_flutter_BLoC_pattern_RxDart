import 'package:meta/meta.dart';

@immutable
abstract class ForgotPasswordMessage {}

class InvalidInformation implements ForgotPasswordMessage {
  const InvalidInformation();
}

class SendPasswordResetEmailSuccess implements ForgotPasswordMessage {
  const SendPasswordResetEmailSuccess();
}

@immutable
abstract class ForgotPasswordError {}

class UnknownError implements ForgotPasswordError {
  final error;

  const UnknownError([this.error]);
}

class InvalidEmailError implements ForgotPasswordError {
  const InvalidEmailError();
}

class UserNotFoundError implements ForgotPasswordError {
  const UserNotFoundError();
}

class SendPasswordResetEmailFailure implements ForgotPasswordMessage {
  final ForgotPasswordError error;

  const SendPasswordResetEmailFailure(this.error);
}

@immutable
abstract class EmailError {}

class InvalidEmailAddress implements EmailError {
  const InvalidEmailAddress();
}
