import 'dart:async';

import 'package:find_room/app/app.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/login_register/register_bloc.dart';
import 'package:find_room/pages/login_register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseUserRepository userRepository;

  const RegisterPage({Key key, @required this.userRepository})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterBloc _bloc;
  List<StreamSubscription> _subscriptions;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _bloc = RegisterBloc(widget.userRepository); //TODO

    _subscriptions = [
      _bloc.message$.listen(_showRegisterMessage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Register'),
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
                            bloc: _bloc,
                            passwordFocusNode: _passwordFocusNode,
                          ),
                          PasswordTextField(
                            bloc: _bloc,
                            focusNode: _passwordFocusNode,
                          ),
                          SizedBox(height: 12.0),
                          StreamBuilder<bool>(
                            stream: _bloc.isLoading$,
                            initialData: _bloc.isLoading$.value,
                            builder: (context, snapshot) {
                              return LoadingIndicator(
                                isLoading: snapshot.data,
                                key: ValueKey(snapshot.data),
                              );
                            },
                          ),
                          SizedBox(height: 12.0),
                          RegisterButton(bloc: _bloc),
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
      onWillPop: _onWillPop,
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _bloc.dispose();
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
    if (_bloc.isLoading$.value) {
      final exitRegister = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bạn muốn thoát đăng kí'),
            content:
                const Text('Đang xử lí đăng kí, bạn có chắc chắn muốn thoát'),
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
      return exitRegister ?? false;
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

  void _showRegisterMessage(RegisterMessage message) {
    var s = S.of(context);
  }
}

class PasswordTextField extends StatelessWidget {
  final FocusNode focusNode;
  final RegisterBloc bloc;

  const PasswordTextField({Key key, this.focusNode, this.bloc})
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
          stream: bloc.passwordError$,
          builder: (context, snapshot) {
            String errorText;
            if (snapshot.data is PasswordMustBeAtLeast6Characters) {
              errorText = S.of(context).password_at_least_6_characters;
            }

            return TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: bloc.passwordChanged,
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
  final RegisterBloc bloc;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const EmailTextField(
      {Key key, this.bloc, this.emailFocusNode, this.passwordFocusNode})
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
          stream: bloc.emailError$,
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
              onChanged: bloc.emailChanged,
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

class RegisterButton extends StatelessWidget {
  final RegisterBloc bloc;

  const RegisterButton({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Theme.of(context).accentColor,
        splashColor: Colors.white,
        onPressed: bloc.submitRegister,
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        child: Text(
          'Register',
          style: Theme.of(context).textTheme.button.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}
