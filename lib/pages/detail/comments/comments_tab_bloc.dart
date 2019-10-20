import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/room_comments/room_comments_repository.dart';
import 'package:find_room/models/room_comment_entity.dart';
import 'package:find_room/pages/detail/comments/comments_tab_state.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class CommentsTabBloc implements BaseBloc {
  static const _tag = '[COMMENTS_BLOC]';

  final void Function() getComments;

  final ValueObservable<CommentsTabState> state$;

  final DisposeBag _disposeBag;

  CommentsTabBloc._(
    this.getComments,
    this.state$,
    this._disposeBag,
  );

  factory CommentsTabBloc({
    @required final RoomCommentsRepository commentsRepository,
    @required final String roomId,
    @required final DateFormat dateFormatter,
    @required final AuthBloc authBloc,
  }) {
    final getCommentS = PublishSubject<void>();

    final initialVS = CommentsTabState.initial();

    final state$ = getCommentS.exhaustMap((_) {
      return Observable.combineLatest2(
        commentsRepository.commentsFor(roomId: roomId),
        authBloc.loginState$,
        (entities, loginState) =>
            _toDataChange(entities, loginState, dateFormatter),
      ).startWith(const Loading()).onErrorReturnWith((e) => Error(e));
    }).scan((state, change, _) => change.reducer(state), initialVS);

    final stateDistinct$ =
        publishValueSeededDistinct(state$, seedValue: initialVS);

    return CommentsTabBloc._(
      () => getCommentS.add(null),
      stateDistinct$,
      DisposeBag([
        stateDistinct$.listen((state) => print(
            '$_tag ${state.isLoading} ${state.error} ${state.comments.length}')),
        stateDistinct$.connect(),
        getCommentS,
      ]),
    );
  }

  @override
  void dispose() => _disposeBag.dispose().then((_) => print('$_tag disposed'));

  static PartialChange _toDataChange(
    BuiltList<RoomCommentEntity> entities,
    LoginState loginState,
    DateFormat dateFormatter,
  ) {
    final items = entities.map(
      (entity) {
        return CommentItem.fromEntity(
          entity,
          dateFormatter,
          loginState is LoggedInUser ? loginState.uid : null,
        );
      },
    ).toList();
    return Data(items);
  }
}
