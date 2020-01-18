// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryEntity _$CategoryEntityFromJson(Map<String, dynamic> json) {
  return CategoryEntity(
    json['documentID'] as String,
    json['name'] as String,
    timestampFromJson(json['created_at'] as Timestamp),
  );
}

Map<String, dynamic> _$CategoryEntityToJson(CategoryEntity instance) =>
    <String, dynamic>{
      'documentID': instance.documentID,
      'name': instance.name,
      'created_at': timestampToJson(instance.createdAt),
    };
