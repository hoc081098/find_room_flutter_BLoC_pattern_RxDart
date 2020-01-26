import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:built_collection/built_collection.dart';
import 'package:find_room/data/categories/firestore_categories_repository.dart';
import 'package:find_room/models/category_entity.dart';

class FirestoreCategoriesRepositoryImpl
    implements FirestoreCategoriesRepository {
  final Firestore _firestore;

  const FirestoreCategoriesRepositoryImpl(this._firestore);

  @override
  Stream<BuiltList<CategoryEntity>> getAllCategories() {
    return _firestore
        .collection('categories')
        .orderBy('name', descending: false)
        .snapshots()
        .map(
          (event) => event.documents
              .map((doc) => CategoryEntity.fromDocumentSnapshot(doc))
              .toBuiltList(),
        );
  }
}
