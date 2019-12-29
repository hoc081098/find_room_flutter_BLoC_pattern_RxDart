import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/pages/detail/room_detail_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:tuple/tuple.dart';

// ignore_for_file: close_sinks

class RoomDetailBloc implements BaseBloc {
  final ValueStream<BookmarkIconState> bookmarkIconState$;
  final ValueStream<int> selectedIndex$;
  final Stream<RoomDetailMessage> message$;
  final ValueStream<bool> isCreatedByCurrentUser$;

  final void Function(int) changeIndex;
  final void Function() addOrRemoveSaved;
  final void Function() shareRoom;

  final DisposeBag _bag;

  RoomDetailBloc._(
    this._bag, {
    @required this.selectedIndex$,
    @required this.changeIndex,
    @required this.bookmarkIconState$,
    @required this.message$,
    @required this.addOrRemoveSaved,
    @required this.isCreatedByCurrentUser$,
    @required this.shareRoom,
  });

  @override
  void dispose() => _bag.dispose().then((_) => print('[DETAIL_BLOC] Disposed'));

  factory RoomDetailBloc({
    @required final String roomId,
    @required final FirestoreRoomRepository roomRepository,
    @required final AuthBloc authBloc,
    @required final NumberFormat priceFormat,
  }) {
    assert(roomId != null, 'roomId cannot be null');
    assert(roomRepository != null, 'roomRepository cannot be null');
    assert(authBloc != null, 'authBloc cannot be null');
    _increaseViewCount(roomRepository, roomId);

    ///
    /// Subject
    ///
    final selectedIndexS = PublishSubject<int>();
    final addOrRemoveSavedS = PublishSubject<void>();
    final bookmarkIconStateS =
        BehaviorSubject.seeded(BookmarkIconState.loading);
    final shareRoomS = PublishSubject<void>();

    ///
    /// Shared streams
    ///
    final room$ = roomRepository.findBy(roomId: roomId);

    final currentUid$ = authBloc.loginState$
        .map((state) => state is LoggedInUser ? state.uid : null);

    ///
    /// Combined stream from shared stream
    ///

    final selectedIndex$ =
        selectedIndexS.publishValueSeededDistinct(seedValue: 0);

    final isCreatedByCurrentUser$ = Rx.combineLatest2(
      room$.map((room) => room.user.documentID),
      currentUid$,
      (createdUid, currentUid) => createdUid == currentUid$,
    ).publishValueSeededDistinct(seedValue: false);

    final message$ = addOrRemoveSavedS
        .throttleTime(const Duration(milliseconds: 600))
        .withLatestFrom(
          authBloc.loginState$,
          (void _, LoginState userLoginState) => Tuple2(roomId, userLoginState),
        )
        .exhaustMap(
          (tuple2) => _addOrRemoveSavedRoom(
            tuple2,
            roomRepository,
            bookmarkIconStateS,
            bookmarkIconStateS.value,
          ),
        )
        .publish();

    ///
    /// Dispose bag
    ///
    final bag = DisposeBag([
      // connect
      selectedIndex$.connect(),
      message$.connect(),
      isCreatedByCurrentUser$.connect(),
      // listen
      message$.listen((message) => print('[DETAIL_BLOC] message=$message')),
      selectedIndex$
          .listen((index) => print('[DETAIL_BLOC] selectedIndex=$index')),
      bookmarkIconStateS.stream.listen(
          (iconState) => print('[DETAIL_BLOC] bookmarkIconState=$iconState')),
      isCreatedByCurrentUser$
          .listen((b) => print('[DETAIL_BLOC] isCreatedByCurrentUser=$b')),
      _getBookMarkIconState$(
        room$.map((r) => r.userIdsSaved),
        currentUid$,
      ).listen((state) {
        if (state != bookmarkIconStateS.value) {
          bookmarkIconStateS.add(state);
        }
      }),
      shareRoomS
          .withLatestFrom(room$, (_, RoomEntity room) => room)
          .exhaustMap(
            (room) => Rx.defer(
              () => Stream.fromFuture(
                Share.share(
                    'Title: ${room.title}\n• Price: ${priceFormat.format(room.price)}\n•'
                    ' Address: ${room.districtName} - ${room.address}'
                    '\n• Description: ${room.description}\n• Image: ${room.images[0]}'),
              ),
            ),
          )
          .listen(null),
      // controllers
      selectedIndexS,
      addOrRemoveSavedS,
      bookmarkIconStateS,
    ]);

    return RoomDetailBloc._(
      bag,
      selectedIndex$: selectedIndex$,
      changeIndex: selectedIndexS.add,
      bookmarkIconState$: bookmarkIconStateS.stream,
      message$: message$,
      addOrRemoveSaved: () => addOrRemoveSavedS.add(null),
      isCreatedByCurrentUser$: isCreatedByCurrentUser$,
      shareRoom: () => shareRoomS.add(null),
    );
  }

