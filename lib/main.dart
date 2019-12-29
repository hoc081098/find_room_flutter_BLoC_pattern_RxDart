import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/app/app.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/banners/firestore_banner_repository_impl.dart';
import 'package:find_room/data/local/shared_pref_util.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository_impl.dart';
import 'package:find_room/data/room_comments/room_comments_repository_impl.dart';
import 'package:find_room/data/rooms/firestore_room_repository_impl.dart';
import 'package:find_room/data/user/firebase_user_repository_imp.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firestore = Firestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  ///
  /// Price formatter for Vietnam Dong(VND)
  ///
  final priceFormat = NumberFormat.currency(locale: 'vi_VN');

  final userRepository = FirebaseUserRepositoryImpl(
    firebaseAuth,
    firestore,
    googleSignIn,
    facebookLogin,
    firebaseStorage,
  );
  final roomRepository = FirestoreRoomRepositoryImpl(firestore);
  final bannerRepository = FirestoreBannerRepositoryImpl(firestore);
  final provinceDistrictWardRepository = ProvinceDistrictWardRepositoryImpl(
    firestore,
  );
  final roomCommentsRepository = RoomCommentsRepositoryImpl(firestore);
  final localDataSource = SharedPrefUtil(SharedPreferences.getInstance());

  final authBloc = AuthBloc(userRepository);
  final homeBloc = HomeBloc(
    localData: localDataSource,
    authBloc: authBloc,
    roomRepository: roomRepository,
    bannerRepository: bannerRepository,
    provinceDistrictWardRepository: provinceDistrictWardRepository,
    priceFormat: priceFormat,
  );
  final localeBloc = LocaleBloc(localDataSource);

  // change debug/release mode
  const debug = true;

  runApp(
    Injector(
      debug: debug,
      userRepository: userRepository,
      roomRepository: roomRepository,
      priceFormat: priceFormat,
      localDataSource: localDataSource,
      roomCommentsRepository: roomCommentsRepository,
      child: BlocProvider<AuthBloc>(
        blocSupplier: () => authBloc,
        child: BlocProvider<HomeBloc>(
          blocSupplier: () => homeBloc,
          child: BlocProvider<LocaleBloc>(
            blocSupplier: () => localeBloc,
            child: MyApp(),
          ),
        ),
      ),
    ),
  );
}
