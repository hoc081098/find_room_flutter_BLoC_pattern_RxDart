// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistrictEntity _$DistrictEntityFromJson(Map<String, dynamic> json) {
  return DistrictEntity(
    name: json['name'] as String,
    documentID: json['documentID'] as String,
  );
}

Map<String, dynamic> _$DistrictEntityToJson(DistrictEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'documentID': instance.documentID,
    };
