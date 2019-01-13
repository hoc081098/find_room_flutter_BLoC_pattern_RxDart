import 'package:find_room/models/banner_entity.dart';
import 'package:meta/meta.dart';

abstract class FirestoreBannerRepository {
  Future<List<BannerEntity>> banners({int limit});
}
