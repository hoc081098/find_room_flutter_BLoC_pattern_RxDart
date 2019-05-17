import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/user_profile/user_profile_state.dart';
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
    final FirebaseUserRepository userRepo,
    String uid,
  ) {
    return UserProfileBloc._(
      () async {},
      state$: null,
    );
  }
}
