import 'dart:async';

import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/local/local_data_source.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/pages/home/see_all/see_all_interactor.dart';
import 'package:find_room/pages/home/see_all/see_all_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

// ignore_for_file: close_sinks

class SeeAllBloc implements BaseBloc {
  /// Input [Function]s
  final Future<void> Function() refresh;
  final void Function() load;
  final void Function() retry;

  /// Output [Stream]s
  final ValueStream<SeeAllListState> peopleList$;
  final Stream<SeeAllMessage> message$;

  /// Clean up: close controller, cancel subscription
  final void Function() _dispose;

  SeeAllBloc._(
    this._dispose, {
    @required this.refresh,
    @required this.load,
    @required this.retry,
    @required this.peopleList$,
    @required this.message$,
  });

  @override
  void dispose() => _dispose();

  factory SeeAllBloc(
    SeeAllInteractor seeAllInteractor,
    LocalDataSource localData,
    SeeAllQuery seeAllQuery,
  ) {
    assert(seeAllInteractor != null, 'peopleInteractor cannot be null');
    assert(localData != null, 'localData cannot be null');
    assert(seeAllQuery != null, 'seeAllQuery cannot be null');

    /// Stream controllers
    final loadController = PublishSubject<void>();
    final refreshController = PublishSubject<Completer<void>>();
    final retryController = PublishSubject<void>();
    final messageController = PublishSubject<SeeAllMessage>();

    /// State stream
    DistinctValueConnectableStream<SeeAllListState> state$;

    /// All actions stream
    final allActions$ = Rx.merge(
      [
        loadController.stream
            .throttleTime(Duration(milliseconds: 600))
            .map((_) => state$.value)
            .where((state) => state.error == null && !state.isLoading)
            .map((state) => Tuple3(state, false, null))
            .doOnData((_) => print('[SEE_ALL_BLOC] [ACTION] Load')),
        refreshController.stream
            .map((completer) => Tuple3(state$.value, true, completer))
            .doOnData((_) => print('[SEE_ALL_BLOC] [ACTION] Refresh')),
        retryController.stream
            .map((_) => Tuple3(state$.value, false, null))
            .doOnData((_) => print('[SEE_ALL_BLOC] [ACTION] Retry')),
      ],
    );

    /// Transform actions stream to state stream
    state$ = allActions$
        .withLatestFrom(
          localData.selectedProvince$,
          (tuple, province) {
            return Tuple5<SeeAllListState, bool, Completer<void>, Province,
                SeeAllQuery>.fromList([
              ...tuple.toList(growable: false),
              province,
              seeAllQuery,
            ]);
          },
        )
        .switchMap(
          (tuple) => seeAllInteractor.fetchData(
            tuple,
            messageController,
          ),
        )
        .publishValueSeededDistinct(seedValue: SeeAllListState.initial());

    /// Keep subscriptions and controllers references to dispose later
    final subscriptions = <StreamSubscription>[
      state$.listen((state) => print(
          '[SEE_ALL_BLOC] [STATE] rooms.length=${state.rooms.length}, '
          'isLoading=${state.isLoading}, error=${state.error}, snapshot=${state.lastDocumentSnapshot}'
          ', getAll=${state.getAll}')),
      state$.connect(),
    ];
    final controllers = <StreamController>[
      loadController,
      refreshController,
      retryController,
      messageController,
    ];

    return SeeAllBloc._(
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
      load: () => loadController.add(null),
      message$: messageController.stream,
      peopleList$: state$,
      refresh: () {
        final completer = Completer<void>();
        refreshController.add(completer);
        return completer.future;
      },
      retry: () => retryController.add(null),
    );
  }
}
