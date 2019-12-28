import 'dart:async';
import 'dart:io';

import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/login_register/register/register_state.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

/// ignore_for_file: close_sinks

bool _isValidPassword(String password) {
  return password.length >= 6;
}

bool _isValidEmail(String email) {
  final _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
}

bool _isValidFullName(String name) {
  return name.length >= 3;
}

bool _isValidAddress(String address) {
  return address.isNotEmpty;
}

bool _isValidPhone(String phone) {
  final _phoneRegExpString = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  return RegExp(_phoneRegExpString, caseSensitive: false).hasMatch(phone);
}

///
/// BLoC handle registering new account
///
class RegisterBloc implements BaseBloc {
  ///
  /// Input [Function]s
  ///
  final void Function() submitRegister;
  final void Function(String) fullNameChanged;
  final void Function(String) emailChanged;
  final void Function(String) passwordChanged;
  final void Function(String) addressChanged;
  final void Function(String) phoneChanged;
  final void Function(File) avatarChanged;

  ///
  /// Output [Stream]s
  ///
  final ValueStream<bool> isLoading$;
  final ValueStream<File> avatar$;
  final Stream<FullNameError> fullNameError$;
  final Stream<EmailError> emailError$;
  final Stream<PasswordError> passwordError$;
  final Stream<AddressError> addressError$;
  final Stream<PhoneError> phoneError$;
  final Stream<RegisterMessage> message$;

  ///
  /// Clean up resource
  ///
  final void Function() _dispose;

  RegisterBloc._({
    @required this.fullNameChanged,
    @required this.addressChanged,
    @required this.phoneChanged,
    @required this.avatarChanged,
    @required this.submitRegister,
    @required this.emailChanged,
    @required this.passwordChanged,
    @required this.isLoading$,
    @required this.emailError$,
    @required this.passwordError$,
    @required this.message$,
    @required this.fullNameError$,
    @required this.addressError$,
    @required this.phoneError$,
    @required this.avatar$,
    @required void Function() dispose,
  }) : _dispose = dispose;

  @override
  void dispose() => _dispose();

  factory RegisterBloc(FirebaseUserRepository userRepository) {
    ///
    ///Assert
    ///
    assert(userRepository != null, 'userRepository cannot be null');

    ///
    /// Stream controllers
    ///
    final fullNameSubject = BehaviorSubject<String>.seeded('');
    final emailSubject = BehaviorSubject<String>.seeded('');
    final passwordSubject = BehaviorSubject<String>.seeded('');
    final addressSubject = BehaviorSubject<String>.seeded('');
    final phoneSubject = BehaviorSubject<String>.seeded('');
    final avatarSubject = PublishSubject<File>();
    final submitRegisterSubject = PublishSubject<void>();
    final isLoadingSubject = BehaviorSubject<bool>.seeded(false);

    ///
    /// Streams
    ///
    final fullNameError$ = fullNameSubject.map((fullName) {
      if (_isValidFullName(fullName)) return null;
      return const FullNameMustBeAtLeast3Characters();
    }).share();

    final emailError$ = emailSubject.map((email) {
      if (_isValidEmail(email)) return null;
      return const InvalidEmailAddress();
    }).share();

    final passwordError$ = passwordSubject.map((password) {
      if (_isValidPassword(password)) return null;
      return const PasswordMustBeAtLeast6Characters();
    }).share();

    final addressError$ = addressSubject.map((address) {
      if (_isValidAddress(address)) return null;
      return const AddressMustBeNotEmpty();
    }).share();

    final phoneError$ = phoneSubject.map((phone) {
      if (_isValidPhone(phone)) return null;
      return const InvalidPhone();
    }).share();

    final allFieldAreValid$ = Rx.combineLatest(
      [
        fullNameError$,
        emailError$,
        passwordError$,
        phoneError$,
        addressError$,
      ],
      (allError) => allError.every((error) => error == null),
    );

    final avatar$ = avatarSubject.publishValueDistinct(
      equals: (prev, next) => path.equals(prev?.path ?? '', next?.path ?? ''),
    );

    final message$ = submitRegisterSubject
        .withLatestFrom(allFieldAreValid$, (_, bool isValid) => isValid)
        .where((isValid) => isValid)
        .exhaustMap(
          (_) => performRegister(
            userRepository,
            fullNameSubject.value,
            emailSubject.value,
            passwordSubject.value,
            phoneSubject.value,
            addressSubject.value,
            avatar$.value,
            isLoadingSubject,
          ),
        )
        .publish();

    ///
    /// Controllers and subscriptions
    final subscriptions = <StreamSubscription>[
      message$.connect(),
      avatar$.connect(),
    ];
    final controllers = <StreamController>[
      fullNameSubject,
      emailSubject,
      passwordSubject,
      addressSubject,
      phoneSubject,
      avatarSubject,
      submitRegisterSubject,
      isLoadingSubject,
    ];

    return RegisterBloc._(
      avatar$: avatar$,
      fullNameChanged: fullNameSubject.add,
      addressChanged: addressSubject.add,
      phoneChanged: phoneSubject.add,
      avatarChanged: avatarSubject.add,
      submitRegister: () => submitRegisterSubject.add(null),
      emailChanged: emailSubject.add,
      passwordChanged: passwordSubject.add,
      isLoading$: isLoadingSubject,
      fullNameError$: fullNameError$,
      emailError$: emailError$,
      passwordError$: passwordError$,
      phoneError$: phoneError$,
      addressError$: addressError$,
      message$: message$,
      dispose: () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
    );
  }

  static Stream<RegisterMessage> performRegister(
    FirebaseUserRepository userRepository,
    String fullName,
    String email,
    String password,
    String phone,
    String address,
    File avatar,
    Sink<bool> isLoadingSink,
  ) async* {
    try {
      isLoadingSink.add(true);
      await userRepository.registerWithEmail(
        email: email,
        password: password,
        address: address,
        fullName: fullName,
        phoneNumber: phone,
        avatar: avatar,
      );
      yield const RegisterMessageSuccess();
    } catch (e) {
      yield _getRegisterError(e);
    } finally {
      isLoadingSink.add(false);
    }
  }

  static RegisterMessageError _getRegisterError(error) {
    if (error is PlatformException) {
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD':
          return const RegisterMessageError(WeakPasswordError());
        case 'ERROR_INVALID_EMAIL':
          return const RegisterMessageError(InvalidEmailError());
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return const RegisterMessageError(EmailAlreadyInUseError());
        case 'ERROR_WRONG_PASSWORD':
          return const RegisterMessageError(WrongPasswordError());
        case 'ERROR_USER_DISABLED':
          return const RegisterMessageError(UserDisabledError());
        case 'ERROR_USER_NOT_FOUND':
          return const RegisterMessageError(UserNotFoundError());
        case 'ERROR_NETWORK_REQUEST_FAILED':
          return const RegisterMessageError(NetworkError());
        case 'ERROR_TOO_MANY_REQUESTS':
          return const RegisterMessageError(TooManyRequestsError());
        case 'ERROR_OPERATION_NOT_ALLOWED':
          return const RegisterMessageError(OperationNotAllowedError());
      }
    }
    return RegisterMessageError(UnknownError(error));
  }
}
