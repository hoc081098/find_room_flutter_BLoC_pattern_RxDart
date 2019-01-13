import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BaseBloc {
  final StreamSubscription<UserLoginState> _subscription;
  final ValueObservable<UserLoginState> user$;

  factory UserBloc(FirebaseUserRepository userRepository) {
    final user$ = Observable(userRepository.user())
        .map(_toLoginState)
        .distinct()
        .publishValue(seedValue: const NotLogin());
    return UserBloc._(user$.connect(), user$);
  }

  UserBloc._(this._subscription, this.user$);

  @override
  void dispose() {
    _subscription.cancel();
  }

  static UserLoginState _toLoginState(UserEntity userEntity) {
    return userEntity == null
        ? const NotLogin()
        : UserLogin(
            avatar: userEntity.avatar,
            fullName: userEntity.fullName,
            email: userEntity.email,
            id: userEntity.id,
          );
  }
}
