import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/bloc/home_bloc.dart';
import 'package:find_room/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

main() async {
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  Intl.defaultLocale = 'vi_VN';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new BlocProvider<HomeBloc>(
        child: MyHomePage(),
        bloc: HomeBloc(),
      ),
    );
  }
}
