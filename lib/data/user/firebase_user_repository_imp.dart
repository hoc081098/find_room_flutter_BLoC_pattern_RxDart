import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseUserRepositoryImpl implements FirebaseUserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookSignIn;
  final FirebaseStorage _firebaseStorage;

  const FirebaseUserRepositoryImpl(
    this._firebaseAuth,
    this._firestore,
    this._googleSignIn,
    this._facebookSignIn,
    this._firebaseStorage,
  );

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

  @override
  Future<void> signOut() async {
    await _facebookSignIn.logOut();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> signInWithEmailAndPassword({String email, String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> googleSignIn() async {
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw PlatformException(code: GoogleSignIn.kSignInCanceledError);
    }

    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;
    final FirebaseUser firebaseUser = await _firebaseAuth.signInWithCredential(
      GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );

    await _updateUserData(firebaseUser);
  }

  Future<void> _updateUserData(
    FirebaseUser user, [
    Map<String, dynamic> addition,
  ]) {
    return _firestore.document('users/${user.uid}').setData(
      <String, dynamic>{
        'email': user.email,
        'phone': user.phoneNumber,
        'full_name': user.displayName,
        'avatar': user.photoUrl,
        ...?addition,
      },
      merge: true,
    );
  }

  @override
  Future<FacebookLoginResult> facebookSignIn() async {
    final FacebookLoginResult result =
        await _facebookSignIn.logInWithReadPermissions(['email']);
    final token = result?.accessToken?.token;
    if (token != null) {
      final FirebaseUser firebaseUser =
          await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token),
      );
      _updateUserData(firebaseUser);
    }
    return result;
  }

  @override
  Future<void> registerWithEmail({
    @required String fullName,
    @required String email,
    @required String password,
    @required String address,
    @required String phoneNumber,
    File avatar,
  }) async {
    if (fullName == null) return Future.error('fullName must be not null');
    if (email == null) return Future.error('email must be not null');
    if (password == null) return Future.error('password must be not null');
    if (address == null) return Future.error('address must be not null');
    if (phoneNumber == null)
      return Future.error('phoneNumber must be not null');

    final firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (avatar != null) {
      final uploadTask = _firebaseStorage
          .ref()
          .child('avatar_images')
          .child(firebaseUser.uid)
          .putFile(avatar);
      await uploadTask.onComplete;

      if (uploadTask.isSuccessful) {
        final photoUrl = await uploadTask.lastSnapshot.ref.getDownloadURL();
        await firebaseUser.updateProfile(
          UserUpdateInfo()
            ..displayName = fullName
            ..photoUrl = photoUrl,
        );
      }
    }

    await _updateUserData(
      firebaseUser,
      <String, dynamic>{'address': address},
    );
  }
}
