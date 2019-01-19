import 'dart:async';

import 'package:find_room/app/app.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SavedPage extends StatefulWidget {
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  StreamSubscription<dynamic> _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription?.cancel();
    _subscription = BlocProvider.of<UserBloc>(context)
        .userLoginState$
        .where((state) => state is NotLogin)
        .listen((_) => Navigator.popUntil(context, ModalRoute.withName('/')));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đã lưu'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => RootScaffold.openDrawer(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Saved page...'),
        ),
      ),
    );
  }
}
