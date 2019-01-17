import 'dart:async';

import 'package:find_room/models/user_entity.dart';
import 'package:meta/meta.dart';

abstract class FirebaseUserRepository {
  Stream<UserEntity> user();

  Future<void> signOut();

  Future<void>  signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> googleSignIn();
}
