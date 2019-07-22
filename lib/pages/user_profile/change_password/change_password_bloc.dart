import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

abstract class PasswordError {
  const PasswordError._();
  const factory PasswordError.passwordLengthLessThan6Chars() =
      _PasswordLengthLessThan6Chars;
}

class _PasswordLengthLessThan6Chars extends PasswordError {
  const _PasswordLengthLessThan6Chars() : super._();
}

///
///
///
///

abstract class ChangePasswordMessage {}

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

    final passwordError$ = passwordSubject.map((password) {
      if (password == null || password.length < 6) {
        return const PasswordError.passwordLengthLessThan6Chars();
      }
      return null;
    }).share();

    final submit$ = submitSubject.withLatestFrom(
      passwordError$,
      (_, error) => error == null,
    );

    final message$ = Observable.merge(
      [
        submit$.where((isValid) => isValid).exhaustMap((_) {}),
        submit$.where((isValid) => !isValid).map(() {}),
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
