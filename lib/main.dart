import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/authentication_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_page.dart';
import 'package:find_room/pages/login_register/saved_page.dart';
import 'package:find_room/pages/saved/saved_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/core.dart';

Future<void> main() async {
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  Intl.defaultLocale = 'vi_VN';

  FirebaseAuth.instance
      .signInWithEmailAndPassword(
        email: 'hoc081098@gmail.com',
        password: '123456',
      )
      .then((user) => print('[DEBUG] user=$user'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phòng trọ tốt',
      theme: ThemeData(
        fontFamily: 'SF-Pro-Text',
        primaryColorDark: const Color(0xff00796B),
        primaryColorLight: const Color(0xffB2DFDB),
        primaryColor: const Color(0xff009688),
        accentColor: const Color(0xffFF5722),
        dividerColor: const Color(0xffBDBDBD),
      ),
      home: BlocProvider<AuthenticationBloc>(
        bloc: AuthenticationBloc(),
        child: BlocProvider<HomeBloc>(
          bloc: HomeBloc(),
          child: RootApp(),
        ),
      ),
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            StreamBuilder<Optional<UserEntity>>(
              initialData: authenticationBloc.user.value,
              builder: (
                BuildContext context,
                AsyncSnapshot<Optional<UserEntity>> snapshot,
              ) {
                Optional<UserEntity> data = snapshot.data;
                if (data.isPresent) {
                  return UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(data.value.avatar),
                    ),
                    accountEmail: Text(data.value.email),
                    accountName: Text(data.value.fullName),
                  );
                } else {
                  return UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      child: Icon(Icons.image),
                    ),
                    accountEmail: Text('Đăng nhập ngay'),
                    accountName: Container(),
                    onDetailsPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginRegisterPage(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              title: Text('Trang chủ'),
              onTap: () {},
              leading: Icon(Icons.home),
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
              leading: Icon(Icons.bookmark),
            ),
            Divider(),
            StreamBuilder<Optional<UserEntity>>(
              initialData: authenticationBloc.user.value,
              builder: (
                BuildContext context,
                AsyncSnapshot<Optional<UserEntity>> snapshot,
              ) {
                if (!snapshot.data.isPresent) {
                  return ListTile(
                    title: Text('Đăng nhập'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginRegisterPage(),
                        ),
                      );
                    },
                    leading: Icon(Icons.person_add),
                  );
                }
                return ListTile(
                  title: Text('Đăng xuất'),
                  onTap: () async {
                    Navigator.pop(context);

                    final bool signOut = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Đăng xuất'),
                          content: Text('Bạn chắc chắn muốn đăng xuất'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Hủy'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        );
                      },
                    );

                    if (signOut ?? false) {
                      FirebaseAuth.instance.signOut();
                    }
                  },
                  leading: Icon(Icons.exit_to_app),
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