  static void _increaseViewCount(
    FirestoreRoomRepository roomRepository,
    String roomId,
  ) {
    roomRepository.increaseViewCount(roomId).then((_) {
      print('>>>> increase success');
      Firestore.instance
          .document('motelrooms/$roomId')
          .get()
          .then((snapshot) => print(snapshot.data['count_view']));
    }).catchError((e) => print('>>> increase error=$e'));
  }

  static Stream<BookmarkIconState> _getBookMarkIconState$(
    Stream<Map<String, Timestamp>> room$,
    Stream<String> currentUid$,
  ) {
    return Rx.combineLatest2(
      room$,
      currentUid$,
      (Map<String, Timestamp> userIdsSaved, String uid) {
        // not logged in
        if (uid == null) {
          return BookmarkIconState.hide;
        }
        if (userIdsSaved.containsKey(uid)) {
          return BookmarkIconState.showSaved;
        }
        return BookmarkIconState.showNotSaved;
      },
    ).startWith(BookmarkIconState.loading);
  }

  static Stream<RoomDetailMessage> _addOrRemoveSavedRoom(
    Tuple2<String, LoginState> tuple,
    FirestoreRoomRepository roomRepository,
    Sink<BookmarkIconState> bookmarkIconStateSink,
    BookmarkIconState prevIconState,
  ) {
    final roomId = tuple.item1;
    final loginState = tuple.item2;

    final userId = loginState is LoggedInUser ? loginState.uid : null;
    if (userId == null) {
      final error = const AddOrRemovedSavedErrorMessage(UnauthenticatedError());
      return Stream.value(error);
    }

    final getMessageFromResult = (Map<String, String> result) {
      if (result['status'] == 'added') {
        return const AddSavedSuccessMessage();
      }
      if (result['status'] == 'removed') {
        return const RemoveSavedSuccessMessage();
      }
      return null;
    };

    return Rx.defer(() => Stream.fromFuture(
              roomRepository.addOrRemoveSavedRoom(
                roomId: roomId,
                userId: userId,
              ),
            ))
        .doOnListen(() => bookmarkIconStateSink.add(BookmarkIconState.loading))
        .doOnData(
            (result) => _updateBookIconState(result, bookmarkIconStateSink))
        .doOnError((e, s) => bookmarkIconStateSink.add(prevIconState))
        .map(getMessageFromResult)
        .onErrorReturnWith(
            (e) => AddOrRemovedSavedErrorMessage(UnknownError(e)));
  }

  static void _updateBookIconState(
    Map<String, String> result,
    Sink<BookmarkIconState> bookmarkIconStateSink,
  ) {
    print(result);
    final status = result['status'];

    final iconState = status == 'added'
        ? BookmarkIconState.showSaved
        : status == 'removed'
            ? BookmarkIconState.showNotSaved
            : BookmarkIconState.hide;

    bookmarkIconStateSink.add(iconState);
  }
}
