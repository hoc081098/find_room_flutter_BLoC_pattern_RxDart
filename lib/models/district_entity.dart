import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'district_entity.g.dart';

@JsonSerializable()
@immutable
class DistrictEntity implements FirebaseModel {
  final String name;
  final String documentID;

  const DistrictEntity({
    this.name,
    this.documentID,
  });

  factory DistrictEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$DistrictEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$DistrictEntityToJson(this);

  @override
  String get id => documentID;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          documentID == other.documentID;

  @override
  int get hashCode => name.hashCode ^ documentID.hashCode;

  @override
  String toString() => 'DistrictEntity{name: $name, documentID: $documentID}';
}
