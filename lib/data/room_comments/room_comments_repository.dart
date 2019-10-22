import 'package:built_collection/built_collection.dart';
import 'package:find_room/models/room_comment_entity.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class RoomCommentsRepository {
  Stream<BuiltList<RoomCommentEntity>> commentsFor({@required String roomId});

  Future<void> deleteCommentBy({@required String id});

  Future<RoomCommentEntity> update({@required String content,@required String byId});
}
