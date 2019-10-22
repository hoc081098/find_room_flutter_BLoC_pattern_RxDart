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
import 'package:tuple/tuple.dart';

class CommentsTabBloc implements BaseBloc {
  static const _tag = '[COMMENTS_BLOC]';

  final void Function() getComments;
  final void Function(CommentItem) deleteComment;
  final void Function(CommentItem, String) updateComment;

  final ValueObservable<CommentsTabState> state$;
  final Stream<CommentsTabMessage> message$;

  final DisposeBag _disposeBag;

  CommentsTabBloc._(
    this.getComments,
    this.deleteComment,
    this.updateComment,
    this.state$,
    this.message$,
    this._disposeBag,
  );

  factory CommentsTabBloc({
    @required final RoomCommentsRepository commentsRepository,
    @required final String roomId,
    @required final DateFormat dateFormatter,
    @required final AuthBloc authBloc,
  }) {
    // ignore_for_file: close_sinks
    final getCommentS = PublishSubject<void>();
    final deleteCommentS = PublishSubject<CommentItem>();
    final updateCommentS = PublishSubject<Tuple2<CommentItem, String>>();

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

    final ConnectableObservable<CommentsTabMessage> message$ = Observable.merge(
      [
        deleteCommentS.groupBy((comment) => comment.id).flatMap((comment$) {
          return comment$.exhaustMap(
            (comment) async* {
              try {
                await commentsRepository.deleteCommentBy(id: comment.id);
                yield DeleteCommentSuccess(comment);
              } catch (e) {
                yield DeleteCommentFailure(comment, e);
              }
            },
          );
        }),
        updateCommentS.groupBy((tuple) => tuple.item1.id).flatMap((tuple$) {
          return tuple$.switchMap(
            (tuple) async* {
              final comment = tuple.item1;
              final content = tuple.item2;

              try {
                final updated = await commentsRepository.update(
                  content: content,
                  byId: comment.id,
                );
                yield UpdateCommentSuccess(
                  CommentItem.fromEntity(
                    updated,
                    dateFormatter,
                    authBloc.currentUser()?.uid,
                  ),
                );
              } catch (e) {
                yield UpdateCommentFailure(comment, e);
              }
            },
          );
        }),
      ],
    ).publish();

    return CommentsTabBloc._(
      () => getCommentS.add(null),
      deleteCommentS.add,
      (comment, content) => updateCommentS.add(Tuple2(comment, content)),
      stateDistinct$,
      message$,
      DisposeBag(
        [
          stateDistinct$.listen((state) => print(
              '$_tag ${state.isLoading} ${state.error} ${state.comments.length}')),
          stateDistinct$.connect(),
          message$.connect(),
          getCommentS,
          deleteCommentS,
        ],
      ),
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
