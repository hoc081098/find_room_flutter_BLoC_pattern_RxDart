import 'package:sealed_unions/implementations/union_1_impl.dart';
import 'package:sealed_unions/sealed_unions.dart';
import 'package:sealed_unions/union_1.dart';

///
///
///

class PasswordError extends Union1Impl<_PasswordLengthLessThan6Chars> {
  PasswordError._(Union1<_PasswordLengthLessThan6Chars> union) : super(union);

  static const _factory = Singlet<_PasswordLengthLessThan6Chars>();

  factory PasswordError.passwordLengthLessThan6Chars() {
    return PasswordError._(
      _factory.first(
        const _PasswordLengthLessThan6Chars(),
      ),
    );
  }

  factory PasswordError.none() {
    return PasswordError._(
      _factory.none(),
    );
  }
}

class _PasswordLengthLessThan6Chars {
  const _PasswordLengthLessThan6Chars();
}

///
///
///
class ChangePasswordMessage
    extends Union3Impl<_ChangeSuccess, _ChangeFailure, _InvalidInformation> {
  ChangePasswordMessage._(
      Union3<_ChangeSuccess, _ChangeFailure, _InvalidInformation> union)
      : super(union);

  static const _factory =
      Triplet<_ChangeSuccess, _ChangeFailure, _InvalidInformation>();

  factory ChangePasswordMessage.changeSuccess() {
    return ChangePasswordMessage._(
      _factory.first(
        const _ChangeSuccess(),
      ),
    );
  }

  factory ChangePasswordMessage.changeFailure(ChangePasswordError error) {
    return ChangePasswordMessage._(
      _factory.second(
        _ChangeFailure(error),
      ),
    );
  }

  factory ChangePasswordMessage.invalidInformation() {
    return ChangePasswordMessage._(
      _factory.third(
        const _InvalidInformation(),
      ),
    );
  }
}

class _ChangeSuccess {
  const _ChangeSuccess();
}

class _ChangeFailure {
  final ChangePasswordError error;

  const _ChangeFailure(this.error);
}

class _InvalidInformation {
  const _InvalidInformation();
}

///
///
///

class ChangePasswordError extends Union6Impl<_UnknownError, _WeakPassword,
    _UserDisabled, _UserNotFound, _RequiresRecentLogin, _OperationNotAllowed> {
  static const _factory = Sextet<_UnknownError, _WeakPassword, _UserDisabled,
      _UserNotFound, _RequiresRecentLogin, _OperationNotAllowed>();

  ChangePasswordError._(
      Union6<_UnknownError, _WeakPassword, _UserDisabled, _UserNotFound,
              _RequiresRecentLogin, _OperationNotAllowed>
          union)
      : super(union);

  factory ChangePasswordError.unknownError(error) {
    return ChangePasswordError._(
      _factory.first(
        _UnknownError(error),
      ),
    );
  }

  factory ChangePasswordError.weakPassword() {
    return ChangePasswordError._(
      _factory.second(
        const _WeakPassword(),
      ),
    );
  }

  factory ChangePasswordError.userDisabled() {
    return ChangePasswordError._(
      _factory.third(
        const _UserDisabled(),
      ),
    );
  }

  factory ChangePasswordError.userNotFound() {
    return ChangePasswordError._(
      _factory.fourth(
        const _UserNotFound(),
      ),
    );
  }

  factory ChangePasswordError.requiresRecentLogin() {
    return ChangePasswordError._(
      _factory.fifth(
        const _RequiresRecentLogin(),
      ),
    );
  }

  factory ChangePasswordError.operationNotAllowed() {
    return ChangePasswordError._(
      _factory.sixth(
        const _OperationNotAllowed(),
      ),
    );
  }
}

class _WeakPassword {
  const _WeakPassword();
}

class _UserDisabled {
  const _UserDisabled();
}

class _UserNotFound {
  const _UserNotFound();
}

class _RequiresRecentLogin {
  const _RequiresRecentLogin();
}

class _OperationNotAllowed {
  const _OperationNotAllowed();
}

class _UnknownError {
  final error;

  const _UnknownError(this.error);
}
