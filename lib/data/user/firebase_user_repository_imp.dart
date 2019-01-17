import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseUserRepositoryImpl implements FirebaseUserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;
  final GoogleSignIn _googleSignIn;

  const FirebaseUserRepositoryImpl(
    this._firebaseAuth,
    this._firestore,
    this._googleSignIn,
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
    final firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser.providerData
        .map((userInfo) => userInfo.providerId)
        .any((providerId) => providerId == 'facebook.com')) {}
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
      throw "Đã hủy đăng nhập bằng google";
    }
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;
    final FirebaseUser firebaseUser = await _firebaseAuth.signInWithGoogle(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    await _updateUserData(firebaseUser);
  }

  Future<void> _updateUserData(FirebaseUser user) {
    return _firestore.document('users/${user.uid}').setData(
      <String, dynamic>{
        'email': user.email,
        'phone': user.phoneNumber,
        'full_name': user.displayName,
        'avatar': user.photoUrl
      },
      merge: true,
    );
  }
}
