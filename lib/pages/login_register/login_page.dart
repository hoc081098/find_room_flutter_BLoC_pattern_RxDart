import 'dart:async';

import 'package:find_room/app/app.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/login_register/email_login_bloc.dart';
import 'package:find_room/pages/login_register/facebook_sign_in_bloc.dart';
import 'package:find_room/pages/login_register/google_sign_in_bloc.dart';
import 'package:find_room/pages/login_register/login_state.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginPage extends StatefulWidget {
  final FirebaseUserRepository userRepository;

  final AuthBloc authBloc;

  const LoginPage({
    Key key,
    @required this.userRepository,
    @required this.authBloc,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  EmailLoginBloc _emailLoginBloc;
  GoogleSignInBloc _googleSignInBloc;
  FacebookLoginBloc _facebookLoginBloc;
  List<StreamSubscription> _subscriptions;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailLoginBloc = EmailLoginBloc(widget.userRepository);
    _googleSignInBloc = GoogleSignInBloc(widget.userRepository);
    _facebookLoginBloc = FacebookLoginBloc(widget.userRepository);

    _subscriptions = [
      Rx.merge([
        _emailLoginBloc.message$,
        _googleSignInBloc.message$,
        _facebookLoginBloc.message$,
        widget.authBloc.loginState$
            .where((state) => state is LoggedInUser)
            .map((_) => const LoginMessageSuccess()),
      ]).listen(_showLoginMessage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
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
          child: Container(
            constraints: BoxConstraints.expand(),
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
                          SizedBox(height: 12),
                          EmailTextField(
                            emailFocusNode: _emailFocusNode,
                            emailLoginBloc: _emailLoginBloc,
                            passwordFocusNode: _passwordFocusNode,
                          ),
                          PasswordTextField(
                            emailLoginBloc: _emailLoginBloc,
                            focusNode: _passwordFocusNode,
                          ),
                          SizedBox(height: 12.0),
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
                          SizedBox(height: 12.0),
                          LoginButton(emailLoginBloc: _emailLoginBloc),
                          SizedBox(height: 12.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: FlatButton(
                              child: Text(
                                s.forgot_password,
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/forgot_password',
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 64.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(s.or_connect_through),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(width: 8),
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
                              Expanded(
                                child: FacebookSignInButton(
                                  facebookLoginBloc: _facebookLoginBloc,
                                ),
                              ),
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
                                  Navigator.pushNamed(
                                    context,
                                    '/register',
                                  );
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _emailLoginBloc.dispose();
    _googleSignInBloc.dispose();
    _facebookLoginBloc.dispose();

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
                Colors.deepPurple.shade200,
              ],
              [
                Colors.indigo.shade200,
                Colors.purple.shade200,
              ],
            ],
            durations: [19440, 10800],
            heightPercentages: [0.2, 0.25],
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
      final s = S.of(context);
      final exitSignIn = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s.exit_login),
            content: Text(s.exit_login_message),
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
      return exitSignIn ?? false;
    }
    return true;
  }

  _showSnackBar(message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLoginMessage(LoginMessage message) async {
    final s = S.of(context);
    if (message is LoginMessageSuccess) {
      _showSnackBar(s.login_success);
      await Future.delayed(const Duration(seconds: 2));
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

      ///
      if (error is UserDisabledError) {
        _showSnackBar(s.user_disabled_error);
      }
      if (error is InvalidCredentialError) {
        _showSnackBar(s.invalid_credential_error);
      }
      if (error is AccountExistsWithDifferenceCredentialError) {
        _showSnackBar(s.account_exists_with_difference_credential_error);
      }
      if (error is OperationNotAllowedError) {
        _showSnackBar(s.operation_not_allowed_error);
      }
      if (error is GoogleSignInCanceledError) {
        _showSnackBar(s.google_sign_in_canceled_error);
      }

      ///
      if (error is FacebookLoginCancelledByUser) {
        _showSnackBar(s.facebook_login_cancelled_by_user);
      }

      ///
      if (error is UnknownError) {
        print('[DEBUG] error=${error.error}');
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
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
      ),
      elevation: 11,
      clipBehavior: Clip.antiAlias,
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
              },
              decoration: InputDecoration(
                errorText: errorText == null ? null : '${' ' * 6}$errorText',
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black54,
                ),
                hintText: S.of(context).password,
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                suffixIcon: errorText == null
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: Colors.redAccent,
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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
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
                errorText: errorText == null ? null : '${' ' * 6}$errorText',
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black54,
                ),
                suffixIcon: errorText == null
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: Colors.redAccent,
                      ),
                hintText: "Email *",
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
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
        milliseconds: 400,
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
        curve: Curves.fastOutSlowIn,
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
    return Container(
      child: Center(
        child: SizeTransition(
          axis: Axis.vertical,
          sizeFactor: _sizeFactorAnimation,
          child: FadeTransition(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  strokeWidth: 3,
                ),
              ),
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
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Theme.of(context).accentColor,
        splashColor: Colors.white,
        onPressed: () => emailLoginBloc.submitLogin.add(null),
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        child: Text(
          S.of(context).login_title,
          style: Theme.of(context).textTheme.button.copyWith(
                color: Colors.black87,
                fontSize: 16,
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
  final FacebookLoginBloc facebookLoginBloc;

  const FacebookSignInButton({Key key, @required this.facebookLoginBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: facebookLoginBloc.isLoading$,
      initialData: facebookLoginBloc.isLoading$.value,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }

        return RaisedButton(
          child: Text("Facebook"),
          color: Colors.indigo,
          textColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          onPressed: () => facebookLoginBloc.submitLogin.add(null),
        );
      },
    );
  }
}
