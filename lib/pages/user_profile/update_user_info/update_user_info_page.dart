import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_bloc.dart';
import 'package:find_room/pages/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';

class UpdateUserInfoPage extends StatefulWidget {
  @override
  _UpdateUserInfoPageState createState() => _UpdateUserInfoPageState();
}

class _UpdateUserInfoPageState extends State<UpdateUserInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<UpdateUserInfoBloc>(context)
        .message$
        .map((message) => message.fold(
              onInvalidInformation: () => '',
              onUpdateSuccess: () => '',
              onUpdateFailure: (e) => '',
            ))
        .listen((message) => null);
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            color: Colors.grey.shade100,
          ),
        ),
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
          child: null,
        ),
      ],
    );
  }
}
