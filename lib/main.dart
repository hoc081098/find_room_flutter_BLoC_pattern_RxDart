import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_page.dart';
import 'package:find_room/pages/saved/saved_page.dart';
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
      title: 'Phòng trọ tốt',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider<HomeBloc>(
        bloc: HomeBloc(),
        child: RootApp(),
      ),
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('hoc081098@gmail.com'),
              accountName: Text('Petrus'),
            ),
            ListTile(
              title: Text('Trang chủ'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Đã lưu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SavedPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: MyHomePage(),
    );
  }
}
