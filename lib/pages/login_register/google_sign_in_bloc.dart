import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

///
/// BLoC handling google sign in
///
class GoogleSignInBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<void> submitLogin;

  ///
  /// Streams
  ///
  final ValueObservable<bool> isLoading$;
  final Stream<Tuple2<String, bool>> messageAndLoginResult$;

  ///
  /// Clean up
  ///
  final void Function() _dispose;

  GoogleSignInBloc._({
    @required this.isLoading$,
    @required this.messageAndLoginResult$,
    @required this.submitLogin,
    @required void Function() dispose,
  }) : this._dispose = dispose;

  factory GoogleSignInBloc(FirebaseUserRepository userRepository) {
    ///
    ///Assert
    ///
    assert(userRepository != null, 'userRepository cannot be null');

    ///
    /// Controllers
    ///
    final submitLoginController = PublishSubject<void>(sync: true);
    final isLoadingController =
        BehaviorSubject<bool>(sync: true, seedValue: false);

    ///
    /// Streams
    ///
    final messageAndLoginResult$ = submitLoginController.stream
        .exhaustMap((_) => performLogin(userRepository, isLoadingController))
        .map(_getLoginMessageAndResult)
        .publish();

    final subscriptions = [messageAndLoginResult$.connect()];

    return GoogleSignInBloc._(
      isLoading$: isLoadingController.stream,
      messageAndLoginResult$: messageAndLoginResult$,
      submitLogin: submitLoginController.sink,
      dispose: () {
        isLoadingController.close();
        submitLoginController.close();
        subscriptions.forEach((s) => s.cancel());
      },
    );
  }

  static Stream<Object> performLogin(
    FirebaseUserRepository userRepository,
    Sink<bool> isLoadingController,
  ) async* {
    isLoadingController.add(true);
    try {
      await userRepository.googleSignIn();
      yield null;
    } catch (e) {
      yield e;
    }
    isLoadingController.add(false);
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

  @override
  void dispose() => _dispose();
}
