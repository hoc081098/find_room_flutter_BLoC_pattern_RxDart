import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/user_profile/user_profile_bloc.dart';
import 'package:find_room/pages/user_profile/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserProfileBloc>(context);
    final paddingTop = MediaQuery.of(context).padding.top;

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
          child: StreamBuilder<UserProfileState>(
            initialData: bloc.state$.value,
            stream: bloc.state$,
            builder: (context, snapshot) {
              final state = snapshot.data;

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
                            child: state.avatar == null || state.avatar.isEmpty
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
                                    backgroundImage: NetworkImage(state.avatar),
                                    backgroundColor: Colors.white,
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          state.fullName,
                          style: Theme.of(context).textTheme.display1.copyWith(
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
                                  state.email,
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
                              if (state.phone != null && state.phone.isNotEmpty)
                                Chip(
                                  backgroundColor: Colors.white70,
                                  padding: const EdgeInsets.all(6),
                                  label: Text(
                                    state.phone,
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
                              if (state.address != null &&
                                  state.address.isNotEmpty)
                                Chip(
                                  backgroundColor: Colors.white70,
                                  padding: const EdgeInsets.all(6),
                                  label: Text(
                                    state.address,
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
                                  state.isActive ? 'Active' : 'Inactive',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(fontSize: 16),
                                ),
                                elevation: 4,
                                avatar: Icon(
                                  Icons.done,
                                  color: state.isActive
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              ),
                              Chip(
                                backgroundColor: Colors.white70,
                                padding: const EdgeInsets.all(6),
                                label: Text(
                                  'Created: ${DateFormat.yMMMMd().add_Hms().format(state.createdAt)}',
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
                                  'Updated: ${DateFormat.yMMMMd().add_Hms().format(state.updatedAt)}',
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
