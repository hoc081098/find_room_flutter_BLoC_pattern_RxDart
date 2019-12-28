import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/login_register/login_state.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

///
/// BLoC handling facebook sign in
///
class FacebookLoginBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<void> submitLogin;

  ///
  /// Streams
  ///
  final ValueStream<bool> isLoading$;
  final Stream<LoginMessage> message$;

  ///
  /// Clean up
  ///
  final void Function() _dispose;

  FacebookLoginBloc._({
    @required this.isLoading$,
    @required this.message$,
    @required this.submitLogin,
    @required void Function() dispose,
  }) : this._dispose = dispose;

  factory FacebookLoginBloc(FirebaseUserRepository userRepository) {
    ///
    ///Assert
    ///
    assert(userRepository != null, 'userRepository cannot be null');

    ///
    /// Controllers
    ///
    //ignore: close_sinks
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    ///
    /// Streams
    ///
    final message$ = submitLoginController.stream
        .exhaustMap((_) => performLogin(userRepository, isLoadingController))
        .publish();

    ///
    /// Subscriptions and controllers
    ///
    final subscriptions = <StreamSubscription>[
      message$.connect(),
    ];
    final controllers = <StreamController>[
      submitLoginController,
      isLoadingController,
    ];

    return FacebookLoginBloc._(
      isLoading$: isLoadingController.stream,
      message$: message$,
      submitLogin: submitLoginController.sink,
      dispose: () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
    );
  }

  static Stream<LoginMessage> performLogin(
    FirebaseUserRepository userRepository,
    Sink<bool> isLoadingController,
  ) async* {
    isLoadingController.add(true);
    try {
      final result = await userRepository.facebookSignIn();
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          yield const LoginMessageSuccess();
          break;
        case FacebookLoginStatus.cancelledByUser:
          yield const LoginMessageError(FacebookLoginCancelledByUser());
          break;
        case FacebookLoginStatus.error:
          yield LoginMessageError(UnknownError(result.errorMessage));
          break;
      }
    } catch (e) {
      yield LoginMessageError(UnknownError(e));
    } finally {
      isLoadingController.add(false);
    }
  }

  @override
  void dispose() => _dispose();
}
