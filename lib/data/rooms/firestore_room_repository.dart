import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

abstract class FirestoreRoomRepository {
  Stream<Tuple2<List<RoomEntity>, DocumentSnapshot>> newestRooms({
    @required Province selectedProvince,
    @required int limit,
    DocumentSnapshot after,
  });

  Stream<Tuple2<List<RoomEntity>, DocumentSnapshot>> mostViewedRooms({
    @required Province selectedProvince,
    @required int limit,
    DocumentSnapshot after,
  });

  Future<Map<String, String>> addOrRemoveSavedRoom({
    @required String roomId,
    @required String userId,
    Duration timeout = const Duration(seconds: 10),
  });

  Stream<List<RoomEntity>> savedList({@required String uid});

  Stream<List<RoomEntity>> postedList({@required String uid});

  Stream<RoomEntity> findBy({@required String roomId});

  Future<void> increaseViewCount(
    String roomId, {
    Duration timeout = const Duration(seconds: 10),
  });

  Future<List<RoomEntity>> getRelatedRoomsBy({@required String roomId});
}
