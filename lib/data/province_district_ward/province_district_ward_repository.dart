import 'package:find_room/models/district_entity.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/ward_entity.dart';

abstract class ProvinceDistrictWardRepository {
  Future<List<ProvinceEntity>> getAllProvinces();

  Future<List<DistrictEntity>> getAllDistrictByProvince(
      ProvinceEntity province);

  Future<List<WardEntity>> getAllWardByDistrict(DistrictEntity district);
}
