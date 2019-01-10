import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BaseBloc {
  final StreamSubscription<UserLoginState> _subscription;
  final ValueObservable<UserLoginState> user;

  factory UserBloc() {
    final user$ = Observable(FirebaseAuth.instance.onAuthStateChanged)
        .switchMap(_toLoginState)
        .distinct()
        .publishValue(seedValue: const NotLogin());
    return UserBloc._(user$.connect(), user$);
  }

  UserBloc._(this._subscription, this.user);

  @override
  void dispose() {
    _subscription.cancel();
  }

  static Stream<UserLoginState> _toLoginState(FirebaseUser user) {
    final uid = user?.uid;
    print('[DEBUG] mapper uid=$uid');

    if (uid == null) {
      return Observable.just(const NotLogin());
    }
    return Observable(Firestore.instance.document('users/$uid').snapshots())
        .map((snapshot) => UserEntity.fromDocument(snapshot))
        .map<UserLoginState>(
          (userEntity) => UserLogin(
                avatar: userEntity.avatar,
                fullName: userEntity.fullName,
                email: userEntity.email,
                id: userEntity.id,
              ),
        )
        .onErrorReturnWith((error) => ErrorState(error));
  }
}
