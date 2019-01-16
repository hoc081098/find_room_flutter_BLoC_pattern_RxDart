import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BaseBloc {
  ///Streams and sinks
  final ValueObservable<UserLoginState> user$;
  final Sink<void> signOut;

  ///Cleanup
  final void Function() _dispose;

  factory UserBloc(FirebaseUserRepository userRepository) {
    final signOutController = PublishSubject<void>(sync: true);

    final user$ = Observable(userRepository.user())
        .map(_toLoginState)
        .distinct()
        .publishValue(seedValue: const NotLogin());

    final subscriptions = <StreamSubscription<dynamic>>[
      signOutController
          .concatMap((_) => Observable.fromFuture(userRepository.signOut()))
          .listen(null),
      user$.connect(),
    ];

    return UserBloc._(
      () {
        signOutController.close();
        subscriptions.forEach((subscription) => subscription.cancel());
      },
      user$,
      signOutController.sink,
    );
  }

  UserBloc._(this._dispose, this.user$, this.signOut);

  @override
  void dispose() => _dispose();

  static UserLoginState _toLoginState(UserEntity userEntity) {
    if (userEntity == null) {
      return const NotLogin();
    }
    return UserLogin(
      avatar: userEntity.avatar,
      fullName: userEntity.fullName,
      email: userEntity.email,
      uid: userEntity.id,
    );
  }
}
