import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart' show debugPrint;

part 'room_entity.g.dart';

GeoPoint geoPointFromJson(GeoPoint geoPoint) => geoPoint;
GeoPoint geoPointToJson(GeoPoint geoPoint) => geoPoint;

DocumentReference documentReferenceFromJson(DocumentReference ref) => ref;
DocumentReference documentReferenceToJson(DocumentReference ref) => ref;

Timestamp timestampFromJson(Timestamp timestamp) => timestamp;
Timestamp timestampToJson(Timestamp timestamp) => timestamp;

Map<String, dynamic> withId(DocumentSnapshot doc) => CombinedMapView([
      doc.data,
      <String, dynamic>{'documentID': doc.documentID}
    ]);

@immutable
@JsonSerializable()
class RoomEntity implements FirebaseModel {
  final String documentID;
  final String title;
  final String description;
  final int price;
  @JsonKey(name: 'count_view')
  final int countView;
  final double size;
  final String address;
  @JsonKey(
    name: 'address_geopoint',
    fromJson: geoPointFromJson,
    toJson: geoPointToJson,
  )
  final GeoPoint addressGeoPoint;
  final List<String> images;
  final String phone;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final bool approve;
  final Map<String, Object> utilities;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference user;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference category;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference province;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference ward;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference district;
  @JsonKey(name: 'district_name')
  final String districtName;
  @JsonKey(
    name: 'created_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
  )
  final Timestamp createdAt;
  @JsonKey(
    name: 'updated_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
  )
  final Timestamp updatedAt;
  @JsonKey(name: 'user_ids_saved')
  final List<String> userIdsSaved;

  RoomEntity({
    this.title,
    this.description,
    this.price,
    this.countView,
    this.size,
    this.address,
    this.addressGeoPoint,
    this.images,
    this.phone,
    this.isActive,
    this.approve,
    this.utilities,
    this.user,
    this.category,
    this.province,
    this.ward,
    this.district,
    this.districtName,
    this.createdAt,
    this.updatedAt,
    this.userIdsSaved,
    this.documentID,
  });

  factory RoomEntity.fromDocument(DocumentSnapshot doc) {
    debugPrint('##DEBUG ' + doc.data['utilities'].runtimeType.toString());
    doc.data['utilities'] = (doc.data['utilities'] as Map).cast<String, dynamic>();
    return _$RoomEntityFromJson(withId(doc));
  }

  Map<String, dynamic> toJson() => _$RoomEntityToJson(this);

  @override
  String get id => this.documentID;
}
