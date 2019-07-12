import 'package:find_room/models/province.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:meta/meta.dart';

abstract class FirestoreRoomRepository {
  Stream<List<RoomEntity>> newestRooms({
    @required Province selectedProvince,
    @required int limit,
  });

  Stream<List<RoomEntity>> mostViewedRooms({
    @required Province selectedProvince,
    @required int limit,
  });

  Future<Map<String, String>> addOrRemoveSavedRoom({
    @required String roomId,
    @required String userId,
    Duration timeout: const Duration(seconds: 10),
  });

  Stream<List<RoomEntity>> savedList({@required String uid});

  Stream<List<RoomEntity>> postedList({@required String uid});
}
