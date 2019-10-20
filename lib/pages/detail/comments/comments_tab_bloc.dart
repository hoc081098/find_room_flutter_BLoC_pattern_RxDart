import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/room_comments/room_comments_repository.dart';
import 'package:find_room/pages/detail/comments/comments_tab_state.dart';
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
  }) {
    final getCommentS = PublishSubject<void>();

    final initialVS = CommentsTabState.initial();

    final state$ = getCommentS.exhaustMap((_) {
      return commentsRepository
          .commentsFor(roomId: roomId)
          .map<PartialChange>(
            (entities) {
              final items = entities
                  .map((entity) => CommentItem.fromEntity(entity))
                  .toList();
              return Data(items);
            },
          )
          .startWith(const Loading())
          .onErrorReturnWith((e) => Error(e));
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
}
