import 'dart:async';

import 'package:find_room/app/app.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/login/email_login_bloc.dart';
import 'package:find_room/pages/login/google_sign_in_bloc.dart';
import 'package:find_room/pages/login/login_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginPage extends StatefulWidget {
  final FirebaseUserRepository userRepository;

  final UserBloc userBloc;

  const LoginPage({
    Key key,
    @required this.userRepository,
    @required this.userBloc,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  EmailLoginBloc _emailLoginBloc;
  GoogleSignInBloc _googleSignInBloc;
  List<StreamSubscription> _subscriptions;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailLoginBloc = EmailLoginBloc(widget.userRepository);
    _googleSignInBloc = GoogleSignInBloc(widget.userRepository);

    _subscriptions = [
      Observable.merge([
        _emailLoginBloc.message$,
        _googleSignInBloc.message$,
        widget.userBloc.userLoginState$
            .where((state) => state is UserLogin)
            .map((_) => const LoginMessageSuccess()),
      ]).listen(_showLoginMessage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(s.login_title),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => RootScaffold.openDrawer(context),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _buildWaveBackground(),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 96.0),
                        EmailTextField(
                          emailFocusNode: _emailFocusNode,
                          emailLoginBloc: _emailLoginBloc,
                          passwordFocusNode: _passwordFocusNode,
                        ),
                        PasswordTextField(
                          emailLoginBloc: _emailLoginBloc,
                          focusNode: _passwordFocusNode,
                        ),
                        StreamBuilder<bool>(
                          stream: _emailLoginBloc.isLoading$,
                          initialData: _emailLoginBloc.isLoading$.value,
                          builder: (context, snapshot) {
                            return LoadingIndicator(
                              isLoading: snapshot.data,
                              key: ValueKey(snapshot.data),
                            );
                          },
                        ),
                        LoginButton(emailLoginBloc: _emailLoginBloc),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              s.forgot_password,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              //TODO: forget password
                            },
                          ),
                        ),
                        SizedBox(height: 72.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Divider(color: Theme.of(context).accentColor),
                            Text(s.or_connect_through),
                            Divider(color: Theme.of(context).accentColor),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 12.0),
                            Expanded(
                              child: GoogleSignInButton(
                                googleSignInBloc: _googleSignInBloc,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(child: FacebookSignInButton()),
                            SizedBox(width: 12.0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(S.of(context).no_account),
                            FlatButton(
                              child: Text(S.of(context).register_now),
                              textColor: Colors.indigo,
                              onPressed: () {
                                //TODO: navigate to register page
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _emailLoginBloc.dispose();
    _googleSignInBloc.dispose();

    super.dispose();
  }

  Widget _buildWaveBackground() {
    return Positioned.fill(
      child: RotatedBox(
        quarterTurns: 2,
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [
                Colors.deepPurple,
                Colors.deepPurple.shade400,
              ],
              [
                Colors.indigo.shade400,
                Colors.purple.shade400,
              ],
            ],
            durations: [19440, 10800],
            heightPercentages: [0.15, 0.2],
            blur: MaskFilter.blur(BlurStyle.solid, 10),
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
          waveAmplitude: 0,
          size: Size(
            double.infinity,
            double.infinity,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_emailLoginBloc.isLoading$.value ||
        _googleSignInBloc.isLoading$.value) {
      final exitSignIn = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bạn muốn thoát đăng nhập'),
            content:
                const Text('Đang xử lí đăng nhập, bạn có chắc chắn muốn thoát'),
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
      return exitSignIn ?? false;
    }
    return true;
  }

  _showSnackBar(message) {
    Scaffold.of(context, nullOk: true)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLoginMessage(LoginMessage message) {
    var s = S.of(context);
    if (message is LoginMessageSuccess) {
      _showSnackBar(s.login_success);
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
    if (message is LoginMessageError) {
      final error = message.error;
      print('[DEBUG] error=$error');

      if (error is NetworkError) {
        _showSnackBar(s.network_error);
      }
      if (error is TooManyRequestsError) {
        _showSnackBar(s.too_many_requests_error);
      }
      if (error is UserNotFoundError) {
        _showSnackBar(s.user_not_found_error);
      }
      if (error is WrongPasswordError) {
        _showSnackBar(s.wrong_password_error);
      }
      if (error is InvalidEmailError) {
        _showSnackBar(s.invalid_email_error);
      }
      if (error is EmailAlreadyInUseError) {
        _showSnackBar(s.email_already_in_user_error);
      }
      if (error is WeakPasswordError) {
        _showSnackBar(s.weak_password_error);
      }
      if (error is UserDisabledError) {
        _showSnackBar(s.user_disabled_error);
      }
      if (error is UnknownError) {
        _showSnackBar(s.error_occurred);
      }
    }
  }
}

class PasswordTextField extends StatelessWidget {
  final FocusNode focusNode;
  final EmailLoginBloc emailLoginBloc;

  const PasswordTextField({Key key, this.focusNode, this.emailLoginBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: StreamBuilder<PasswordError>(
          stream: emailLoginBloc.passwordError$,
          builder: (context, snapshot) {
            String errorText;
            if (snapshot.data is PasswordAtLeast6Characters) {
              errorText = S.of(context).password_at_least_6_characters;
            }

            return TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: emailLoginBloc.password.add,
              obscureText: true,
              focusNode: focusNode,
              onSubmitted: (_) {
                focusNode.unfocus();
                emailLoginBloc.submitLogin.add(null);
              },
              decoration: InputDecoration(
                errorText: errorText,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black26,
                ),
                hintText: S.of(context).password,
                hintStyle: TextStyle(
                  color: Colors.black26,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.0),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
              ),
            );
          }),
    );
  }
}

class EmailTextField extends StatelessWidget {
  final EmailLoginBloc emailLoginBloc;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const EmailTextField(
      {Key key,
      this.emailLoginBloc,
      this.emailFocusNode,
      this.passwordFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 30,
      ),
      elevation: 11,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: StreamBuilder<EmailError>(
          stream: emailLoginBloc.emailError$,
          builder: (context, snapshot) {
            String errorText;
            if (snapshot.data is InvalidEmailAddress) {
              errorText = S.of(context).invalid_email_address;
            }

            return TextField(
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (_) {
                emailFocusNode.unfocus();
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              focusNode: emailFocusNode,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              onChanged: emailLoginBloc.email.add,
              decoration: InputDecoration(
                errorText: errorText,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black26,
                ),
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: Colors.black26,
                ),
                hintText: "Email *",
                hintStyle: TextStyle(color: Colors.black26),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
              ),
            );
          }),
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  final bool isLoading;

  const LoadingIndicator({Key key, this.isLoading}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin<LoadingIndicator> {
  AnimationController _animationController;
  Animation<double> _fadeAnimation;
  Animation<double> _sizeFactorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _sizeFactorAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.decelerate,
      ),
    );

    if (widget.isLoading) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 30,
        ),
        child: SizeTransition(
          axis: Axis.vertical,
          sizeFactor: _sizeFactorAnimation,
          child: FadeTransition(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
              strokeWidth: 3,
            ),
            opacity: _fadeAnimation,
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final EmailLoginBloc emailLoginBloc;

  const LoginButton({Key key, this.emailLoginBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.cyan,
        splashColor: Colors.cyan.shade200,
        onPressed: () => emailLoginBloc.submitLogin.add(null),
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        child: Text(
          S.of(context).login_title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final GoogleSignInBloc googleSignInBloc;

  const GoogleSignInButton({Key key, this.googleSignInBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: googleSignInBloc.isLoading$,
        initialData: googleSignInBloc.isLoading$.value,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          return RaisedButton(
            child: Text("Google"),
            elevation: 8,
            textColor: Colors.white,
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            onPressed: () => googleSignInBloc.submitLogin.add(null),
          );
        });
  }
}

class FacebookSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Facebook"),
      color: Colors.indigo,
      textColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      onPressed: () {
        //TODO: Facebook sign in
      },
    );
  }
}
