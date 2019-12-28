import 'dart:async';

import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_state.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

// ignore_for_file: close_sinks

class ChangePasswordBloc implements BaseBloc {
  ///
  /// Outputs
  ///
  final Stream<PasswordError> passwordError$;
  final Stream<ChangePasswordMessage> message$;
  final ValueStream<bool> isLoading$;

  ///
  /// Inputs
  ///
  final void Function(String) passwordChanged;
  final void Function() submit;

  ///
  /// Clean up
  ///
  final void Function() _dispose;

  @override
  void dispose() => _dispose();

  ChangePasswordBloc._(
    this._dispose, {
    @required this.passwordError$,
    @required this.passwordChanged,
    @required this.submit,
    @required this.isLoading$,
    @required this.message$,
  });

  factory ChangePasswordBloc({
    @required String uid,
    @required FirebaseUserRepository userRepo,
    @required AuthBloc authBloc,
  }) {
    ///
    /// Asserts
    ///
    assert(uid != null, 'uid cannot be null');
    assert(userRepo != null, 'userRepo cannot be null');
    assert(authBloc != null, 'authBloc cannot be null');
    final currentUser = authBloc.currentUser();
    assert(currentUser?.uid == uid, 'User is not logged in or invalid user id');

    ///
    /// Stream controllers
    ///
    final passwordSubject = BehaviorSubject.seeded('');
    final submitSubject = PublishSubject<void>();
    final isLoadingSubject = BehaviorSubject.seeded(false);

    ///
    /// Map password string to password error
    ///
    final passwordError$ = passwordSubject.map(
      (password) {
        if (password == null || password.length < 6) {
          return PasswordError.passwordLengthLessThan6Chars();
        }
        return PasswordError.none();
      },
    ).share();

    final submit$ = submitSubject
        .withLatestFrom(
          passwordError$,
          (_, PasswordError error) => error.join((_) => false, () => true),
        )
        .share();

    getError(e) {
      if (e is PlatformException) {
        switch (e.code) {
          case 'ERROR_WEAK_PASSWORD':
            return ChangePasswordError.weakPassword();
          case 'ERROR_USER_DISABLED':
            return ChangePasswordError.userDisabled();
          case 'ERROR_USER_NOT_FOUND':
            return ChangePasswordError.userNotFound();
          case 'ERROR_REQUIRES_RECENT_LOGIN':
            return ChangePasswordError.requiresRecentLogin();
          case 'ERROR_OPERATION_NOT_ALLOWED':
            return ChangePasswordError.operationNotAllowed();
        }
      }
      return ChangePasswordError.unknownError(e);
    }

    final message$ = Rx.merge(
      [
        submit$.where((isValid) => isValid).exhaustMap(
          (_) {
            return Rx.defer(() => Stream.fromFuture(
                    userRepo.updatePassword(passwordSubject.value)))
                .doOnListen(() => isLoadingSubject.add(true))
                .map((_) => ChangePasswordMessage.changeSuccess())
                .onErrorReturnWith(
                    (e) => ChangePasswordMessage.changeFailure(getError(e)))
                .doOnDone(() => isLoadingSubject.add(false));
          },
        ),
        submit$
            .where((isValid) => !isValid)
            .map((_) => ChangePasswordMessage.invalidInformation()),
      ],
    ).publish();

    ///
    /// Keep references to dispose later
    ///
    final subscriptions = <StreamSubscription>[
      message$.listen(
          (message) => print('[CHANGE_PASSWORD_BLOC] message=$message')),
      message$.connect(),
    ];
    final controllers = <StreamController>[
      passwordSubject,
      submitSubject,
      isLoadingSubject,
    ];

    return ChangePasswordBloc._(
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
        print('[CHANGE_PASSWORD_BLOC] disposed');
      },
      passwordChanged: passwordSubject.add,
      passwordError$: passwordError$,
      submit: () => submitSubject.add(null),
      isLoading$: isLoadingSubject,
      message$: message$,
    );
  }
}
