// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WardEntity _$WardEntityFromJson(Map<String, dynamic> json) {
  return WardEntity(
    name: json['name'] as String,
    documentID: json['documentID'] as String,
  );
}

Map<String, dynamic> _$WardEntityToJson(WardEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'documentID': instance.documentID,
    };
