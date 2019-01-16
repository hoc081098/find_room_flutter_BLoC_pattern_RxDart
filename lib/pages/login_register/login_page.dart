import 'dart:async';

import 'package:find_room/app/page_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/pages/login_register/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin<LoginPage> {
  LoginBloc _loginBloc;
  PageBloc _pageBloc;

  AnimationController _fadeAnimationController;
  Animation<double> _fadeAnim;
  StreamSubscription<dynamic> _subscription;
  bool _prevIsLoading;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(_fadeAnimationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _pageBloc = BlocProvider.of<PageBloc>(context);
    final userRepository = Injector.of(context).userRepository;
    _loginBloc = LoginBloc(userRepository);
    _subscription =
        _loginBloc.messageAndLoginResult$.listen(_handleMessageAndResult);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildWaveBackground(),
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 12.0),
                _buildEmailField(),
                _buildPasswordField(),
                _buildLoadingIndicator(),
                _buildLoginButton(context),
                FlatButton(
                  child: Text(
                    "Bạn quên mật khẩu?",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 48.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Divider(color: Theme.of(context).accentColor),
                    Text("hoặc kết nối qua"),
                    Divider(color: Theme.of(context).accentColor),
                  ],
                ),
                SizedBox(height: 8.0),
                _buildFacebookGoogleLogin(),
                _buildSignUp()
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    _loginBloc.dispose();
    _subscription?.cancel();
  }

  Widget _buildWaveBackground() {
    return Container(
      height: double.infinity,
      child: RotatedBox(
        quarterTurns: 2,
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [Colors.deepPurple, Colors.deepPurple.shade200],
              [Colors.indigo.shade200, Colors.purple.shade200],
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

  Widget _buildSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Chưa có tài khoản?"),
        FlatButton(
          child: Text("Đăng kí ngay"),
          textColor: Colors.indigo,
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildFacebookGoogleLogin() {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        Expanded(
          child: RaisedButton(
            child: Text("Facebook"),
            textColor: Colors.white,
            color: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: RaisedButton(
            child: Text("Google"),
            textColor: Colors.white,
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Theme.of(context).accentColor,
        onPressed: () => _loginBloc.submitLogin.add(null),
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        child: Text(
          "Đăng nhập",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: StreamBuilder<String>(
          stream: _loginBloc.passwordError$,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return TextField(
              maxLines: 1,
              onChanged: _loginBloc.password.add,
              decoration: InputDecoration(
                errorText: snapshot.data,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black26,
                ),
                hintText: "Mật khẩu",
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
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
              ),
            );
          }),
    );
  }

  Widget _buildEmailField() {
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
      child: StreamBuilder<String>(
          stream: _loginBloc.emailError$,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return TextField(
              maxLines: 1,
              onChanged: _loginBloc.email.add,
              decoration: InputDecoration(
                errorText: snapshot.data,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black26,
                ),
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: Colors.black26,
                ),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.black26),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
              ),
            );
          }),
    );
  }

  _handleMessageAndResult(Tuple2<String, bool> messageAndResult) async {
    await Scaffold.of(context, nullOk: true)
        ?.showSnackBar(SnackBar(content: Text(messageAndResult.item1)))
        ?.closed;
    if (messageAndResult.item2) {
      _pageBloc.changePage.add(Page.home);
    }
  }

  Widget _buildLoadingIndicator() {
    return StreamBuilder<bool>(
      stream: _loginBloc.isLoading$,
      initialData: _loginBloc.isLoading$.value,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (_prevIsLoading != null && _prevIsLoading != snapshot.data) {
          _prevIsLoading = snapshot.data;

          _fadeAnimationController.reset();
          if (snapshot.data) {
            _fadeAnimationController.forward(from: 0);
          } else {
            _fadeAnimationController.reverse(from: 1);
          }

          return FadeTransition(
            child: CircularProgressIndicator(),
            opacity: _fadeAnim,
          );
        } else {
          if (snapshot.data) {
            return CircularProgressIndicator();
          }
          return Container(width: 0, height: 0);
        }
      },
    );
  }
}
