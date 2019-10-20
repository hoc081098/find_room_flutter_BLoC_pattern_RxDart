import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/room_comments/room_comments_repository.dart';
import 'package:find_room/models/room_comment_entity.dart';
import 'package:rxdart/rxdart.dart';

class RoomCommentsRepositoryImpl implements RoomCommentsRepository {
  final Firestore _firestore;

  const RoomCommentsRepositoryImpl(this._firestore);

  @override
  Observable<BuiltList<RoomCommentEntity>> commentsFor({String roomId}) {
    return Observable(
      _firestore
          .collection('comments')
          .where('room_id', isEqualTo: roomId)
          .orderBy('created_at', descending: true)
          .snapshots()
          .map(_mapper),
    );
  }

  BuiltList<RoomCommentEntity> _mapper(QuerySnapshot snapshot) {
    final entities = snapshot.documents
        .map((doc) => RoomCommentEntity.fromDocumentSnapshot(doc));
    return BuiltList.of(entities);
  }
}
