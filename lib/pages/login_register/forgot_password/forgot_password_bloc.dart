import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/login_register/forgot_password/forgot_password_state.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

bool _isValidEmail(String email) {
  final _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
}

class ForgotPasswordBloc implements BaseBloc {
  ///
  /// Input [Function]s
  ///
  final void Function() submit;
  final void Function(String) emailChanged;

  ///
  /// Output [Stream]s
  ///
  final ValueStream<bool> isLoading$;
  final Stream<ForgotPasswordMessage> message$;
  final Stream<EmailError> emailError$;

  ///
  /// Clean up resources
  ///
  final void Function() _dispose;

  ForgotPasswordBloc._(
    this._dispose, {
    @required this.isLoading$,
    @required this.message$,
    @required this.emailError$,
    @required this.submit,
    @required this.emailChanged,
  });

  @override
  void dispose() => _dispose();

  factory ForgotPasswordBloc(final FirebaseUserRepository userRepo) {
    assert(userRepo != null, 'userRepo must be not null');

    // ignore_for_file: close_sinks
    final isLoadingSubject = BehaviorSubject.seeded(false);
    final emailSubject = BehaviorSubject.seeded('');
    final submitSubject = PublishSubject();

    final emailError$ = emailSubject.map<EmailError>((email) {
      if (_isValidEmail(email)) {
        return null;
      }
      return const InvalidEmailAddress();
    });

    final valid$ = submitSubject
        .withLatestFrom(
          emailSubject,
          (_, String email) => _isValidEmail(email),
        )
        .share();

    final message$ = Rx.merge<ForgotPasswordMessage>([
      valid$
          .doOnData((valid) => print('valid1=$valid'))
          .where((valid) => !valid)
          .map((_) => const InvalidInformation()),
      valid$
          .doOnData((valid) => print('valid2=$valid'))
          .where((valid) => valid)
          .withLatestFrom(
            emailSubject,
            (_, String email) => email,
          )
          .doOnData((email) => print('email=$email'))
          .doOnEach((error) => print('error=$error'))
          .exhaustMap(
            (email) => performSendEmail(
              email,
              userRepo,
              isLoadingSubject,
            ),
          ),
    ]).publish();

    final subscriptions = [
      emailSubject
          .listen((email) => print('[FORGOT_PASSWORD_BLOC] email=$email')),
      emailError$.listen((emailError) =>
          print('[FORGOT_PASSWORD_BLOC] emailError=$emailError')),
      message$.listen(
          (message) => print('[FORGOT_PASSWORD_BLOC] message=$message')),
      message$.connect(),
    ];
    final controllers = <StreamController>[
      isLoadingSubject,
      submitSubject,
      emailSubject,
    ];

    return ForgotPasswordBloc._(
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
        print('[FORGOT_PASSWORD_BLOC] disposed');
      },
      isLoading$: isLoadingSubject.stream,
      message$: message$,
      emailError$: emailError$,
      submit: () => submitSubject.add(null),
      emailChanged: emailSubject.add,
    );
  }

  static Stream<ForgotPasswordMessage> performSendEmail(
    String email,
    FirebaseUserRepository userRepo,
    Sink<bool> isLoadingSink,
  ) async* {
    print('[FORGOT_PASSWORD_BLOC] performSendEmail');
    isLoadingSink.add(true);

    try {
      await userRepo.sendPasswordResetEmail(email);
      yield const SendPasswordResetEmailSuccess();
    } catch (e) {
      if (e is PlatformException) {
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            yield const SendPasswordResetEmailFailure(InvalidEmailError());
            break;
          case 'ERROR_USER_NOT_FOUND':
            yield const SendPasswordResetEmailFailure(UserNotFoundError());
            break;
        }
      } else {
        yield SendPasswordResetEmailFailure(UnknownError(e));
      }
    } finally {
      isLoadingSink.add(false);
    }
  }
}
