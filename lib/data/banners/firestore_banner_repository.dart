import 'package:find_room/models/banner_entity.dart';

abstract class FirestoreBannerRepository {
  Future<List<BannerEntity>> banners({int limit});
}
