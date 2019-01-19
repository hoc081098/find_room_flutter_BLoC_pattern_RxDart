import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'province_entity.g.dart';

@JsonSerializable()
@immutable
class ProvinceEntity implements FirebaseModel {
  final String name;
  final String documentID;

  const ProvinceEntity({
    this.name,
    this.documentID,
  });

  factory ProvinceEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$ProvinceEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$ProvinceEntityToJson(this);

  @override
  String get id => documentID;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProvinceEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          documentID == other.documentID;

  @override
  int get hashCode => name.hashCode ^ documentID.hashCode;

  @override
  String toString() => 'ProvinceEntity{name: $name, documentID: $documentID}';
}
