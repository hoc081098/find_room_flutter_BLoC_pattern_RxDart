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
    return _firebaseAuth.onAuthStateChanged
        .switchMap((user) => _getUserByUid$(user?.uid));
  }

  Stream<UserEntity> _getUserByUid$(String uid) {
    if (uid == null) {
      return Stream.value(null);
    }
    return _firestore.document('users/$uid').snapshots().map((snapshot) =>
        snapshot.exists ? UserEntity.fromDocumentSnapshot(snapshot) : null);
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
    final FirebaseUser firebaseUser = (await _firebaseAuth.signInWithCredential(
      GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    ))
        .user;

    await _updateUserData(firebaseUser);
  }

  Future<void> _updateUserData(
    FirebaseUser user, [
    Map<String, dynamic> addition,
  ]) {
    final data = <String, dynamic>{
      'email': user.email,
      'full_name': user.displayName,
      'avatar': user.photoUrl,
      ...?addition
    };
    print('[USER_REPO] _updateUserData data=$data');
    return _firestore.document('users/${user.uid}').setData(data, merge: true);
  }

  @override
  Future<FacebookLoginResult> facebookSignIn() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);
    final token = result?.accessToken?.token;
    if (token != null) {
      final FirebaseUser firebaseUser =
          (await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token),
      ))
              .user;
      await _updateUserData(firebaseUser);
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
    if (phoneNumber == null) {
      return Future.error('phoneNumber must be not null');
    }
    print(
        '[USER_REPO] registerWithEmail fullName=$fullName, email=$email, password=$password'
        'address=$address, phoneNumber=$phoneNumber');

    // create firebase auth user and update displayName
    var firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    await firebaseUser.updateProfile(UserUpdateInfo()..displayName = fullName);
    firebaseUser = await _firebaseAuth.currentUser();

    // then save to firestore user info and address
    await _updateUserData(
      firebaseUser,
      <String, dynamic>{
        'address': address,
        'phone': phoneNumber,
        'is_active': true,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      },
    );
    print('[USER_REPO] registerWithEmail firebaseUser=$firebaseUser');

    // if avatar is present
    if (avatar != null) {
      // upload image to firebase storage
      final uploadTask = _firebaseStorage
          .ref()
          .child('avatar_images')
          .child(firebaseUser.uid)
          .putFile(avatar);
      await uploadTask.onComplete;

      // if upload task is successful
      if (uploadTask.isSuccessful) {
        // get photo url
        final String photoUrl =
            await uploadTask.lastSnapshot.ref.getDownloadURL();
        print('[USER_REPO] registerWithEmail photoUrl=$photoUrl');

        // update firebase user info with photo url and save to firestore
        await firebaseUser.updateProfile(UserUpdateInfo()..photoUrl = photoUrl);
        firebaseUser = await _firebaseAuth.currentUser();
        await _updateUserData(firebaseUser);
      }
    }

    print('[USER_REPO] registerWithEmail done');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    if (email == null) return Future.error('email must be not null');
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<UserEntity> getUserBy({String uid}) => _getUserByUid$(uid);

  @override
  Future<void> updateUserInfo({
    String fullName,
    String address,
    String phoneNumber,
    File avatar,
  }) async {
    if (fullName == null) return Future.error('fullName must be not null');
    if (address == null) return Future.error('address must be not null');
    if (phoneNumber == null) {
      return Future.error('phoneNumber must be not null');
    }

    print('[USER_REPO] updateUserInfo fullName=$fullName, address=$address, '
        'phoneNumber=$phoneNumber, avatar=$avatar');

    var firebaseUser = await _firebaseAuth.currentUser();

    // update display name of firebase user
    await firebaseUser.updateProfile(UserUpdateInfo()..displayName = fullName);
    firebaseUser = await _firebaseAuth.currentUser();

    // then save to firestore user info and address
    await _updateUserData(
      firebaseUser,
      <String, dynamic>{
        'address': address,
        'phone': phoneNumber,
        'is_active': true,
        'updated_at': FieldValue.serverTimestamp(),
      },
    );

    // if avatar is present
    if (avatar != null) {
      // upload image to firebase storage
      final uploadTask = _firebaseStorage
          .ref()
          .child('avatar_images')
          .child(firebaseUser.uid)
          .putFile(avatar);
      await uploadTask.onComplete;

      // if upload task is successful
      if (uploadTask.isSuccessful) {
        // get photo url
        final String photoUrl =
            await uploadTask.lastSnapshot.ref.getDownloadURL();
        print('[USER_REPO] updateUserInfo photoUrl=$photoUrl');

        // update firebase user info with photo url and save to firestore
        await firebaseUser.updateProfile(UserUpdateInfo()..photoUrl = photoUrl);
        firebaseUser = await _firebaseAuth.currentUser();
        await _updateUserData(firebaseUser);
      }
    }

    print('[USER_REPO] updateUserInfo done');
  }

  @override
  Future<void> updatePassword(String password) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      return Future.error('User not signed-in');
    }
    await user.updatePassword(password);
    print('[USER_REPO] updatePassword done');
  }
}
