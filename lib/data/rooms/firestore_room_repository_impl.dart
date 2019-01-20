import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/rooms/firestore_room_repository.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreRoomRepositoryImpl implements FirestoreRoomRepository {
  final Firestore _firestore;

  const FirestoreRoomRepositoryImpl(this._firestore);

  @override
  Stream<List<RoomEntity>> mostViewedRooms({
    Province selectedProvince,
    int limit,
  }) {
    if (selectedProvince == null) {
      return Observable.error("Selected province id must be not null");
    }
    if (limit == null) {
      return Observable.error("Limit must be not null");
    }

    final DocumentReference selectedProvinceRef =
        _firestore.document('provinces/${selectedProvince.id}');

    return _firestore
        .collection('motelrooms')
        .where('province', isEqualTo: selectedProvinceRef)
        .where('approve', isEqualTo: true)
        .where('available', isEqualTo: true)
        .orderBy('updated_at', descending: true)
        .limit(limit)
        .snapshots()
        .map(_toEntities);
  }

  @override
  Stream<List<RoomEntity>> newestRooms({Province selectedProvince, int limit}) {
    if (selectedProvince == null) {
      return Observable.error("Selected province id must be not null");
    }
    if (limit == null) {
      return Observable.error("Limit must be not null");
    }

    final DocumentReference selectedProvinceRef =
        _firestore.document('provinces/${selectedProvince.id}');

    return _firestore
        .collection('motelrooms')
        .where('province', isEqualTo: selectedProvinceRef)
        .where('approve', isEqualTo: true)
        .where('available', isEqualTo: true)
        .orderBy('count_view', descending: true)
        .limit(limit)
        .snapshots()
        .map(_toEntities);
  }

  @override
  Future<Map<String, String>> addOrRemoveSavedRoom({
    String roomId,
    String userId,
    Duration timeout = const Duration(seconds: 10),
  }) {
    if (roomId == null) {
      return Future.error("Room id must be not null");
    }
    if (userId == null) {
      return Future.error("User id must be not null");
    }

    final TransactionHandler transactionHandler = (transaction) async {
      final roomRef = _firestore.document('motelrooms/$roomId');
      final documentSnapshot = await transaction.get(roomRef);
      final userIdsSaved = documentSnapshot['user_ids_saved'] as Map;

      if (userIdsSaved.containsKey(userId)) {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved.$userId': FieldValue.delete(),
          },
        );

        return <String, String>{
          'id': documentSnapshot.documentID,
          'status': 'removed',
        };
      } else {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved.$userId': FieldValue.serverTimestamp(),
          },
        );

        return <String, String>{
          'id': documentSnapshot.documentID,
          'status': 'added',
        };
      }
    };

    return _firestore
        .runTransaction(transactionHandler, timeout: timeout)
        .then((result) => result.cast<String, String>());
  }

  @override
  Stream<List<RoomEntity>> savedList({String uid}) {
    return _firestore
        .collection('motelrooms')
        .orderBy('user_ids_saved.$uid', descending: true)
        .snapshots()
        .map(_toEntities);
  }

  List<RoomEntity> _toEntities(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((documentSnapshot) {
      return RoomEntity.fromDocumentSnapshot(documentSnapshot);
    }).toList();
  }
}
