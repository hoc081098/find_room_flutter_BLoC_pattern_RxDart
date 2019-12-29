import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/room_comments/room_comments_repository.dart';
import 'package:find_room/models/room_comment_entity.dart';

class RoomCommentsRepositoryImpl implements RoomCommentsRepository {
  final Firestore _firestore;

  const RoomCommentsRepositoryImpl(this._firestore);

  @override
  Stream<BuiltList<RoomCommentEntity>> commentsFor({String roomId}) {
    return _firestore
        .collection('comments')
        .where('room_id', isEqualTo: roomId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(_mapper);
  }

  BuiltList<RoomCommentEntity> _mapper(QuerySnapshot snapshot) {
    final entities = snapshot.documents
        .map((doc) => RoomCommentEntity.fromDocumentSnapshot(doc));
    return BuiltList.of(entities);
  }

  @override
  Future<void> deleteCommentBy({String id}) {
    if (id == null) {
      return Future.error('Id cannot be null');
    }
    return _firestore.document('comments/$id').delete();
  }

  @override
  Future<RoomCommentEntity> update({String content, String byId}) async {
    await _firestore.document('comments/$byId').setData(
      {
        'content': content,
        'updated_at': FieldValue.serverTimestamp(),
      },
      merge: true,
    );
    final documentSnapshot = await _firestore.document('comments/$byId').get();
    return RoomCommentEntity.fromDocumentSnapshot(documentSnapshot);
  }

  @override
  Future<void> add({RoomCommentEntity commentEntity}) async {
    Map<String, dynamic> json = commentEntity.toJson();
    json.remove('documentID');
    json['created_at'] = FieldValue.serverTimestamp();
    json['updated_at'] = null;
    print(json);
    await _firestore.collection('comments').add(json);
    print('done');
  }
}
