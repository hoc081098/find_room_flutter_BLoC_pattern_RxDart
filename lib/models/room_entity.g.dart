// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomEntity _$RoomEntityFromJson(Map<String, dynamic> json) {
  return RoomEntity(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      countView: json['count_view'] as int,
      size: (json['size'] as num)?.toDouble(),
      address: json['address'] as String,
      addressGeoPoint: json['address_geopoint'] == null
          ? null
          : geoPointFromJson(json['address_geopoint'] as GeoPoint),
      images: (json['images'] as List)?.map((e) => e as String)?.toList(),
      phone: json['phone'] as String,
      isActive: json['is_active'] as bool,
      approve: json['approve'] as bool,
      utilities: json['utilities'] as Map<String, dynamic>,
      user: json['user'] == null
          ? null
          : documentReferenceFromJson(json['user'] as DocumentReference),
      category: json['category'] == null
          ? null
          : documentReferenceFromJson(json['category'] as DocumentReference),
      province: json['province'] == null
          ? null
          : documentReferenceFromJson(json['province'] as DocumentReference),
      ward: json['ward'] == null
          ? null
          : documentReferenceFromJson(json['ward'] as DocumentReference),
      district: json['district'] == null
          ? null
          : documentReferenceFromJson(json['district'] as DocumentReference),
      districtName: json['district_name'] as String,
      createdAt: json['created_at'] == null
          ? null
          : timestampFromJson(json['created_at'] as Timestamp),
      updatedAt: json['updated_at'] == null
          ? null
          : timestampFromJson(json['updated_at'] as Timestamp),
      userIdsSaved:
          (json['user_ids_saved'] as List)?.map((e) => e as String)?.toList() ??
              [],
      documentID: json['documentID'] as String);
}

Map<String, dynamic> _$RoomEntityToJson(RoomEntity instance) =>
    <String, dynamic>{
      'documentID': instance.documentID,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'count_view': instance.countView,
      'size': instance.size,
      'address': instance.address,
      'address_geopoint': instance.addressGeoPoint == null
          ? null
          : geoPointToJson(instance.addressGeoPoint),
      'images': instance.images,
      'phone': instance.phone,
      'is_active': instance.isActive,
      'approve': instance.approve,
      'utilities': instance.utilities,
      'user':
          instance.user == null ? null : documentReferenceToJson(instance.user),
      'category': instance.category == null
          ? null
          : documentReferenceToJson(instance.category),
      'province': instance.province == null
          ? null
          : documentReferenceToJson(instance.province),
      'ward':
          instance.ward == null ? null : documentReferenceToJson(instance.ward),
      'district': instance.district == null
          ? null
          : documentReferenceToJson(instance.district),
      'district_name': instance.districtName,
      'created_at': instance.createdAt == null
          ? null
          : timestampToJson(instance.createdAt),
      'updated_at': instance.updatedAt == null
          ? null
          : timestampToJson(instance.updatedAt),
      'user_ids_saved': instance.userIdsSaved
    };
