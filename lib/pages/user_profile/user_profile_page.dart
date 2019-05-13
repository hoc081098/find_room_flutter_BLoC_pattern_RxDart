import 'dart:async';

import 'package:find_room/generated/i18n.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    var paddingTop = MediaQuery.of(context).padding.top;

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 400.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.indigo.shade400,
                  Colors.purple,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: paddingTop,
          child: StreamBuilder<LoginState>(
            initialData: widget.userBloc.loginState$.value,
            stream: widget.userBloc.loginState$,
            builder: (context, snapshot) {
              final loginState = snapshot.data;
              if (loginState is Unauthenticated) {
                return Text('Unauthenticated');
              }
              if (loginState is LoggedInUser) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 32),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(48),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.indigo.shade100,
                                        offset: Offset(4, 4),
                                        blurRadius: 10)
                                  ]),
                              width: 96,
                              height: 96,
                              child: loginState.avatar == null ||
                                      loginState.avatar.isEmpty
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                      radius: 48,
                                      child: Icon(
                                        Icons.person,
                                        size: 72,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 48,
                                      backgroundImage:
                                          NetworkImage(loginState.avatar),
                                      backgroundColor: Colors.white,
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            loginState.fullName,
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      fontSize: 30,
                                      fontFamily: 'SF-Pro-Display',
                                      color: Colors.white,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: Wrap(
                              spacing: 8.0,
                              // gap between adjacent chips
                              runSpacing: 4.0,
                              // gap between lines
                              children: <Widget>[
                                Chip(
                                  backgroundColor: Colors.white70,
                                  padding: const EdgeInsets.all(6),
                                  label: Text(
                                    loginState.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(fontSize: 16),
                                  ),
                                  elevation: 4,
                                  avatar: Icon(
                                    Icons.email,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                if (loginState.phone != null &&
                                    loginState.phone.isNotEmpty)
                                  Chip(
                                    backgroundColor: Colors.white70,
                                    padding: const EdgeInsets.all(6),
                                    label: Text(
                                      loginState.phone,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(fontSize: 16),
                                    ),
                                    elevation: 4,
                                    avatar: Icon(
                                      Icons.call,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                if (loginState.address != null &&
                                    loginState.address.isNotEmpty)
                                  Chip(
                                    backgroundColor: Colors.white70,
                                    padding: const EdgeInsets.all(6),
                                    label: Text(
                                      loginState.address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(fontSize: 16),
                                    ),
                                    elevation: 4,
                                    avatar: Icon(
                                      Icons.label,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                Chip(
                                  backgroundColor: Colors.white70,
                                  padding: const EdgeInsets.all(6),
                                  label: Text(
                                    loginState.isActive ? 'Active' : 'Inactive',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(fontSize: 16),
                                  ),
                                  elevation: 4,
                                  avatar: Icon(
                                    Icons.done,
                                    color: loginState.isActive
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                                Chip(
                                  backgroundColor: Colors.white70,
                                  padding: const EdgeInsets.all(6),
                                  label: Text(
                                    'Created: ${DateFormat.yMMMMd().add_Hms().format(loginState.createdAt)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(fontSize: 16),
                                  ),
                                  elevation: 4,
                                  avatar: Icon(
                                    Icons.date_range,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                Chip(
                                  backgroundColor: Colors.white70,
                                  padding: const EdgeInsets.all(6),
                                  label: Text(
                                    'Updated: ${DateFormat.yMMMMd().add_Hms().format(loginState.updatedAt)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(fontSize: 16),
                                  ),
                                  elevation: 4,
                                  avatar: Icon(
                                    Icons.date_range,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Text('Text $index');
                        },
                        childCount: 50,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        Positioned(
          top: paddingTop + 8,
          left: 8,
          child: BackButton(color: Colors.white),
        ),
        Positioned(
          top: paddingTop + 8,
          right: 8,
          child: IconButton(
            tooltip: S.of(context).edit_profile,
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              //TODO: edit
            },
          ),
        ),
      ],
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);

    final firstEndPoint = Offset(
      size.width * 0.5,
      size.height - 30.0,
    );
    final firstControlPoint = Offset(
      size.width * 0.25,
      size.height - 50.0,
    );
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondEndPoint = Offset(
      size.width,
      size.height - 80.0,
    );
    final secondControlPoint = Offset(
      size.width * 0.75,
      size.height - 10,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
