import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/detail/comments/comments_tab_bloc.dart';
import 'package:find_room/pages/detail/detail/room_detail_tab_bloc.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_bloc.dart';
import 'package:find_room/pages/detail/room_detail_bloc.dart';
import 'package:find_room/pages/detail/room_detail_page.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_page.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/pages/home/see_all/see_all_bloc.dart';
import 'package:find_room/pages/home/see_all/see_all_interactor.dart';
import 'package:find_room/pages/home/see_all/see_all_page.dart';
import 'package:find_room/pages/login_register/forgot_password/forgot_password_bloc.dart';
import 'package:find_room/pages/login_register/forgot_password/forgot_password_page.dart';
import 'package:find_room/pages/login_register/login_page.dart';
import 'package:find_room/pages/login_register/register/register_page.dart';
import 'package:find_room/pages/saved/saved_bloc.dart';
import 'package:find_room/pages/saved/saved_page.dart';
import 'package:find_room/pages/setting/setting_page.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_bloc.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_page.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_bloc.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_page.dart';
import 'package:find_room/pages/user_profile/user_profile_bloc.dart';
import 'package:find_room/pages/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class MyApp extends StatelessWidget {
  final appTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'SF-Pro-Text',
    primaryColorDark: const Color(0xff512DA8),
    primaryColorLight: const Color(0xffD1C4E9),
    primaryColor: const Color(0xff673AB7),
    accentColor: const Color(0xffFF5722),
    dividerColor: const Color(0xffBDBDBD),
  );

  final appRoutes = <String, WidgetBuilder>{
    '/': (context) {
      return MyHomePage(
        homeBloc: BlocProvider.of<HomeBloc>(context),
      );
    },
    '/settings': (context) {
      return SettingPage(
        localeBloc: BlocProvider.of<LocaleBloc>(context),
      );
    },
    '/saved': (context) {
      return SavedPage(
        initSavedBloc: () {
          return SavedBloc(
            authBloc: BlocProvider.of<AuthBloc>(context),
            roomRepository: Injector.of(context).roomRepository,
            priceFormat: Injector.of(context).priceFormat,
          );
        },
        authBloc: BlocProvider.of<AuthBloc>(context),
      );
    },
    '/login': (context) {
      return LoginPage(
        authBloc: BlocProvider.of<AuthBloc>(context),
        userRepository: Injector.of(context).userRepository,
      );
    },
    '/forgot_password': (context) {
      final userRepo = Injector.of(context).userRepository;

      return BlocProvider<ForgotPasswordBloc>(
        child: const ForgotPasswordPage(),
        blocSupplier: () => ForgotPasswordBloc(userRepo),
      );
    },
    '/register': (context) {
      return RegisterPage(
        userRepository: Injector.of(context).userRepository,
      );
    },
  };

  final RouteFactory onGenerateRoute = (routerSettings) {
    print('[onGenerateRoute] routerSettings=$routerSettings');

    if (routerSettings.name == '/user_profile') {
      return MaterialPageRoute(
        builder: (context) {
          print('[onGenerateRoute] /user_profile builder');

          final injector = Injector.of(context);
          return BlocProvider<UserProfileBloc>(
            blocSupplier: () {
              return UserProfileBloc(
                priceFormat: injector.priceFormat,
                roomsRepo: injector.roomRepository,
                uid: routerSettings.arguments as String,
                authBloc: BlocProvider.of<AuthBloc>(context),
                userRepo: injector.userRepository,
              );
            },
            child: const UserProfilePage(),
          );
        },
        settings: routerSettings,
      );
    }

    if (routerSettings.name == '/see_all') {
      return MaterialPageRoute(
        builder: (context) {
          print('[onGenerateRoute] /see_all builder');

          final injector = Injector.of(context);
          final interactor = SeeAllInteractor(
            injector.roomRepository,
            injector.priceFormat,
            injector.debug,
          );
          final seeAllQuery = routerSettings.arguments as SeeAllQuery;

          return BlocProvider<SeeAllBloc>(
            child: SeeAllPage(seeAllQuery),
            blocSupplier: () {
              return SeeAllBloc(
                interactor,
                injector.localDataSource,
                seeAllQuery,
              )..load.call();
            },
          );
        },
        settings: routerSettings,
      );
    }

    if (routerSettings.name == '/update_user_info') {
      return MaterialPageRoute(
        builder: (context) {
          print('[onGenerateRoute] /update_user_info builder');

          final userRepo = Injector.of(context).userRepository;
          final authBloc = BlocProvider.of<AuthBloc>(context);

          return BlocProvider<UpdateUserInfoBloc>(
            child: UpdateUserInfoPage(
              authBloc: authBloc,
            ),
            blocSupplier: () {
              return UpdateUserInfoBloc(
                uid: routerSettings.arguments as String,
                authBloc: authBloc,
                userRepo: userRepo,
              );
            },
          );
        },
        settings: routerSettings,
      );
    }

    if (routerSettings.name == '/change_password') {
      return MaterialPageRoute(
        builder: (context) {
          print('[onGenerateRoute] /change_password builder');

          final userRepo = Injector.of(context).userRepository;
          final authBloc = BlocProvider.of<AuthBloc>(context);

          return BlocProvider<ChangePasswordBloc>(
            child: const ChangePasswordPage(),
            blocSupplier: () {
              return ChangePasswordBloc(
                uid: routerSettings.arguments as String,
                authBloc: authBloc,
                userRepo: userRepo,
              );
            },
          );
        },
        settings: routerSettings,
      );
    }

    if (routerSettings.name == '/room_detail') {
      return MaterialPageRoute(
        builder: (context) {
          print('[onGenerateRoute] /room_detail/${routerSettings.arguments}');

          final roomId = routerSettings.arguments as String;
          final authBloc = BlocProvider.of<AuthBloc>(context);
          final injector = Injector.of(context);
          final localeBloc = BlocProvider.of<LocaleBloc>(context);

          final dateFormatter =
              DateFormat.yMd(localeBloc.locale$.value.languageCode).add_Hms();

          return BlocProvider<RoomDetailBloc>(
            blocSupplier: () {
              return RoomDetailBloc(
                roomRepository: injector.roomRepository,
                authBloc: authBloc,
                roomId: roomId,
                priceFormat: injector.priceFormat,
              );
            },
            child: BlocProvider<RoomDetailTabBloc>(
              blocSupplier: () {
                return RoomDetailTabBloc(
                  injector.roomRepository,
                  injector.userRepository,
                  injector.priceFormat,
                  roomId,
                  localeBloc,
                );
              },
              child: BlocProvider<CommentsTabBloc>(
                blocSupplier: () {
                  return CommentsTabBloc(
                    commentsRepository: injector.roomCommentsRepository,
                    roomId: roomId,
                    dateFormatter: dateFormatter,
                    authBloc: authBloc,
                  )..getComments.call();
                },
                child: BlocProvider<RelatedRoomsTabBloc>(
                  child: RoomDetailPage(),
                  blocSupplier: () {
                    return RelatedRoomsTabBloc(
                      injector.roomRepository,
                      injector.priceFormat,
                      roomId,
                    )..fetch.call();
                  },
                ),
              ),
            ),
          );
        },
        settings: routerSettings,
      );
    }

    /// The other paths we support are in the routes table.
    return null;
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final localeBloc = BlocProvider.of<LocaleBloc>(context);

    return StreamBuilder<Locale>(
      stream: localeBloc.locale$,
      initialData: localeBloc.locale$.value,
      builder: (context, snapshot) {
        print('[APP_LOCALE] locale = ${snapshot.data}');

        if (!snapshot.hasData) {
          return Container(
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
              body: BodyChild(
                child: child,
                authBloc: BlocProvider.of<AuthBloc>(context),
              ),
            );
          },
          initialRoute: '/',
          routes: appRoutes,
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}

class BodyChild extends StatefulWidget {
  final Widget child;
  final AuthBloc authBloc;

  const BodyChild({
    @required this.child,
    @required this.authBloc,
    Key key,
  }) : super(key: key);

  @override
  _BodyChildState createState() => _BodyChildState();
}

class _BodyChildState extends State<BodyChild> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    print('[DEBUG] _BodyChildState initState');

    _subscription = widget.authBloc.message$.listen((message) {
      final s = S.of(context);
      if (message is UserLogoutMessage) {
        if (message is UserLogoutMessageSuccess) {
          _showSnackBar(s.logout_success);
        }
        if (message is UserLogoutMessageError) {
          print('[DEBUG] logout error=${message.error}');
          _showSnackBar(s.logout_error);
        }
      }
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  const MyDrawer({Key key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('[DEBUG] MyDrawer build');

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerUserHeader(navigator),
          ListTile(
            title: Text(S.of(context).home_page_title),
            onTap: () {
              RootDrawer.of(context).close();
              navigator.currentState.popUntil(ModalRoute.withName('/'));
            },
            leading: Icon(Icons.home),
          ),
          DrawerSavedListTile(navigator),
          Divider(),
          DrawerUserProfileTile(navigator),
          DrawerLoginLogoutTile(navigator),
        ],
      ),
    );
  }
}

class DrawerUserHeader extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  const DrawerUserHeader(this.navigator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final ValueStream<LoginState> loginState$ = authBloc.loginState$;
    final DrawerControllerState drawerControllerState = RootDrawer.of(context);

    return StreamBuilder<LoginState>(
      stream: loginState$,
      initialData: loginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is LoggedInUser) {
          return UserAccountsDrawerHeader(
            currentAccountPicture:
                loginState.avatar == null || loginState.avatar.isEmpty
                    ? const CircleAvatar(
                        child: Icon(Icons.image),
                      )
                    : CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(loginState.avatar),
                        backgroundColor: Colors.white,
                      ),
            accountEmail: Text(loginState.email),
            accountName: Text(loginState.fullName ?? ''),
            onDetailsPressed: () {
              drawerControllerState.close();
              navigator.currentState.pushNamedAndRemoveUntil(
                '/user_profile',
                ModalRoute.withName('/'),
                arguments: loginState.uid,
              );
            },
          );
        }

        if (loginState is Unauthenticated) {
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
}

class DrawerSavedListTile extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  const DrawerSavedListTile(this.navigator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final ValueStream<LoginState> loginState$ = authBloc.loginState$;
    final DrawerControllerState drawerControllerState = RootDrawer.of(context);

    return StreamBuilder<LoginState>(
      stream: loginState$,
      initialData: loginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is Unauthenticated) {
          return Container(
            width: 0,
            height: 0,
          );
        }

        if (loginState is LoggedInUser) {
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
}

class DrawerLoginLogoutTile extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  const DrawerLoginLogoutTile(this.navigator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final DrawerControllerState drawerControllerState = RootDrawer.of(context);

    return StreamBuilder<LoginState>(
      stream: authBloc.loginState$,
      initialData: authBloc.loginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is Unauthenticated) {
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

        if (loginState is LoggedInUser) {
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
                authBloc.signOut.add(null);
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

class DrawerUserProfileTile extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  const DrawerUserProfileTile(this.navigator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final DrawerControllerState drawerControllerState = RootDrawer.of(context);

    return StreamBuilder<LoginState>(
      stream: authBloc.loginState$,
      initialData: authBloc.loginState$.value,
      builder: (context, snapshot) {
        final loginState = snapshot.data;

        if (loginState is LoggedInUser) {
          return ListTile(
            title: Text(S.of(context).user_profile),
            onTap: () {
              drawerControllerState.close();
              navigator.currentState.pushNamedAndRemoveUntil(
                '/user_profile',
                ModalRoute.withName('/'),
                arguments: loginState.uid,
              );
            },
            leading: Icon(Icons.person),
          );
        }

        return Container(width: 0, height: 0);
      },
    );
  }
}

class RootScaffold {
  RootScaffold._();

  static openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.findRootAncestorStateOfType<ScaffoldState>();
    scaffoldState.openDrawer();
  }

  static ScaffoldState of(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.findRootAncestorStateOfType<ScaffoldState>();
    return scaffoldState;
  }
}

class RootDrawer {
  RootDrawer._();

  static DrawerControllerState of(BuildContext context) {
    return context.findRootAncestorStateOfType<DrawerControllerState>();
  }
}
