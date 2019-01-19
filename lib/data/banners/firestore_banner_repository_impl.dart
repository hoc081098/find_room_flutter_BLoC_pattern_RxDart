import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/data/banners/firestore_banner_repository.dart';
import 'package:find_room/models/banner_entity.dart';

class FirestoreBannerRepositoryImpl implements FirestoreBannerRepository {
  final Firestore _firestore;

  const FirestoreBannerRepositoryImpl(this._firestore);

  @override
  Future<List<BannerEntity>> banners({int limit}) async {
    Query query = _firestore
        .collection('banners')
        .orderBy('updated_at', descending: true);
    query = limit != null ? query.limit(limit) : query;

    final querySnapshot = await query.getDocuments();
    return querySnapshot.documents
        .map((documentSnapshot) =>
            BannerEntity.fromDocumentSnapshot(documentSnapshot))
        .toList();
  }
}
