import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/app/app.dart';
import 'package:find_room/app/page_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/banners/firestore_banner_repository_impl.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository_impl.dart';
import 'package:find_room/data/rooms/firestore_room_repository_impl.dart';
import 'package:find_room/data/user/firebase_user_repository_imp.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/shared_pref_util.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  final firestore = Firestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  ///
  ///Setup
  ///
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  Intl.defaultLocale = 'vi_VN';

  ///
  /// Test login
  ///
  firebaseAuth.signInWithEmailAndPassword(
    email: 'hoc081098@gmail.com',
    password: '123456',
  );

  final priceFormat = NumberFormat.currency();
  final userRepository = FirebaseUserRepositoryImpl(firebaseAuth, firestore);
  final roomRepository = FirestoreRoomRepositoryImpl(firestore);
  final bannerRepository = FirestoreBannerRepositoryImpl(firestore);
  final provinceDistrictWardRepository =
      ProvinceDistrictWardRepositoryImpl(firestore);
  final sharedPrefUtil = SharedPrefUtil.instance;

  final userBloc = UserBloc(userRepository);
  final pageBloc = PageBloc(userBloc: userBloc);
  final homeBloc = HomeBloc(
    sharedPrefUtil: sharedPrefUtil,
    userBloc: userBloc,
    roomRepository: roomRepository,
    bannerRepository: bannerRepository,
    provinceDistrictWardRepository: provinceDistrictWardRepository,
    priceFormat: priceFormat,
  );

  runApp(
    Injector(
      userRepository: userRepository,
      child: BlocProvider<UserBloc>(
        bloc: userBloc,
        child: BlocProvider<PageBloc>(
          bloc: pageBloc,
          child: BlocProvider<HomeBloc>(
            bloc: homeBloc,
            child: MyApp(),
          ),
        ),
      ),
    ),
  );
}
