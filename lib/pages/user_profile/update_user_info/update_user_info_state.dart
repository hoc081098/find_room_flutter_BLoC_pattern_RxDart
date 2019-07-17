import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

///
/// Full name error
///
@immutable
abstract class FullNameError {
  const FullNameError._();

  const factory FullNameError.lengthOfFullNameLessThan3Chars() =
      _LengthOfFullNameLessThen3CharactersError;

  T fold<T>({
    @required T onLengthOfFullNameLessThan3Chars(),
  }) {
    final self = this;
    if (self is _LengthOfFullNameLessThen3CharactersError) {
      return onLengthOfFullNameLessThan3Chars();
    }
    return null;
  }
}

class _LengthOfFullNameLessThen3CharactersError extends FullNameError {
  const _LengthOfFullNameLessThen3CharactersError() : super._();
}

///
/// Address error
///
abstract class AddressError {
  const AddressError._();

  const factory AddressError.emptyAddress() = _EmptyAddressError;

  T fold<T>({
    @required T onEmptyAddress(),
  }) {
    final self = this;
    if (self is _EmptyAddressError) {
      return onEmptyAddress();
    }
    return null;
  }
}

class _EmptyAddressError extends AddressError {
  const _EmptyAddressError() : super._();
}

///
/// Phone number error
///
abstract class PhoneNumberError {
  const PhoneNumberError._();

  const factory PhoneNumberError.invalidPhoneNumber() =
      _InvalidPhoneNumberError;

  T fold<T>({
    @required T onInvalidPhoneNumber(),
  }) {
    final self = this;
    if (self is _InvalidPhoneNumberError) {
      return onInvalidPhoneNumber();
    }
    return null;
  }
}

class _InvalidPhoneNumberError extends PhoneNumberError {
  const _InvalidPhoneNumberError() : super._();
}

///
/// Error when execute update
///
abstract class UpdateUserInfoError {
  const UpdateUserInfoError._();

  const factory UpdateUserInfoError.userDisabled() = _UserDisable;

  const factory UpdateUserInfoError.userNotFound() = _UserNotFound;

  const factory UpdateUserInfoError.unknown(error) = _Unknown;

  const factory UpdateUserInfoError.networkError() = _NetworkError;

  const factory UpdateUserInfoError.tooManyRequestsError() =
      _TooManyRequestsError;

  const factory UpdateUserInfoError.operationNotAllowedError() =
      _OperationNotAllowedError;

  T fold<T>({
    @required T onUserDisable(),
    @required T onUserNotFound(),
    @required T onUnknown(),
    @required T onNetworkError(),
    @required T onTooManyRequestsError(),
    @required T onOperationNotAllowedError(),
  }) {
    final self = this;
    if (self is _UserDisable) {
      return onUserDisable();
    }
    if (self is _UserNotFound) {
      return onUserNotFound();
    }
    if (self is _Unknown) {
      return onUnknown();
    }
    if (self is _NetworkError) {
      return onNetworkError();
    }
    if (self is _OperationNotAllowedError) {
      return onOperationNotAllowedError();
    }
    if (self is _TooManyRequestsError) {
      return onTooManyRequestsError();
    }
    return null;
  }
}

class _UserDisable extends UpdateUserInfoError {
  const _UserDisable() : super._();
}

class _UserNotFound extends UpdateUserInfoError {
  const _UserNotFound() : super._();
}

class _Unknown extends UpdateUserInfoError {
  final error;

  const _Unknown(this.error) : super._();
}

class _NetworkError extends UpdateUserInfoError {
  const _NetworkError() : super._();
}

class _OperationNotAllowedError extends UpdateUserInfoError {
  const _OperationNotAllowedError() : super._();
}

class _TooManyRequestsError extends UpdateUserInfoError {
  const _TooManyRequestsError() : super._();
}

///
/// Message
///
@immutable
abstract class UpdateUserInfoMessage {
  const UpdateUserInfoMessage._();

  const factory UpdateUserInfoMessage.invalidInfomation() = _InvalidInformation;

  const factory UpdateUserInfoMessage.updateSuccess() = _UpdateSuccess;

  const factory UpdateUserInfoMessage.updateFailure(UpdateUserInfoError error) =
      _UpdateFailure;

  T fold<T>({
    @required T onInvalidInformation(),
    @required T onUpdateSuccess(),
    @required T onUpdateFailure(UpdateUserInfoError error),
  }) {
    final self = this;
    if (self is _InvalidInformation) {
      return onInvalidInformation();
    }
    if (self is _UpdateSuccess) {
      return onUpdateSuccess();
    }
    if (self is _UpdateFailure) {
      return onUpdateFailure(self.error);
    }
    return null;
  }
}

class _InvalidInformation extends UpdateUserInfoMessage {
  const _InvalidInformation() : super._();
}

class _UpdateSuccess extends UpdateUserInfoMessage {
  const _UpdateSuccess() : super._();
}

class _UpdateFailure extends UpdateUserInfoMessage {
  final UpdateUserInfoError error;

  const _UpdateFailure(this.error) : super._();
}
