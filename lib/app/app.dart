import 'dart:async';

import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_page.dart';
import 'package:find_room/pages/login_register/login_page.dart';
import 'package:find_room/pages/saved/saved_bloc.dart';
import 'package:find_room/pages/saved/saved_page.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';

class MyApp extends StatelessWidget {
  final appTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'SF-Pro-Text',
    primaryColorDark: const Color(0xff512DA8),
    primaryColorLight: const Color(0xffD1C4E9),
    primaryColor: const Color(0xff673AB7),
    accentColor: const Color(0xff00BCD4),
    dividerColor: const Color(0xffBDBDBD),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localeBloc = BlocProvider.of<LocaleBloc>(context);

    return StreamBuilder<Locale>(
        stream: localeBloc.locale$,
        initialData: localeBloc.locale$.value,
        builder: (context, snapshot) {
          print('[DEBUG] locale = ${snapshot.data}');

          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              width: double.infinity,
              height: double.infinity,
            );
          }

          return MaterialApp(
            locale: snapshot.data,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: [
              S.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            localeResolutionCallback:
                S.delegate.resolution(fallback: const Locale('en', '')),
            onGenerateTitle: (context) => S.of(context).app_title,
            theme: appTheme,
            builder: (BuildContext context, Widget child) {
              print('[DEBUG] App builder');
              return Scaffold(
                drawer: MyDrawer(
                  navigator: child.key as GlobalKey<NavigatorState>,
                ),
                body: BodyChild(child: child),
              );
            },
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (context) {
                return MyHomePage(
                  homeBloc: BlocProvider.of<HomeBloc>(context),
                );
              },
              '/saved': (context) {
                return SavedPage(
                  initSavedBloc: () {
                    return SavedBloc(
                      userBloc: BlocProvider.of<UserBloc>(context),
                      roomRepository: Injector.of(context).roomRepository,
                      priceFormat: Injector.of(context).priceFormat,
                    );
                  },
                  userBloc: BlocProvider.of<UserBloc>(context),
                );
              },
              '/login': (context) {
                return LoginPage(
                  userBloc: BlocProvider.of<UserBloc>(context),
                  userRepository: Injector.of(context).userRepository,
                );
              },
            },
          );
        });
  }
}

class BodyChild extends StatefulWidget {
  final Widget child;

  const BodyChild({@required this.child, Key key}) : super(key: key);

  @override
  _BodyChildState createState() => _BodyChildState();
}

class _BodyChildState extends State<BodyChild> {
  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('[DEBUG] _BodyChildState didChangeDependencies');
    _subscription?.cancel();
    _subscription =
        BlocProvider.of<UserBloc>(context).signOutMessage$.listen((message) {
      RootScaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    });
  }

  @override
  void dispose() {
    print('[DEBUG] _BodyChildState dispose');
    _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[DEBUG] _BodyChildState build');
    return widget.child;
  }
}

class MyDrawer extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  const MyDrawer({Key key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('[DEBUG] MyDrawer build');

    final userBloc = BlocProvider.of<UserBloc>(context);

    final DrawerControllerState drawerControllerState =
        context.rootAncestorStateOfType(TypeMatcher<DrawerControllerState>());

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildUserAccountsDrawerHeader(
            userBloc.userLoginState$,
            drawerControllerState,
          ),
          ListTile(
            title: Text(S.of(context).home_page_title),
            onTap: () {
              drawerControllerState.close();
              navigator.currentState.popUntil(ModalRoute.withName('/'));
            },
            leading: Icon(Icons.home),
          ),
          _buildSavedListTile(
            userBloc.userLoginState$,
            drawerControllerState,
          ),
          Divider(),
          _buildLoginLogoutButton(
            userBloc,
            drawerControllerState,
          ),
        ],
      ),
    );
  }

  Widget _buildSavedListTile(
    ValueObservable<UserLoginState> loginState$,
    DrawerControllerState drawerControllerState,
  ) {
    return StreamBuilder<UserLoginState>(
      stream: loginState$,
      initialData: loginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is NotLogin) {
          return Container(
            width: 0,
            height: 0,
          );
        }

        if (loginState is UserLogin) {
          return ListTile(
            title: Text(S.of(context).saved_rooms_title),
            onTap: () {
              drawerControllerState.close();
              navigator.currentState.pushNamedAndRemoveUntil(
                '/saved',
                ModalRoute.withName('/'),
              );
            },
            leading: const Icon(Icons.bookmark),
          );
        }

        return Container(
          width: 0,
          height: 0,
        );
      },
    );
  }

  Widget _buildUserAccountsDrawerHeader(
    ValueObservable<UserLoginState> loginState$,
    DrawerControllerState drawerControllerState,
  ) {
    return StreamBuilder<UserLoginState>(
      stream: loginState$,
      initialData: loginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is UserLogin) {
          return UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(loginState.avatar),
              backgroundColor: Colors.white,
            ),
            accountEmail: Text(loginState.email),
            accountName: Text(loginState.fullName),
          );
        }

        if (loginState is NotLogin) {
          return UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: const Icon(Icons.image),
            ),
            accountEmail: Text(S.of(context).login_now),
            accountName: Container(),
            onDetailsPressed: () {
              drawerControllerState.close();
              navigator.currentState.pushNamedAndRemoveUntil(
                '/login',
                ModalRoute.withName('/'),
              );
            },
          );
        }

        return Container(width: 0, height: 0);
      },
    );
  }

  Widget _buildLoginLogoutButton(
    UserBloc userBloc,
    DrawerControllerState drawerControllerState,
  ) {
    return StreamBuilder<UserLoginState>(
      stream: userBloc.userLoginState$,
      initialData: userBloc.userLoginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is NotLogin) {
          return ListTile(
            title: Text(S.of(context).login_title),
            onTap: () {
              drawerControllerState.close();
              navigator.currentState.pushNamedAndRemoveUntil(
                '/login',
                ModalRoute.withName('/'),
              );
            },
            leading: const Icon(Icons.person_add),
          );
        }

        if (loginState is UserLogin) {
          return ListTile(
            title: Text(S.of(context).logout),
            onTap: () async {
              drawerControllerState.close();

              final bool signOut = await showDialog<bool>(
                context: navigator.currentState.overlay.context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(S.of(context).logout),
                    content: Text(S.of(context).sure_want_to_logout),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(S.of(context).cancel),
                        onPressed: () => navigator.currentState.pop(false),
                      ),
                      FlatButton(
                        child: const Text('OK'),
                        onPressed: () => navigator.currentState.pop(true),
                      ),
                    ],
                  );
                },
              );

              if (signOut ?? false) {
                userBloc.signOut.add(null);
              }
            },
            leading: const Icon(Icons.exit_to_app),
          );
        }

        return Container(
          width: 0,
          height: 0,
        );
      },
    );
  }
}

class RootScaffold {
  RootScaffold._();

  static openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    scaffoldState.openDrawer();
  }

  static ScaffoldState of(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    return scaffoldState;
  }
}
