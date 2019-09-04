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
    addressGeoPoint: geoPointFromJson(json['address_geopoint'] as GeoPoint),
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
    phone: json['phone'] as String,
    available: json['available'] as bool,
    approve: json['approve'] as bool,
    utilities: (json['utilities'] as List)?.map((e) => e as String)?.toList(),
    user: documentReferenceFromJson(json['user'] as DocumentReference),
    category: documentReferenceFromJson(json['category'] as DocumentReference),
    categoryName: json['category_name'] as String,
    province: documentReferenceFromJson(json['province'] as DocumentReference),
    ward: documentReferenceFromJson(json['ward'] as DocumentReference),
    district: documentReferenceFromJson(json['district'] as DocumentReference),
    districtName: json['district_name'] as String,
    createdAt: timestampFromJson(json['created_at'] as Timestamp),
    updatedAt: timestampFromJson(json['updated_at'] as Timestamp),
    userIdsSaved: mapStringTimestampFromJson(json['user_ids_saved'] as Map),
    documentID: json['documentID'] as String,
  );
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
      'address_geopoint': geoPointToJson(instance.addressGeoPoint),
      'images': instance.images,
      'phone': instance.phone,
      'available': instance.available,
      'approve': instance.approve,
      'utilities': instance.utilities,
      'user': documentReferenceToJson(instance.user),
      'category': documentReferenceToJson(instance.category),
      'category_name': instance.categoryName,
      'province': documentReferenceToJson(instance.province),
      'ward': documentReferenceToJson(instance.ward),
      'district': documentReferenceToJson(instance.district),
      'district_name': instance.districtName,
      'created_at': timestampToJson(instance.createdAt),
      'updated_at': timestampToJson(instance.updatedAt),
      'user_ids_saved': mapStringTimestampToJson(instance.userIdsSaved),
    };
