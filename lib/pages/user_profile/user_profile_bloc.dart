import 'dart:async';

import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/pages/user_profile/user_profile_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserProfileBloc implements BaseBloc {
  final ValueObservable<UserProfileState> state$;

  final void Function() _dispose;

  UserProfileBloc._(
    this._dispose, {
    @required this.state$,
  });

  @override
  void dispose() => _dispose();

  factory UserProfileBloc(
    final UserBloc userBloc,
    final FirebaseUserRepository userRepo,
    String uid,
  ) {
    final Observable<UserProfileState> userProfile$ = Observable.combineLatest2(
      userRepo.getUserBy(uid: uid),
      userBloc.loginState$,
      (UserEntity entity, LoginState loginState) {
        if (entity == null) {
          return UserProfileState((b) => b.isCurrentUser = false);
        }
        return UserProfileState((b) {
          b.profile
            ..avatar = entity.address
            ..fullName = entity.fullName
            ..email = entity.email
            ..phone = entity.phone
            ..address = entity.address
            ..isActive = entity.isActive
            ..createdAt = entity.createdAt.toDate()
            ..updatedAt = entity.updatedAt.toDate();
          b.isCurrentUser =
              loginState is LoggedInUser ? loginState.uid == entity.id : false;
        });
      },
    );
    final userProfileDistinct$ = publishValueSeededDistinct(
      userProfile$,
      seedValue: null, // loading state
    );

    final subscriptions = <StreamSubscription>[
      userProfileDistinct$
          .listen((state) => print('[USER_PROFILE_BLOC] state=$state')),
      userProfileDistinct$.connect(),
    ];

    return UserProfileBloc._(
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
      },
      state$: userProfileDistinct$,
    );
  }
}
