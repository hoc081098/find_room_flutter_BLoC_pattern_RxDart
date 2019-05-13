import 'dart:async';

import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final UserBloc userBloc;

  const UserProfilePage({Key key, @required this.userBloc}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<StreamSubscription> _subscriptions;

  @override
  void initState() {
    super.initState();

    // if unauthenticated, exit this page
    _subscriptions = [
      widget.userBloc.loginState$
          .where((loginState) => loginState is Unauthenticated)
          .listen((_) => Navigator.popUntil(context, ModalRoute.withName('/'))),
    ];
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
