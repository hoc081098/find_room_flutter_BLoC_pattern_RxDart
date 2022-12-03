import 'dart:async';
import 'dart:io';

import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/login_register/register/register_bloc.dart';
import 'package:find_room/pages/login_register/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseUserRepository userRepository;

  const RegisterPage({
    Key key,
    @required this.userRepository,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterBloc _bloc;
  List<StreamSubscription> _subscriptions;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _bloc = RegisterBloc(widget.userRepository);

    _subscriptions = [_bloc.message$.listen(_showRegisterMessage)];
  }

  _pickImage() async {
    final file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
    );
    _bloc.avatarChanged(file);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(s.register),
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
                          Center(
                            child: SizedBox(
                              width: 96,
                              height: 96,
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.indigo.shade100,
                                        blurRadius: 12,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                  child: StreamBuilder<File>(
                                      initialData: _bloc.avatar$.value,
                                      stream: _bloc.avatar$,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return CircleAvatar(
                                            radius: 48,
                                            backgroundImage:
                                                FileImage(snapshot.data),
                                            backgroundColor: Colors.white,
                                          );
                                        } else {
                                          return const CircleAvatar(
                                            radius: 48,
                                            child: Icon(
                                              Icons.person,
                                              size: 72,
                                            ),
                                          );
                                        }
                                      }),
                                ),
                                onTap: _pickImage,
                              ),
                            ),
                          ),
                          EmailTextField(
                            bloc: _bloc,
                            focusNode: _emailFocusNode,
                            passwordFocusNode: _passwordFocusNode,
                          ),
                          PasswordTextField(
                            bloc: _bloc,
                            focusNode: _passwordFocusNode,
                            fullNameFocusNode: _fullNameFocusNode,
                          ),
                          FullNameTextField(
                            bloc: _bloc,
                            focusNode: _fullNameFocusNode,
                            phoneFocusNode: _phoneFocusNode,
                          ),
                          PhoneTextField(
                            bloc: _bloc,
                            focusNode: _phoneFocusNode,
                            addressFocusNode: _addressFocusNode,
                          ),
                          AddressTextField(
                            bloc: _bloc,
                            focusNode: _addressFocusNode,
                          ),
                          SizedBox(height: 8.0),
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
                          SizedBox(height: 8.0),
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
      final s = S.of(context);
      final exitRegister = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s.exit_register),
            content: Text(s.exit_register_message),
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
      return exitRegister ?? false;
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

  void _showRegisterMessage(RegisterMessage message) async {
    final s = S.of(context);
    if (message is RegisterMessageSuccess) {
      _showSnackBar(s.register_success);
    }
    if (message is RegisterMessageError) {
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
      if (error is UnknownError) {
        print('[DEBUG] error=${error.error}');
        _showSnackBar(s.error_occurred);
      }
    }
  }
}

class PasswordTextField extends StatelessWidget {
  final FocusNode focusNode;
  final RegisterBloc bloc;
  final FocusNode fullNameFocusNode;

  const PasswordTextField({
    Key key,
    @required this.focusNode,
    @required this.bloc,
    @required this.fullNameFocusNode,
  }) : super(key: key);

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
              textInputAction: TextInputAction.next,
              onChanged: bloc.passwordChanged,
              obscureText: true,
              focusNode: focusNode,
              onSubmitted: (_) {
                focusNode.unfocus();
                FocusScope.of(context).requestFocus(fullNameFocusNode);
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
  final FocusNode focusNode;
  final FocusNode passwordFocusNode;

  const EmailTextField(
      {Key key,
      this.bloc,
      @required this.focusNode,
      @required this.passwordFocusNode})
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
                focusNode.unfocus();
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              focusNode: focusNode,
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
        milliseconds: 800,
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
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).accentColor,
                  ),
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
          S.of(context).register,
          style: Theme.of(context).textTheme.button.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}

class FullNameTextField extends StatelessWidget {
  final FocusNode focusNode;
  final RegisterBloc bloc;
  final FocusNode phoneFocusNode;

  const FullNameTextField({
    Key key,
    @required this.focusNode,
    @required this.bloc,
    @required this.phoneFocusNode,
  }) : super(key: key);

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
      child: StreamBuilder<FullNameError>(
          stream: bloc.fullNameError$,
          builder: (context, snapshot) {
            String errorText;
            if (snapshot.data is FullNameMustBeAtLeast3Characters) {
              errorText = S.of(context).full_name_at_least_6_characters;
            }

            return TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: bloc.fullNameChanged,
              focusNode: focusNode,
              onSubmitted: (_) {
                focusNode.unfocus();
                FocusScope.of(context).requestFocus(phoneFocusNode);
              },
              decoration: InputDecoration(
                errorText: errorText == null ? null : '${' ' * 6}$errorText',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
                hintText: S.of(context).full_name,
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

class PhoneTextField extends StatelessWidget {
  final FocusNode focusNode;
  final RegisterBloc bloc;
  final FocusNode addressFocusNode;

  const PhoneTextField({
    Key key,
    @required this.focusNode,
    @required this.bloc,
    @required this.addressFocusNode,
  }) : super(key: key);

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
      child: StreamBuilder<PhoneError>(
          stream: bloc.phoneError$,
          builder: (context, snapshot) {
            String errorText;
            if (snapshot.data is InvalidPhone) {
              errorText = S.of(context).invalid_phone_number;
            }

            return TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: bloc.phoneChanged,
              focusNode: focusNode,
              onSubmitted: (_) {
                focusNode.unfocus();
                FocusScope.of(context).requestFocus(addressFocusNode);
              },
              decoration: InputDecoration(
                errorText: errorText == null ? null : '${' ' * 6}$errorText',
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black54,
                ),
                hintText: S.of(context).phone_number,
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

class AddressTextField extends StatelessWidget {
  final FocusNode focusNode;
  final RegisterBloc bloc;

  const AddressTextField({
    Key key,
    @required this.focusNode,
    @required this.bloc,
  }) : super(key: key);

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
      child: StreamBuilder<AddressError>(
          stream: bloc.addressError$,
          builder: (context, snapshot) {
            String errorText;
            if (snapshot.data is AddressMustBeNotEmpty) {
              errorText = S.of(context).empty_address;
            }

            return TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: bloc.addressChanged,
              focusNode: focusNode,
              onSubmitted: (_) {
                focusNode.unfocus();
              },
              decoration: InputDecoration(
                errorText: errorText == null ? null : '${' ' * 6}$errorText',
                prefixIcon: Icon(
                  Icons.label,
                  color: Colors.black54,
                ),
                hintText: S.of(context).address,
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
