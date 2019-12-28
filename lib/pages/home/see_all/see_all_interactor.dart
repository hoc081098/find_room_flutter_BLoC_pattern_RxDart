import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/pages/home/see_all/see_all_state.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

const _pageSize = 20;

class SeeAllInteractor {
  final FirestoreRoomRepository _roomRepository;
  final NumberFormat _priceFormat;
  final bool _debug;

  const SeeAllInteractor(
    this._roomRepository,
    this._priceFormat,
    this._debug,
  );

  Stream<SeeAllListState> fetchData(
    Tuple5<SeeAllListState, bool, Completer<void>, Province, SeeAllQuery> tuple,
    Sink<SeeAllMessage> messageSink,
  ) {
    /// Destruct variables from [tuple]
    final currentState = tuple.item1;
    final refreshList = tuple.item2;
    final completer = tuple.item3;
    final province = tuple.item4;
    final seeAllQuery = tuple.item5;

    if (!refreshList && currentState.getAll) {
      return Stream.value(currentState);
    }

    /// Get rooms from [_roomRepository]
    final getRoomsFuture = getRooms(
      after: refreshList ? null : currentState.lastDocumentSnapshot,
      province: province,
      seeAllQuery: seeAllQuery,
    );

    ///
    ///
    ///
    toListState(Tuple2<List<SeeAllRoomItem>, DocumentSnapshot> tuple2) {
      final rooms = tuple2.item1;
      final lastDocumentSnapshot = tuple2.item2;

      return SeeAllListState(
        (b) {
          final listBuilder = currentState.rooms.toBuilder()
            ..update((b) {
              if (refreshList) {
                b.clear();
              }
              b.addAll(rooms);
            });

          if (lastDocumentSnapshot != null) {
            b.lastDocumentSnapshot = lastDocumentSnapshot;
          }

          return b
            ..error = null
            ..isLoading = false
            ..rooms = listBuilder
            ..getAll = rooms.isEmpty;
        },
      );
    }

    toErrorState(dynamic e) {
      print(e);
      return currentState.rebuild(
        (b) => b
          ..error = UnknownError(e)
          ..getAll = false
          ..isLoading = false,
      );
    }

    final loadingState = currentState.rebuild((b) => b
      ..isLoading = true
      ..getAll = false
      ..error = null);

    ///
    /// Perform side affects:
    ///
    /// - Add [LoadAllMessage] or [ErrorMessage] to [messageSink]
    /// - Complete [completer] if [completer] is not null
    ///
    addLoadAllMessageIfLoadedAll(SeeAllListState state) {
      if (state.getAll) {
        messageSink.add(const LoadAllMessage());
      }
    }

    addErrorMessage(dynamic error, StackTrace _) =>
        messageSink.add(ErrorMessage(error));

    completeCompleter() => completer?.complete();

    ///
    /// Return state [Stream]
    ///
    return Stream.fromFuture(getRoomsFuture)
        .map(toListState)
        .doOnData(addLoadAllMessageIfLoadedAll)
        .doOnError(addErrorMessage)
        .startWith(loadingState)
        .onErrorReturnWith(toErrorState)
        .doOnDone(completeCompleter);
  }

  Tuple2<List<SeeAllRoomItem>, DocumentSnapshot> _entitiesToItems(
    Tuple2<List<RoomEntity>, DocumentSnapshot> tuple,
  ) {
    final rooms = tuple.item1.map((entity) {
      return SeeAllRoomItem((b) => b
        ..id = entity.id
        ..title = entity.title
        ..address = entity.address
        ..price = _priceFormat.format(entity.price)
        ..image = entity.images.isEmpty ? null : entity.images.first
        ..districtName = entity.districtName
        ..createdTime = entity.createdAt.toDate()
        ..updatedTime = entity.updatedAt.toDate());
    }).toList(growable: false);
    return Tuple2(rooms, tuple.item2);
  }

  Future<Tuple2<List<SeeAllRoomItem>, DocumentSnapshot>> getRooms({
    @required SeeAllQuery seeAllQuery,
    @required Province province,
    @required DocumentSnapshot after,
  }) {
    Stream<Tuple2<List<RoomEntity>, DocumentSnapshot>> stream;
    switch (seeAllQuery) {
      case SeeAllQuery.newest:
        stream = _roomRepository.newestRooms(
          selectedProvince: province,
          limit: _pageSize,
          after: after,
        );
        break;
      case SeeAllQuery.mostViewed:
        stream = _roomRepository.mostViewedRooms(
          selectedProvince: province,
          limit: _pageSize,
          after: after,
        );
        break;
    }
    return stream
        .map(_entitiesToItems)
        .delay(_debug ? const Duration(seconds: 3) : const Duration(seconds: 1))
        .first;
  }
}
