import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

enum Page { home, savedRooms, login }

class PageBloc implements BaseBloc {
  final Sink<Page> changePage;
  final ValueObservable<Page> page$;
  final ValueObservable<Tuple2<Page, UserLoginState>> pageAndLoginState$;
  final void Function() _dispose;

  factory PageBloc({@required UserBloc userBloc}) {
    ///Assert
    assert(userBloc != null, 'userBloc cannot be null');

    ///Controller
    final controller = PublishSubject<Page>(sync: true);

    ///Streams
    final $page =
        controller.stream.distinct().publishValue(seedValue: Page.home);
    final pageAndLoginState$ = Observable.combineLatest2<Page, UserLoginState,
        Tuple2<Page, UserLoginState>>(
      $page,
      userBloc.user$,
      (page, user) => Tuple2(page, user),
    ).publishValue(seedValue: Tuple2(Page.home, const NotLogin()));

    ///Subscriptions
    final subscriptions = <StreamSubscription<dynamic>>[
      $page.connect(),
      pageAndLoginState$.connect(),
    ];

    ///Return
    return PageBloc._(
      controller.sink,
      $page,
      () {
        controller.close();
        subscriptions.forEach((subscription) => subscription.cancel());
      },
      pageAndLoginState$,
    );
  }

  PageBloc._(
    this.changePage,
    this.page$,
    this._dispose,
    this.pageAndLoginState$,
  );

  @override
  void dispose() => _dispose();
}
