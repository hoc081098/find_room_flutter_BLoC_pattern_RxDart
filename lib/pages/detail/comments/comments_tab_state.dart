import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:find_room/models/room_comment_entity.dart';

part 'comments_tab_state.g.dart';

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

abstract class CommentsTabState
    implements Built<CommentsTabState, CommentsTabStateBuilder> {
  bool get isLoading;

  BuiltList<CommentItem> get comments;

  @nullable
  Object get error;

  CommentsTabState._();

  factory CommentsTabState([updates(CommentsTabStateBuilder b)]) =
      _$CommentsTabState;

  factory CommentsTabState.initial() => CommentsTabState(
        (b) => b
          ..isLoading = true
          ..error = null
          ..comments = ListBuilder<CommentItem>(),
      );
}

abstract class CommentItem implements Built<CommentItem, CommentItemBuilder> {
  String get id;

  String get content;

  String get roomId;

  String get userId;

  String get userAvatar;

  String get userName;

  @nullable
  DateTime get createdAt;

  @nullable
  DateTime get updatedAt;

  CommentItem._();

  factory CommentItem([updates(CommentItemBuilder b)]) = _$CommentItem;

  factory CommentItem.fromEntity(RoomCommentEntity entity) {
    return CommentItem(
      (b) => b
        ..id = entity.id
        ..content = entity.content
        ..roomId = entity.roomId
        ..userId = entity.userId
        ..userName = entity.userName
        ..userAvatar = entity.userAvatar
        ..createdAt = entity.createdAt?.toDate()
        ..updatedAt = entity.updatedAt?.toDate(),
    );
  }
}
