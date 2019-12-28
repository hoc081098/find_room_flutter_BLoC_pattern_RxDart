import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/login_register/login_state.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

///
/// BLoC handling google sign in
///
class GoogleSignInBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<void> submitLogin;

  ///
  /// Streams
  ///
  final ValueStream<bool> isLoading$;
  final Stream<LoginMessage> message$;

  ///
  /// Clean up
  ///
  final void Function() _dispose;

  GoogleSignInBloc._({
    @required this.isLoading$,
    @required this.message$,
    @required this.submitLogin,
    @required void Function() dispose,
  }) : this._dispose = dispose;

  factory GoogleSignInBloc(FirebaseUserRepository userRepository) {
    ///
    ///Assert
    ///
    assert(userRepository != null, 'userRepository cannot be null');

    ///
    /// Controllers
    ///
    //ignore: close_sinks
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    ///
    /// Streams
    ///
    final message$ = submitLoginController.stream
        .exhaustMap((_) => performLogin(userRepository, isLoadingController))
        .publish();

    ///
    /// Subscriptions and controllers
    ///
    final subscriptions = <StreamSubscription>[
      message$.connect(),
    ];
    final controllers = <StreamController>[
      submitLoginController,
      isLoadingController,
    ];

    return GoogleSignInBloc._(
      isLoading$: isLoadingController.stream,
      message$: message$,
      submitLogin: submitLoginController.sink,
      dispose: () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
    );
  }

  static Stream<LoginMessage> performLogin(
    FirebaseUserRepository userRepository,
    Sink<bool> isLoadingController,
  ) async* {
    isLoadingController.add(true);
    try {
      await userRepository.googleSignIn();
      yield const LoginMessageSuccess();
    } catch (e) {
      yield _getLoginError(e);
    }
    isLoadingController.add(false);
  }

  @override
  void dispose() => _dispose();

  static LoginMessageError _getLoginError(error) {
    if (error is PlatformException) {
      switch (error.code) {
        case GoogleSignIn.kSignInCanceledError:
          return const LoginMessageError(GoogleSignInCanceledError());
        case 'ERROR_INVALID_CREDENTIAL':
          return const LoginMessageError(InvalidCredentialError());
        case 'ERROR_USER_DISABLED':
          return const LoginMessageError(UserDisabledError());
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          return const LoginMessageError(
              AccountExistsWithDifferenceCredentialError());
        case 'ERROR_OPERATION_NOT_ALLOWED':
          return const LoginMessageError(OperationNotAllowedError());
      }
    }
    return LoginMessageError(UnknownError(error));
  }
}
