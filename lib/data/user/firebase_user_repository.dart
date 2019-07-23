import 'dart:async';
import 'dart:io';

import 'package:find_room/models/user_entity.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:meta/meta.dart';

abstract class FirebaseUserRepository {
  Stream<UserEntity> user();

  Future<void> signOut();

  Future<void> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> googleSignIn();

  Future<FacebookLoginResult> facebookSignIn();

  Future<void> registerWithEmail({
    @required String fullName,
    @required String email,
    @required String password,
    @required String address,
    @required String phoneNumber,
    File avatar,
  });

  Future<void> sendPasswordResetEmail(String email);

  Stream<UserEntity> getUserBy({@required String uid});

  Future<void> updateUserInfo({
    @required String fullName,
    @required String address,
    @required String phoneNumber,
    File avatar,
  });

  Future<void> updatePassword(String password);
}
