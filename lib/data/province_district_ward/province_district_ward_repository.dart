import 'package:find_room/models/district_entity.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/ward_entity.dart';
import 'package:built_collection/built_collection.dart';

abstract class ProvinceDistrictWardRepository {
  Stream<BuiltList<ProvinceEntity>> getAllProvinces();

  Stream<BuiltList<DistrictEntity>> getAllDistrictByProvince(
    ProvinceEntity province,
  );

  Stream<BuiltList<WardEntity>> getAllWardByProvinceAndDistrict(
    ProvinceEntity province,
    DistrictEntity district,
  );
}
