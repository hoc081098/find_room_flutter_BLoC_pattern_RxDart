import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/login_register/forgot_password/forgot_password_bloc.dart';
import 'package:find_room/pages/login_register/forgot_password/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    _subscription ??= BlocProvider.of<ForgotPasswordBloc>(context)
        .message$
        .listen(_handleMessage);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = BlocProvider.of<ForgotPasswordBloc>(context);

    return WillPopScope(
      onWillPop: () => _onWillPop(bloc),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(s.forgot_password_title),
        ),
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Stack(
              children: <Widget>[
                _buildWaveBackground(),
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 12),
                        const EmailTextField(),
                        SizedBox(height: 8.0),
                        StreamBuilder<bool>(
                          stream: bloc.isLoading$,
                          initialData: bloc.isLoading$.value,
                          builder: (context, snapshot) {
                            return LoadingIndicator(
                              isLoading: snapshot.data,
                              key: ValueKey(snapshot.data),
                            );
                          },
                        ),
                        SizedBox(height: 8.0),
                        SendEmailButton(),
                        SizedBox(height: 12),
                      ],
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
    _subscription?.cancel();
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

  Future<bool> _onWillPop(ForgotPasswordBloc bloc) async {
    if (bloc.isLoading$.value) {
      final s = S.of(context);
      final exitSendEmail = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s.exit_send_email),
            content: Text(s.exit_send_email_message),
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
      return exitSendEmail ?? false;
    }
    return true;
  }

  _handleMessage(ForgotPasswordMessage message) {
    final s = S.of(context);
    if (message is InvalidInformation) {
      _showSnackBar(s.invalid_email_address);
    }
    if (message is SendPasswordResetEmailSuccess) {
      _showSnackBar(s.send_password_reset_email_success);
    }
    if (message is SendPasswordResetEmailFailure) {
      final ForgotPasswordError error = message.error;
      if (error is UnknownError) {
        print('[FORGOT_PASSWORD] ${error.error}');
        _showSnackBar(s.error_occurred);
      }
      if (error is UserNotFoundError) {
        _showSnackBar(s.user_not_found_error);
      }
      if (error is InvalidEmailError) {
        _showSnackBar(s.invalid_email_address);
      }
    }
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ForgotPasswordBloc>(context);

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
              textInputAction: TextInputAction.done,
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

class SendEmailButton extends StatelessWidget {
  const SendEmailButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ForgotPasswordBloc>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Theme.of(context).accentColor,
        splashColor: Colors.white,
        onPressed: bloc.submit,
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        child: Text(
          S.of(context).send_email,
          style: Theme.of(context).textTheme.button.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}
