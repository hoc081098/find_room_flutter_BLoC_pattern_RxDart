import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/pages/saved/saved_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SavedBloc implements BaseBloc {
  ///
  /// Sinks
  ///
  final Sink<String> removeFromSaved;

  ///
  /// Streams
  ///
  final ValueObservable<SavedListState> savedListState$;

  ///
  /// Clean up
  ///
  final void Function() _dispose;

  SavedBloc._(this.removeFromSaved, this.savedListState$, this._dispose);

  factory SavedBloc({
    @required UserBloc userBloc,
    @required FirestoreRoomRepository roomRepository,
    @required NumberFormat priceFormat,
  }) {
    assert(userBloc != null, 'userBloc cannot be null');
    assert(roomRepository != null, 'roomRepository cannot be null');
    assert(priceFormat != null, 'priceFormat cannot be null');

    final removeFromSaved = PublishSubject<String>(sync: true);
    final savedListStateController =
        BehaviorSubject<SavedListState>(seedValue: Loading());

    final subscriptions = [
      userBloc.userLoginState$.switchMap((loginState) {
        return _toState(
          loginState,
          roomRepository,
          priceFormat,
        );
      }).listen((state) {
        if (savedListStateController.value != state) {
          savedListStateController.add(state);
        }
      }),
      removeFromSaved.listen((roomId) {
        _handleRemoveFromSaved(
          roomId,
          roomRepository,
          savedListStateController,
          userBloc.userLoginState$.value,
        );
      }),
    ];

    return SavedBloc._(
      removeFromSaved,
      savedListStateController.stream,
      () {
        savedListStateController.close();
        removeFromSaved.close();
        subscriptions.forEach((s) => s.cancel());
      },
    );
  }

  @override
  void dispose() => _dispose();

  static Observable<SavedListState> _toState(
    UserLoginState loginState,
    FirestoreRoomRepository roomRepository,
    NumberFormat priceFormat,
  ) {
    if (loginState is NotLogin) {
      return Observable.just(Loading());
    }
    if (loginState is UserLogin) {
      return Observable(roomRepository.savedList(uid: loginState.uid))
          .map((entities) {
            return _entitiesToRoomItems(
              entities,
              priceFormat,
              loginState.uid,
            );
          })
          .map<SavedListState>((roomItems) => SavedList(roomItems))
          .startWith(Loading());
    }
    return Observable.error("Don't know loginState=$loginState");
  }

  static List<RoomItem> _entitiesToRoomItems(
    List<RoomEntity> entities,
    NumberFormat priceFormat,
    String uid,
  ) {
    return entities.map((entity) {
      return RoomItem(
        id: entity.id,
        title: entity.title,
        price: priceFormat.format(entity.price),
        address: entity.address,
        districtName: entity.districtName,
        image: entity.images.isNotEmpty ? entity.images.first : null,
        savedTime: entity.userIdsSaved[uid].toDate(),
      );
    }).toList();
  }

  static _handleRemoveFromSaved(
    String roomId,
    FirestoreRoomRepository roomRepository,
    BehaviorSubject<SavedListState> savedListStateController,
    UserLoginState loginState,
  ) async {
    print('roomId=$roomId');
    final state = savedListStateController.value;

    if (state is SavedList) {
      final removedState =
          SavedList(state.roomItems.where((item) => item.id != roomId));
      savedListStateController.add(removedState);

      if (loginState is UserLogin) {
        try {
          final result = await roomRepository.addOrRemoveSavedRoom(
            roomId: roomId,
            userId: loginState.uid,
          );
          if (result['status'] != 'removed') {
            savedListStateController.add(state);
          }
          print('result=$result, uid=${loginState.uid}');
        } catch (e) {
          savedListStateController.add(state);
          print('e=$e');
        }
      }
    }
  }
}
