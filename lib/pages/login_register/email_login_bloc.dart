import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

bool _isValidPassword(String password) {
  return password.length >= 6;
}

bool _isValidEmail(String email) {
  final _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
}

///
/// BLoC handling sign in with email and password
///
class EmailLoginBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<String> email;
  final Sink<String> password;
  final Sink<void> submitLogin;

  ///
  /// Streams
  ///
  final ValueObservable<bool> isLoading$;
  final Stream<Tuple2<String, bool>> messageAndLoginResult$;
  final Stream<String> emailError$;
  final Stream<String> passwordError$;

  ///
  /// Clean up
  ///
  final void Function() _dispose;

  factory EmailLoginBloc(FirebaseUserRepository userRepository) {
    ///
    ///Assert
    ///
    assert(userRepository != null, 'userRepository cannot be null');

    ///
    /// Controllers
    ///
    final emailController = PublishSubject<String>(sync: true);
    final passwordController = PublishSubject<String>(sync: true);
    final submitLoginController = PublishSubject<void>(sync: true);

    final isLoadingController =
        BehaviorSubject<bool>(sync: true, seedValue: false);

    ///
    /// Streams
    ///
    final emailError$ = emailController.stream.map(_getEmailError);
    final passwordError$ = passwordController.stream.map(_getPasswordError);

    final valid$ = Observable.combineLatest3(
      emailError$,
      passwordError$,
      isLoadingController.stream,
      (emailError, passwordError, isLoading) =>
          emailError == null && passwordError == null && !isLoading,
    );

    final emailAndPassword$ = Observable.combineLatest2(
      emailController.stream,
      passwordController.stream,
      (String email, String password) => Tuple2(email, password),
    );

    final messageAndLoginResult$ = submitLoginController.stream
        .withLatestFrom(valid$, (_, bool isValid) => isValid)
        .where((isValid) => isValid)
        .withLatestFrom(
          emailAndPassword$,
          (_, Tuple2<String, String> emailAndPassword) => emailAndPassword,
        )
        .flatMap((emailAndPassword) {
          return performLogin(
            emailAndPassword.item1,
            emailAndPassword.item2,
            userRepository,
            isLoadingController,
          );
        })
        .map(_getLoginMessageAndResult)
        .publish();

    final subscriptions = [messageAndLoginResult$.connect()];

    ///
    /// Return BLoC
    ///
    return EmailLoginBloc._(
      email: emailController.sink,
      password: passwordController.sink,
      submitLogin: submitLoginController.sink,
      isLoading$: isLoadingController.stream,
      messageAndLoginResult$: messageAndLoginResult$,
      dispose: () {
        emailController.close();
        passwordController.close();
        submitLoginController.close();
        isLoadingController.close();
        subscriptions.forEach((s) => s.cancel());
      },
      passwordError$: passwordError$,
      emailError$: emailError$,
    );
  }

  EmailLoginBloc._({
    @required this.email,
    @required this.password,
    @required this.submitLogin,
    @required this.isLoading$,
    @required this.messageAndLoginResult$,
    @required this.emailError$,
    @required this.passwordError$,
    @required void Function() dispose,
  }) : _dispose = dispose;

  @override
  void dispose() => _dispose();

  static Stream<Object> performLogin(
    String email,
    String password,
    FirebaseUserRepository userRepository,
    Sink<bool> isLoadingController,
  ) {
    return Observable.fromFuture(userRepository.signInWithEmailAndPassword(
            email: email, password: password))
        .doOnListen(() => isLoadingController.add(true))
        .doOnEach((_) => isLoadingController.add(false))
        .map<Object>((_) => null)
        .onErrorReturnWith((Object e) => e);
  }

  static String _getPasswordError(String password) {
    if (_isValidPassword(password)) return null;
    return 'Mật khẩu dài ít nhất 6 kí tự!';
  }

  static String _getEmailError(String email) {
    if (_isValidEmail(email)) return null;
    return 'Email sai định dạng!';
  }

  static Tuple2<String, bool> _getLoginMessageAndResult(Object e) {
    if (e == null) {
      return Tuple2("Đăng nhập thành công", true);
    }
    return Tuple2(
      "Lỗi xảy ra khi đăng nhập ${e is PlatformException ? e.message : e}",
      false,
    );
  }
}
