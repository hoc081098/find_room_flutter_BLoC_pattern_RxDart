import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseUserRepositoryImpl implements FirebaseUserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  const FirebaseUserRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<UserEntity> user() {
    return Observable(_firebaseAuth.onAuthStateChanged)
        .switchMap(_toUserEntity);
  }

  Stream<UserEntity> _toUserEntity(FirebaseUser firebaseUser) {
    final uid = firebaseUser?.uid;
    if (uid == null) {
      return Observable.just(null);
    }
    return Observable(_firestore.document('users/$uid').snapshots())
        .map((snapshot) => UserEntity.fromDocumentSnapshot(snapshot));
  }
}
