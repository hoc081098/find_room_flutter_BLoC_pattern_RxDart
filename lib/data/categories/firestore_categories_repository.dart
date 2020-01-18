import 'package:built_collection/built_collection.dart';
import 'package:find_room/models/category_entity.dart';

abstract class FirestoreCategoriesRepository {
  Stream<BuiltList<CategoryEntity>> getAllCategories();
}
