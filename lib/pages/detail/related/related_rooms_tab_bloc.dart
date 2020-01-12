import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_state.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class RelatedRoomsTabBloc implements BaseBloc {
  /// Output
  final ValueStream<RelatedRoomsState> state$;
  final Stream<Message> message$;

  /// Input
  final void Function() fetch;
  final Future<void> Function() refresh;

  /// Dispose
  final void Function() _dispose;

  @override
  void dispose() => _dispose();

  RelatedRoomsTabBloc._(
    this._dispose, {
    @required this.state$,
    @required this.fetch,
    @required this.refresh,
    @required this.message$,
  });

  factory RelatedRoomsTabBloc(
    FirestoreRoomRepository roomsRepo,
    NumberFormat priceFormat,
    String roomId,
  ) {
    // ignore_for_file: close_sinks

    ///
    /// Subjects
    ///
    final fetchSubject = PublishSubject<void>();
    final refreshSubject = PublishSubject<Completer<void>>();
    final messageSubject = PublishSubject<Message>();

    ///
    /// Input actions to state
    ///
    final fetchChanges = fetchSubject.exhaustMap(
      (_) => Rx.defer(() =>
              Stream.fromFuture(roomsRepo.getRelatedRoomsBy(roomId: roomId)))
          .map((entities) => _toItem(entities, priceFormat))
          .map<PartialStateChange>((items) => GetUsersSuccessChange(items))
          .startWith(const LoadingChange())
          .doOnError((e, s) => messageSubject.add(GetRoomsErrorMessage(e)))
          .onErrorReturnWith((e) => GetUsersErrorChange(e)),
    );
    final refreshChanges = refreshSubject
        .throttleTime(const Duration(milliseconds: 600))
        .exhaustMap(
          (completer) => Rx.defer(() => Stream.fromFuture(
                  roomsRepo.getRelatedRoomsBy(roomId: roomId)))
              .map((entities) => _toItem(entities, priceFormat))
              .map<PartialStateChange>((items) => GetUsersSuccessChange(items))
              .doOnError((e, s) => messageSubject.add(RefreshFailureMessage(e)))
              .doOnData(
                  (_) => messageSubject.add(const RefreshSuccessMessage()))
              .onErrorResumeNext(Stream.empty())
              .doOnDone(() => completer.complete()),
        );

    final initialState = RelatedRoomsState.initial();
    final state$ = Rx.merge([fetchChanges, refreshChanges])
        .scan(_reduce, initialState)
        .publishValueSeededDistinct(seedValue: initialState);

    return RelatedRoomsTabBloc._(
      DisposeBag([
        //subscriptions
        state$.listen((state) => print('[HOME_BLOC] state=$state')),
        messageSubject
            .listen((message) => print('[HOME_BLOC] message=$message')),
        state$.connect(),
        //controllers
        fetchSubject,
        refreshSubject,
        messageSubject,
      ]).dispose,
      state$: state$,
      fetch: () => fetchSubject.add(null),
      refresh: () {
        final completer = Completer<void>();
        refreshSubject.add(completer);
        return completer.future;
      },
      message$: messageSubject,
    );
  }

  ///
  /// Reduce
  ///
  static RelatedRoomsState _reduce(
    RelatedRoomsState state,
    PartialStateChange change,
    int _,
  ) {
    if (change is LoadingChange) {
      return state.rebuild((b) => b.isLoading = true);
    }
    if (change is GetUsersErrorChange) {
      return state.rebuild(
        (b) => b
          ..isLoading = false
          ..error = change.error,
      );
    }
    if (change is GetUsersSuccessChange) {
      return state.rebuild(
        (b) => b
          ..isLoading = false
          ..error = null
          ..items = ListBuilder<RoomItem>(change.items),
      );
    }
    return state;
  }

  static List<RoomItem> _toItem(
    List<RoomEntity> entities,
    NumberFormat priceFormat,
  ) {
    return entities
        .map(
          (e) => RoomItem(
            (b) => b
              ..id = e.id
              ..imageUrl = e.images.isEmpty ? null : e.images.first
              ..title = e.title
              ..districtName = e.districtName
              ..address = e.address
              ..price = priceFormat.format(e.price)
              ..createdTime = e.createdAt?.toDate()
              ..updatedTime = e.updatedAt?.toDate(),
          ),
        )
        .toList(growable: false);
  }
}
