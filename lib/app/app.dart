import 'package:find_room/app/page_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/home/home_page.dart';
import 'package:find_room/pages/login_register/login_page.dart';
import 'package:find_room/pages/saved/saved_page.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

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

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp>
    with SingleTickerProviderStateMixin<RootApp> {
  AnimationController _fadeController;
  Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    final pageBloc = BlocProvider.of<PageBloc>(context);
    final void Function(Page) changePage = pageBloc.changePage.add;

    return WillPopScope(
      child: StreamBuilder<Tuple2<Page, UserLoginState>>(
          stream: pageBloc.pageAndLoginState$,
          initialData: pageBloc.pageAndLoginState$.value,
          builder: (context, snapshot) {
            var page = snapshot.data.item1;

            return Scaffold(
              appBar: _buildAppBar(page),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildUserAccountsDrawerHeader(
                      snapshot.data.item2,
                      changePage,
                    ),
                    _buildHomeListTile(
                      page,
                      changePage,
                    ),
                    _buildSavedListTile(
                      snapshot.data,
                      changePage,
                    ),
                    Divider(),
                    _buildLoginLogoutButton(
                      userBloc,
                      changePage,
                      snapshot.data,
                    ),
                  ],
                ),
              ),
              body: _buildBody(page),
            );
          }),
      onWillPop: () => _onWillPop(pageBloc.page$.value, changePage),
    );
  }

  Widget _buildHomeListTile(
    Page page,
    void Function(Page) changePage,
  ) {
    return ListTile(
      title: Text('Trang chủ'),
      onTap: () {
        Navigator.pop(context);
        changePage(Page.home);
      },
      leading: Icon(Icons.home),
      selected: page == Page.home,
    );
  }

  Widget _buildSavedListTile(
    Tuple2<Page, UserLoginState> data,
    void Function(Page) changePage,
  ) {
    var loginState = data.item2;
    var page = data.item1;

    if (loginState is NotLogin) {
      return Container(
        width: 0,
        height: 0,
      );
    }

    if (loginState is UserLogin) {
      return ListTile(
        title: const Text('Đã lưu'),
        selected: page == Page.savedRooms,
        onTap: () {
          Navigator.pop(context);
          changePage(Page.savedRooms);
        },
        leading: const Icon(Icons.bookmark),
      );
    }

    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget _buildUserAccountsDrawerHeader(
    UserLoginState data,
    void Function(Page) changePage,
  ) {
    if (data is UserLogin) {
      return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(data.avatar),
          backgroundColor: Colors.transparent,
        ),
        accountEmail: Text(data.email),
        accountName: Text(data.fullName),
      );
    }

    if (data is NotLogin) {
      return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          child: const Icon(Icons.image),
        ),
        accountEmail: const Text('Đăng nhập ngay'),
        accountName: Container(),
        onDetailsPressed: () {
          Navigator.pop(context);
          changePage(Page.login);
        },
      );
    }

    return Container(width: 0, height: 0);
  }

  Widget _buildLoginLogoutButton(
    UserBloc userBloc,
    void Function(Page) changePage,
    Tuple2<Page, UserLoginState> tuple,
  ) {
    var loginState = tuple.item2;

    if (loginState is NotLogin) {
      return ListTile(
        title: const Text('Đăng nhập'),
        onTap: () {
          Navigator.pop(context);
          changePage(Page.login);
        },
        selected: tuple.item1 == Page.login,
        leading: const Icon(Icons.person_add),
      );
    }

    if (loginState is UserLogin) {
      return ListTile(
        title: const Text('Đăng xuất'),
        onTap: () async {
          Navigator.pop(context);

          final bool signOut = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Đăng xuất'),
                content: const Text('Bạn chắc chắn muốn đăng xuất'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Hủy'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(true),
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
  }

  Widget _buildBody(Page data) {
    _fadeController.reset();

    Widget child;
    switch (data) {
      case Page.home:
        child = MyHomePage();
        break;
      case Page.login:
        child = LoginPage();
        break;
      case Page.savedRooms:
        child = SavedPage();
        break;
      default:
        child = Container(
          child: Center(
            child: Text(
              "Error: don't know page",
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(color: Colors.red),
            ),
          ),
        );
    }

    _fadeController.forward();
    return FadeTransition(
      opacity: _fadeAnim,
      child: child,
    );
  }

  Future<bool> _onWillPop(Page page, void Function(Page) changePage) async {
    if (page == Page.home) {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thoát khỏi ứng dụng'),
            content: const Text('Bạn chắc chắn muốn thoát khỏi ứng dụng'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Không'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: const Text('Thoát'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
    }
    changePage(Page.home);
    return false;
  }

  Widget _buildAppBar(Page page) {
    switch (page) {
      case Page.home:
        return null;
        break;
      case Page.login:
        return AppBar(
          title: Text('Đăng nhập'),
        );
        break;
      case Page.savedRooms:
        return AppBar(
          title: Text('Đăng nhập'),
        );
        break;
      default:
        return AppBar(
          title: Text(
            "Error: don't know page",
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }
}
