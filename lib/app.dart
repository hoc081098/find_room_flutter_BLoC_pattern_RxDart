import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/home/home_page.dart';
import 'package:find_room/pages/login_register/login_register.dart';
import 'package:find_room/pages/saved/saved_page.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phòng trọ tốt',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'SF-Pro-Text',
        primaryColorDark: const Color(0xff00796B),
        primaryColorLight: const Color(0xffB2DFDB),
        primaryColor: const Color(0xff009688),
        accentColor: const Color(0xffFF5722),
        dividerColor: const Color(0xffBDBDBD),
      ),
      home: RootApp(),
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildUserAccountsDrawerHeader(userBloc),
            ListTile(
              title: Text('Trang chủ'),
              onTap: () {},
              leading: Icon(Icons.home),
            ),
            _buildSavedListTile(userBloc),
            Divider(),
            _buildLoginLogoutButton(userBloc),
          ],
        ),
      ),
      body: MyHomePage(),
    );
  }

  Widget _buildSavedListTile(UserBloc userBloc) {
    return StreamBuilder<UserLoginState>(
      initialData: userBloc.user$.value,
      stream: userBloc.user$,
      builder: (
        BuildContext context,
        AsyncSnapshot<UserLoginState> snapshot,
      ) {
        if (snapshot.data is UserLogin) {
          return ListTile(
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
          );
        }

        if (snapshot.data is NotLogin) {
          return Container(
            width: 0,
            height: 0,
          );
        }
      },
    );
  }

  Widget _buildUserAccountsDrawerHeader(UserBloc userBloc) {
    return StreamBuilder<UserLoginState>(
      stream: userBloc.user$,
      initialData: userBloc.user$.value,
      builder: (
        BuildContext context,
        AsyncSnapshot<UserLoginState> snapshot,
      ) {
        final data = snapshot.data;

        if (data is UserLogin) {
          return UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(data.avatar),
            ),
            accountEmail: Text(data.email),
            accountName: Text(data.fullName),
          );
        }

        if (data is NotLogin) {
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
                  builder: (BuildContext context) => LoginRegisterPage(),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildLoginLogoutButton(UserBloc userBloc) {
    return StreamBuilder<UserLoginState>(
      stream: userBloc.user$,
      initialData: userBloc.user$.value,
      builder: (
        BuildContext context,
        AsyncSnapshot<UserLoginState> snapshot,
      ) {
        final data = snapshot.data;

        if (data is NotLogin) {
          return ListTile(
            title: Text('Đăng nhập'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginRegisterPage(),
                ),
              );
            },
            leading: Icon(Icons.person_add),
          );
        }

        if (data is UserLogin) {
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
                await FirebaseAuth.instance.signOut();
                print('Logout');
              }
            },
            leading: Icon(Icons.exit_to_app),
          );
        }

        if (data is Error) {
          return Container();
        }
      },
    );
  }
}
