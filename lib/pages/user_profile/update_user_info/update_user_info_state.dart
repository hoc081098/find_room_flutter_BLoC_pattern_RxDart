import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

///
/// Full name error
///
@immutable
abstract class FullNameError {}

class LengthOfFullNameLessThen3CharactersError implements FullNameError {
  const LengthOfFullNameLessThen3CharactersError();
}

///
/// Address error
///
abstract class AddressError {}

class EmptyAddressError implements AddressError {
  const EmptyAddressError();
}

///
/// Phone number error
///
abstract class PhoneNumberError {}

class InvalidPhoneNumberError implements PhoneNumberError {
  const InvalidPhoneNumberError();
}

///
/// Error when execute update
///
abstract class UpdateUserInfoError {}

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

  void when({
    @required void onInvalidInfomation(),
    @required void onUpdateSuccess(),
    @required void onUpdateFailure(UpdateUserInfoError error),
  }) {
    final self = this;
    if (self is _InvalidInformation) {
      return onInvalidInfomation();
    }
    if (self is _UpdateSuccess) {
      return onUpdateSuccess();
    }
    if (self is _UpdateFailure) {
      return onUpdateFailure(self.error);
    }
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
