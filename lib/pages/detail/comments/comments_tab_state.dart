import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:find_room/models/room_comment_entity.dart';
import 'package:intl/intl.dart';

part 'comments_tab_state.g.dart';

///
/// Message
///
abstract class CommentsTabMessage {}

class DeleteCommentSuccess implements CommentsTabMessage {
  final CommentItem comment;

  DeleteCommentSuccess(this.comment);
}

class DeleteCommentFailure implements CommentsTabMessage {
  final CommentItem comment;
  final error;

  DeleteCommentFailure(this.comment, this.error);
}

class UpdateCommentSuccess implements CommentsTabMessage {
  final CommentItem updated;

  UpdateCommentSuccess(this.updated);
}

class UpdateCommentFailure implements CommentsTabMessage {
  final CommentItem comment;
  final error;

  UpdateCommentFailure(this.comment, this.error);
}

class MinLengthOfCommentIs3 implements CommentsTabMessage {
  const MinLengthOfCommentIs3();
}

class UnauthenticatedError implements CommentsTabMessage {
  const UnauthenticatedError();
}

class AddCommentSuccess implements CommentsTabMessage {
  final String content;

  const AddCommentSuccess(this.content);
}

class AddCommentFailure implements CommentsTabMessage {
  final String content;
  final error;

  const AddCommentFailure(this.content, this.error);
}

///
/// PartialChange
///
abstract class PartialChange {
  CommentsTabState reducer(CommentsTabState vs);
}

class Loading implements PartialChange {
  const Loading();

  @override
  CommentsTabState reducer(CommentsTabState vs) {
    return vs.rebuild((b) => b..isLoading = true);
  }
}

class Data implements PartialChange {
  final List<CommentItem> comments;

  Data(this.comments);

  @override
  CommentsTabState reducer(CommentsTabState vs) {
    return vs.rebuild(
      (b) => b
        ..isLoading = false
        ..error = null
        ..comments = ListBuilder<CommentItem>(comments),
    );
  }
}

class Error implements PartialChange {
  final error;

  Error(this.error);

  @override
  CommentsTabState reducer(CommentsTabState vs) {
    return vs.rebuild(
      (b) => b
        ..isLoading = false
        ..error = error,
    );
  }
}

///
/// View state
///
abstract class CommentsTabState
    implements Built<CommentsTabState, CommentsTabStateBuilder> {
  bool get isLoading;

  BuiltList<CommentItem> get comments;

  @nullable
  Object get error;

  bool get isLoggedIn;

  CommentsTabState._();

  factory CommentsTabState([updates(CommentsTabStateBuilder b)]) =
      _$CommentsTabState;

  factory CommentsTabState.initial(bool isLoggedIn) => CommentsTabState(
        (b) => b
          ..isLoading = true
          ..error = null
          ..comments = ListBuilder<CommentItem>()
          ..isLoggedIn = isLoggedIn,
      );
}

abstract class CommentItem implements Built<CommentItem, CommentItemBuilder> {
  String get id;

  @nullable
  String get content;

  String get roomId;

  bool get isCurrentUser;

  String get userId;

  String get userAvatar;

  String get userName;

  @nullable
  String get createdAt;

  @nullable
  String get updatedAt;

  CommentItem._();

  factory CommentItem([updates(CommentItemBuilder b)]) = _$CommentItem;

  factory CommentItem.fromEntity(
    RoomCommentEntity entity,
    DateFormat dateFormat,
    String currentUserId,
  ) {
    return CommentItem(
      (b) => b
        ..id = entity.id
        ..content = entity.content
        ..roomId = entity.roomId
        ..isCurrentUser = entity.userId == currentUserId
        ..userId = entity.userId
        ..userName = entity.userName
        ..userAvatar = entity.userAvatar
        ..createdAt = entity.createdAt == null
            ? null
            : dateFormat.format(entity.createdAt.toDate())
        ..updatedAt = entity.updatedAt == null
            ? null
            : dateFormat.format(entity.updatedAt.toDate()),
    );
  }
}
