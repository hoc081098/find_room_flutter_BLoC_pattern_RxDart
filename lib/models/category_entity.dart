import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'category_entity.g.dart';

@JsonSerializable()
@immutable
class CategoryEntity implements FirebaseModel {
  final String documentID;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(
    name: 'created_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
    nullable: true,
  )
  final Timestamp createdAt;

  const CategoryEntity(
    this.documentID,
    this.name,
    this.createdAt,
  );

  factory CategoryEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$CategoryEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$CategoryEntityToJson(this);

  @override
  String get id => documentID;

  @override
  String toString() =>
      'CategoryEntity{documentID: $documentID, name: $name, createdAt: $createdAt}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          documentID == other.documentID &&
          name == other.name &&
          createdAt == other.createdAt;

  @override
  int get hashCode => documentID.hashCode ^ name.hashCode ^ createdAt.hashCode;
}
