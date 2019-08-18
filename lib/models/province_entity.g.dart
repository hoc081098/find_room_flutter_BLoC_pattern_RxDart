// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvinceEntity _$ProvinceEntityFromJson(Map<String, dynamic> json) {
  return ProvinceEntity(
    name: json['name'] as String,
    documentID: json['documentID'] as String,
  );
}

Map<String, dynamic> _$ProvinceEntityToJson(ProvinceEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'documentID': instance.documentID,
    };
