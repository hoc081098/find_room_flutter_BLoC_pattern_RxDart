import 'package:built_collection/built_collection.dart';
import 'package:charcode/charcode.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:find_room/pages/detail/detail/room_detail_tab_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class RoomDetailTabBloc implements BaseBloc {
  static const _tag = '[ROOM_DETAIL_TAB_BLOC]';

  final ValueStream<RoomDetailTabState> state$;

  final DisposeBag _disposeBag;

  @override
  void dispose() => _disposeBag.dispose().then((_) => print('$_tag disposed'));

  RoomDetailTabBloc._(
    this._disposeBag, {
    @required this.state$,
  });

  factory RoomDetailTabBloc(
    final FirestoreRoomRepository roomRepository,
    final FirebaseUserRepository userRepository,
    final NumberFormat priceFormat,
    final String roomId,
    final LocaleBloc localeBloc,
  ) {
    print('$_tag init');
    assert(roomRepository != null, 'roomRepository cannot be null');
    assert(userRepository != null, 'userRepository cannot be null');
    assert(priceFormat != null, 'priceFormat cannot be null');
    assert(roomId != null, 'roomId cannot be null');
    assert(localeBloc != null, 'localeBloc cannot be null');

    final roomDetail$ = roomRepository.findBy(roomId: roomId);

    final currentLangCode = () => localeBloc.locale$.value.languageCode;

    final state$ = Rx.combineLatest2(
      roomDetail$.map((room) {
        return _toRoomStateBuilder(
          currentLangCode(),
          room,
          priceFormat,
        );
      }),
      roomDetail$
          .map((room) => room?.user?.documentID)
          .switchMap((uid) => userRepository.getUserBy(uid: uid))
          .map(_toUserStateBuilder),
      (RoomDetailStateBuilder room, UserStateBuilder user) {
        return RoomDetailTabState(
          (b) => b
            ..room = room
            ..user = user,
        );
      },
    );

    final stateDistinct$ = state$.publishValueSeededDistinct(
        seedValue: RoomDetailTabState.initial());

    final disposeBag = DisposeBag(
      [
        stateDistinct$.listen((state) => print('$_tag state=$state')),
        stateDistinct$.connect(),
      ],
    );

    return RoomDetailTabBloc._(
      disposeBag,
      state$: stateDistinct$,
    );
  }

  static UserStateBuilder _toUserStateBuilder(UserEntity user) {
    if (user == null) {
      return null;
    }
    return UserStateBuilder()
      ..update(
        (b) => b
          ..id = user.id
          ..avatar = user.avatar
          ..fullName = user.fullName
          ..email = user.email
          ..phoneNumber = user.phone,
      );
  }

  static RoomDetailStateBuilder _toRoomStateBuilder(
    String currentLangCode,
    RoomEntity room,
    NumberFormat priceFormat,
  ) {
    if (room == null) {
      return null;
    }

    final format = NumberFormat.decimalPattern(currentLangCode);

    return RoomDetailStateBuilder()
      ..update(
        (b) {
          return b
            ..id = room.id
            ..title = room.title ?? ''
            ..description = room.description ?? ''
            ..price = priceFormat.format(room.price ?? 0)
            ..countView = format.format(room.countView ?? 0)
            ..size = '${format.format(room.size ?? 0)}m${$sup2}'
            ..address = room.address ?? ''
            ..images = ListBuilder<String>(room.images ?? <String>[])
            ..phone = room.phone
            ..available = room.available
            ..utilities = ListBuilder<Utility>(
              (room.utilities ?? []).map(
                (s) => Utility.valueOf(s),
              ),
            )
            ..createdAt = room.createdAt != null
                ? DateFormat.yMd(currentLangCode)
                    .add_Hms()
                    .format(room.createdAt.toDate())
                : null
            ..updatedAt = room.updatedAt != null
                ? DateFormat.yMd(currentLangCode)
                    .add_Hms()
                    .format(room.updatedAt.toDate())
                : null
            ..categoryName = room.categoryName ?? '';
        },
      );
  }
}
