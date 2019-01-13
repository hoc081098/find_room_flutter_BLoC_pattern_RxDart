import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/province_district_ward/province_district_ward_repository.dart';
import 'package:find_room/models/province_entity.dart';

class ProvinceDistrictWardRepositoryImpl
    implements ProvinceDistrictWardRepository {
  final Firestore _firestore;

  const ProvinceDistrictWardRepositoryImpl(this._firestore);

  @override
  Future<List<ProvinceEntity>> getAllProvinces() {
    List<ProvinceEntity> Function(QuerySnapshot) mapper = (querySnapshot) {
      return querySnapshot.documents.map((documentSnapshot) {
        return ProvinceEntity.fromDocumentSnapshot(documentSnapshot);
      }).toList();
    };
    return _firestore.collection('provinces').getDocuments().then(mapper);
  }
}
