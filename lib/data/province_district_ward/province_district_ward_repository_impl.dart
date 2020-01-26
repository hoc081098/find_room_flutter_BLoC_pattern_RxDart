import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository.dart';
import 'package:find_room/models/district_entity.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/ward_entity.dart';

class ProvinceDistrictWardRepositoryImpl
    implements ProvinceDistrictWardRepository {
  final Firestore _firestore;

  const ProvinceDistrictWardRepositoryImpl(this._firestore);

  @override
  Stream<BuiltList<ProvinceEntity>> getAllProvinces() async* {
    final querySnapshot =
        await _firestore.collection('provinces').orderBy('name').getDocuments();
    yield querySnapshot.documents
        .map((doc) => ProvinceEntity.fromDocumentSnapshot(doc))
        .toBuiltList();
  }

  @override
  Stream<BuiltList<DistrictEntity>> getAllDistrictByProvince(
    ProvinceEntity province,
  ) async* {
    ArgumentError.checkNotNull(province);

    final querySnapshot = await _firestore
        .document('provinces/${province.id}')
        .collection('districts')
        .orderBy('name')
        .getDocuments();
    yield querySnapshot.documents
        .map((doc) => DistrictEntity.fromDocumentSnapshot(doc))
        .toBuiltList();
  }

  @override
  Stream<BuiltList<WardEntity>> getAllWardByProvinceAndDistrict(
    ProvinceEntity province,
    DistrictEntity district,
  ) async* {
    ArgumentError.checkNotNull(province);
    ArgumentError.checkNotNull(district);

    final querySnapshot = await _firestore
        .document('provinces/${province.id}/districts/${district.id}')
        .collection('wards')
        .orderBy('name')
        .getDocuments();
    yield querySnapshot.documents
        .map((doc) => WardEntity.fromDocumentSnapshot(doc))
        .toBuiltList();
  }
}
