import 'dart:async';

import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<void> signOut;

  ///
  /// Streams
  ///
  final ValueStream<LoginState> loginState$;
  final Stream<UserMessage> message$;

  ///
  /// Return current user [LoggedInUser] if logged in, otherwise return null
  ///
  final LoggedInUser Function() currentUser;

  ///Cleanup
  final void Function() _dispose;

  factory AuthBloc(FirebaseUserRepository userRepository) {
    final signOutController = PublishSubject<void>(sync: true);

    final user$ = userRepository
        .user()
        .map(_toLoginState)
        .distinct()
        .publishValueSeeded(const Unauthenticated());

    final signOutMessage$ = signOutController.exhaustMap((_) {
      return Stream.fromFuture(userRepository.signOut())
          .doOnError((e) => print('[DEBUG] logout error=$e'))
          .onErrorReturnWith((e) => UserLogoutMessageError(e))
          .map((_) => const UserLogoutMessageSuccess());
    }).publish();

    final subscriptions = <StreamSubscription<dynamic>>[
      user$.connect(),
      signOutMessage$.connect(),
    ];

    return AuthBloc._(
      () {
        signOutController.close();
        subscriptions.forEach((subscription) => subscription.cancel());
      },
      user$,
      signOutController.sink,
      signOutMessage$,
      () {
        final loginState = user$.value;
        if (loginState == null || loginState is Unauthenticated) return null;
        if (loginState is LoggedInUser) return loginState;
        return null;
      },
    );
  }

  AuthBloc._(
    this._dispose,
    this.loginState$,
    this.signOut,
    this.message$,
    this.currentUser,
  );

  @override
  void dispose() => _dispose();

  static LoginState _toLoginState(UserEntity userEntity) {
    if (userEntity == null) {
      return const Unauthenticated();
    }
    return LoggedInUser(
      avatar: userEntity.avatar,
      fullName: userEntity.fullName,
      email: userEntity.email,
      uid: userEntity.id,
      isActive: userEntity.isActive,
      address: userEntity.address,
      createdAt: userEntity.createdAt?.toDate(),
      updatedAt: userEntity.updatedAt?.toDate(),
      phone: userEntity.phone,
    );
  }
}
