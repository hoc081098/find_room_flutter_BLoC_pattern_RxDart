import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc implements BaseBloc {
  final _userController =
      BehaviorSubject<Optional<UserEntity>>(seedValue: Optional.absent());
  StreamSubscription<dynamic> _subscription;
  ValueObservable<Optional<UserEntity>> _user$;

  ValueObservable<Optional<UserEntity>> get user => _user$;

  AuthenticationBloc() {
    final Stream<Optional<UserEntity>> Function(FirebaseUser) mapper = (user) {
      final uid = user?.uid;

      print('[DEBUG] mapper uid=$uid');

      if (uid == null) {
        return Observable.just(Optional.absent());
      }
      return Firestore.instance
          .document('users/$uid')
          .snapshots()
          .map((snapshot) => UserEntity.fromDocument(snapshot))
          .map((userEntity) => Optional.fromNullable(userEntity));
    };
    _subscription = Observable(FirebaseAuth.instance.onAuthStateChanged)
        .switchMap(mapper)
        .doOnData((data) => print('[DEBUG] user=$data'))
        .listen(_userController.add);

    _user$ =
        _userController.distinct().shareValue(seedValue: Optional.absent());
  }

  @override
  void dispose() {
    _subscription.cancel();
    _userController.close();
  }
}
