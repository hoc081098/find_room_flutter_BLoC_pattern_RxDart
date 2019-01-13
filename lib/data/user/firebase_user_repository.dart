import 'package:find_room/models/user_entity.dart';

abstract class FirebaseUserRepository {
  Stream<UserEntity> user();
}
