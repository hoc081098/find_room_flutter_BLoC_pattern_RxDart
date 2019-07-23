import 'dart:async';
import 'dart:io';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc implements BaseBloc {
  final Stream<PasswordError> passwordError$;
  final Stream<ChangePasswordMessage> message$;
  final ValueObservable<bool> isLoading$;

  final void Function(String) passwordChanged;
  final void Function() submit;

  final void Function() _dispose;

  ChangePasswordBloc._(
    this._dispose, {
    @required this.passwordError$,
    @required this.passwordChanged,
    @required this.submit,
    @required this.isLoading$,
    @required this.message$,
  });

  @override
  void dispose() => _dispose();

  factory ChangePasswordBloc({
    @required String uid,
    @required FirebaseUserRepository userRepo,
    @required UserBloc userBloc,
  }) {
    ///
    /// Asserts
    ///
    assert(uid != null, 'uid cannot be null');
    assert(userRepo != null, 'userRepo cannot be null');
    assert(userBloc != null, 'userBloc cannot be null');
    final currentUser = userBloc.currentUser();
    assert(currentUser?.uid == uid, 'User is not logged in or invalid user id');

    final passwordSubject = BehaviorSubject.seeded('');
    final submitSubject = PublishSubject<void>();
    final isLoadingSubject = BehaviorSubject.seeded(false);

    final passwordError$ = passwordSubject.map(
      (password) {
        if (password == null || password.length < 6) {
          return PasswordError.passwordLengthLessThan6Chars();
        }
        return null;
      },
    ).share();

    final submit$ = submitSubject.withLatestFrom(
      passwordError$,
      (_, error) => error == null,
    );

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

    final message$ = Observable.merge(
      [
        submit$.where((isValid) => isValid).exhaustMap(
          (_) {
            return Observable.defer(() => Stream.fromFuture(
                    userRepo.updatePassword(passwordSubject.value)))
                .doOnListen(() => isLoadingSubject.add(true))
                .map((_) => ChangePasswordMessage.changeSuccess())
                .onErrorReturnWith(
                    (e) => ChangePasswordMessage.changeFaiulre(getError(e)))
                .doOnDone(() => isLoadingSubject.add(false));
          },
        ),
        submit$
            .where((isValid) => !isValid)
            .map((_) => ChangePasswordMessage.invalidInformation()),
      ],
    ).publish();

    final subscriptions = <StreamSubscription>[
      message$.connect(),
    ];

    return ChangePasswordBloc._(
      () async {},
      passwordChanged: passwordSubject.add,
      passwordError$: passwordError$,
      submit: () => submitSubject.add(null),
      isLoading$: isLoadingSubject,
      message$: message$,
    );
  }
}
