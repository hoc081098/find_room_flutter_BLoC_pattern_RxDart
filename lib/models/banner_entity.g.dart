// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerEntity _$BannerEntityFromJson(Map<String, dynamic> json) {
  return BannerEntity(
    image: json['image'] as String,
    description: json['description'] as String,
    documentID: json['documentID'] as String,
  );
}

Map<String, dynamic> _$BannerEntityToJson(BannerEntity instance) =>
    <String, dynamic>{
      'image': instance.image,
      'description': instance.description,
      'documentID': instance.documentID,
    };
