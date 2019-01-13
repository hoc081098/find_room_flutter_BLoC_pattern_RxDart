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
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.documents
              .map(
                (documentSnapshot) =>
                    RoomEntity.fromDocumentSnapshot(documentSnapshot),
              )
              .toList(),
        );
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
        .where('approve', isEqualTo: true)
        .where('province', isEqualTo: selectedProvinceRef)
        .where('is_active', isEqualTo: true)
        .orderBy('count_view', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.documents
              .map(
                (documentSnapshot) =>
                    RoomEntity.fromDocumentSnapshot(documentSnapshot),
              )
              .toList(),
        );
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
      final roomEntity = RoomEntity.fromDocumentSnapshot(documentSnapshot);

      if (roomEntity.userIdsSaved.contains(userId)) {
        await transaction.update(
          roomRef,
          <String, dynamic>{
            'user_ids_saved': FieldValue.arrayRemove([userId]),
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
            'user_ids_saved': FieldValue.arrayUnion([userId]),
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
}
