import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_bloc.dart';
import 'package:find_room/pages/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = BlocProvider.of<ChangePasswordBloc>(context);
    final paddingTop = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: Colors.grey.shade100,
            ),
          ),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 300.0,
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
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 4),
                      color: Colors.grey,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 6),
                        constraints: BoxConstraints.expand(height: 56),
                        child: StreamBuilder<bool>(
                          stream: bloc.isLoading$,
                          initialData: bloc.isLoading$.value,
                          builder: (context, snapshot) {
                            if (snapshot.data) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Material(
                              child: RaisedButton(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(56 / 2),
                                ),
                                color: Theme.of(context).accentColor,
                                splashColor: Colors.white,
                                onPressed: bloc.submit,
                                child: Text(
                                  'Submit changes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: paddingTop + 12,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black26,
              ),
              child: BackButton(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      onWillPop: () => _onWillPop(bloc, context),
    );
  }

  static Future<bool> _onWillPop(ChangePasswordBloc bloc, BuildContext context) async {
    if (bloc.isLoading$.value) {
      final exit = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          final s = S.of(context);

          return AlertDialog(
            title: Text('Exit update password'),
            content:
                Text('Processing update password...Are you sure you want to exit?'),
            actions: <Widget>[
              FlatButton(
                child: Text(s.no),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text(s.exit),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
      return exit ?? false;
    }
    return true;
  }
}
