import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
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
  final void Function(String) commentChanged;
  final void Function() submitAddComment;

  final ValueStream<CommentsTabState> state$;
  final Stream<CommentsTabMessage> message$;

  final DisposeBag _disposeBag;

  CommentsTabBloc._(
    this.getComments,
    this.deleteComment,
    this.updateComment,
    this.commentChanged,
    this.submitAddComment,
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
    final commentChangedS = PublishSubject<String>();
    final submitAddCommentS = PublishSubject<void>();
    final controllers = [
      getCommentS,
      deleteCommentS,
      updateCommentS,
      commentChangedS,
      submitAddCommentS
    ];

    final initialVS = CommentsTabState.initial(authBloc.currentUser() != null);

    final scannedState$ = getCommentS.exhaustMap((_) {
      return Rx.combineLatest2(
        commentsRepository.commentsFor(roomId: roomId),
        authBloc.loginState$,
        (entities, loginState) =>
            _toDataChange(entities, loginState, dateFormatter),
      ).startWith(const Loading()).onErrorReturnWith((e) => Error(e));
    }).scan((state, change, _) => change.reducer(state), initialVS);

    final state$ = Rx.combineLatest2(
      scannedState$,
      authBloc.loginState$,
      (CommentsTabState state, LoginState loginState) {
        var isLoggedIn = false;
        if (loginState == null) {
          isLoggedIn = false;
        } else if (loginState is LoggedInUser) {
          isLoggedIn = true;
        } else if (loginState is Unauthenticated) {
          isLoggedIn = false;
        }

        return state.rebuild((b) => b..isLoggedIn = isLoggedIn);
      },
    ).publishValueSeededDistinct(seedValue: initialVS);

    final comment$ = submitAddCommentS
        .withLatestFrom(commentChangedS, (_, String comment) => comment)
        .map((comment) {
      if (comment.length < 3) {
        return Tuple2(comment, const MinLengthOfCommentIs3());
      } else {
        return Tuple2(comment, null);
      }
    }).share();

    final ConnectableStream<CommentsTabMessage> message$ = Rx.merge(
      [
        deleteCommentS.groupBy((comment) => comment.id).flatMap(
              (comment$) => _deleteComment(
                comment$,
                commentsRepository,
              ),
            ),
        updateCommentS.groupBy((tuple) => tuple.item1.id).flatMap(
          (tuple$) {
            return _updateCommentContent(
              tuple$,
              commentsRepository,
              dateFormatter,
              authBloc,
            );
          },
        ),
        comment$
            .map((tuple) => tuple.item2)
            .where((message) => message != null),
        comment$
            .where((tuple) => tuple.item2 == null)
            .map((tuple) => tuple.item1)
            .exhaustMap((content) =>
                _addComment(content, authBloc, commentsRepository, roomId)),
      ],
    ).publish();

    return CommentsTabBloc._(
      () => getCommentS.add(null),
      deleteCommentS.add,
      (comment, content) => updateCommentS.add(Tuple2(comment, content)),
      commentChangedS.add,
      () => submitAddCommentS.add(null),
      state$,
      message$,
      DisposeBag(
        [
          state$.listen((state) => print(
              '$_tag ${state.isLoading} ${state.error} ${state.comments.length}')),
          state$.connect(),
          message$.connect(),
          commentChangedS.listen(print),
          ...controllers,
        ],
      ),
    );
  }

  @override
  void dispose() => _disposeBag.dispose().then((_) => print('$_tag disposed'));
}

PartialChange _toDataChange(
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

Stream<CommentsTabMessage> _updateCommentContent(
  Stream<Tuple2<CommentItem, String>> tuple$,
  RoomCommentsRepository commentsRepository,
  DateFormat dateFormatter,
  AuthBloc authBloc,
) {
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
}

Stream<CommentsTabMessage> _deleteComment(
  Stream<CommentItem> comment$,
  RoomCommentsRepository commentsRepository,
) {
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
}

Stream<CommentsTabMessage> _addComment(
  String content,
  AuthBloc authBloc,
  RoomCommentsRepository commentsRepository,
  String roomId,
) async* {
  final currentUser = authBloc.currentUser();
  if (currentUser == null) {
    yield const UnauthenticatedError();
  }
  try {
    await commentsRepository.add(
      commentEntity: RoomCommentEntity(
        null,
        content,
        roomId,
        currentUser.uid,
        currentUser.avatar,
        currentUser.fullName,
        null,
        null,
      ),
    );
    yield AddCommentSuccess(content);
  } catch (e) {
    yield AddCommentFailure(content, e);
  }
}
