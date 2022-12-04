import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_bloc.dart';
import 'package:find_room/pages/user_profile/change_password/change_password_state.dart';
import 'package:find_room/pages/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  StreamSubscription<ChangePasswordMessage> _subscription;

  @override
  void didChangeDependencies() {
    _subscription ??= BlocProvider.of<ChangePasswordBloc>(context)
        .message$
        .listen(_handleMessage);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

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
                      StreamBuilder<PasswordError>(
                        stream: bloc.passwordError$,
                        builder: (context, snapshot) {
                          final errorText = snapshot.data?.join(
                            (_) => s.password_at_least_6_characters,
                            () => null,
                          );

                          return PasswordTextField(
                            errorText: errorText,
                            onChanged: bloc.passwordChanged,
                          );
                        },
                      ),
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
                                  S.of(context).change_password,
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

  static Future<bool> _onWillPop(
      ChangePasswordBloc bloc, BuildContext context) async {
    if (bloc.isLoading$.value) {
      final exit = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          final s = S.of(context);

          return AlertDialog(
            title: Text(S.of(context).exit_update_password),
            content: Text(S
                .of(context)
                .processing_update_passwordare_you_sure_you_want_to_exit),
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

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMessage(ChangePasswordMessage event) {
    event.continued(
      (_) {
        _showSnackBar(S.of(context).change_password_successfully);
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pop(context),
        );
      },
      (message) {
        final messageText = message.error.join(
          (_) => S.of(context).unknown_error,
          (_) => S.of(context).weak_password,
          (_) => S.of(context).user_disabled,
          (_) => S.of(context).user_not_found,
          (_) => S.of(context).requires_recent_login,
          (_) => S.of(context).operation_not_allowed,
        );
        _showSnackBar(S
            .of(context)
            .change_password_not_successfully_error_messagetext(messageText));
      },
      (_) {
        _showSnackBar(S.of(context).invalid_password);
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String errorText;

  const PasswordTextField({
    Key key,
    @required this.onChanged,
    @required this.errorText,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
      obscureText: _obscureText,
      decoration: InputDecoration(
        errorText: widget.errorText,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        labelText: S.of(context).password,
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(Icons.lock),
        ),
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      style: TextStyle(fontSize: 16.0),
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.done,
    );
  }
}
