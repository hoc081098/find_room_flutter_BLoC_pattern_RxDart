import 'package:find_room/models/province_entity.dart';

abstract class ProvinceDistrictWardRepository {
  Future<List<ProvinceEntity>> getAllProvinces();
}
