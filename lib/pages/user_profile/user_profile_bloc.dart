import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/pages/user_profile/user_profile_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

  factory UserProfileBloc({
    @required final UserBloc userBloc,
    @required final FirebaseUserRepository userRepo,
    @required final FirestoreRoomRepository roomsRepo,
    @required final String uid,
    @required final NumberFormat priceFormat,
  }) {
    final rooms$ =
        roomsRepo.postedList(uid: uid).map((rooms) {
      final items = rooms.map(
        (r) => UserProfileRoomItem((b) => b
          ..id = r.id
          ..title = r.title
          ..address = r.address
          ..districtName = r.districtName
          ..image = r.images.first
          ..price = priceFormat.format(r.price)
          ..createdTime = r.createdAt.toDate()
          ..updatedTime = r.updatedAt.toDate()),
      );
      return BuiltList<UserProfileRoomItem>.of(items);
    });

    final Observable<UserProfileState> userProfile$ = Observable.combineLatest3(
      userRepo.getUserBy(uid: uid),
      userBloc.loginState$,
      rooms$,
      (
        UserEntity entity,
        LoginState loginState,
        BuiltList<UserProfileRoomItem> rooms,
      ) {
        // if user does not exist
        if (entity == null) {
          return UserProfileState(
            (b) => b
              ..isCurrentUser = false
              ..postedRooms = ListBuilder<UserProfileRoomItem>(),
          );
        }
        return UserProfileState((b) {
          b.profile
            ..uid = entity.id
            ..avatar = entity.avatar
            ..fullName = entity.fullName
            ..email = entity.email
            ..phone = entity.phone
            ..address = entity.address
            ..isActive = entity.isActive
            ..createdAt = entity.createdAt.toDate()
            ..updatedAt = entity.updatedAt.toDate();
          b.isCurrentUser =
              loginState is LoggedInUser ? loginState.uid == entity.id : false;
          b.postedRooms = rooms.toBuilder();
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
