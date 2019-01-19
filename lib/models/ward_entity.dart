import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ward_entity.g.dart';

@JsonSerializable()
@immutable
class WardEntity implements FirebaseModel {
  final String name;
  final String documentID;

  const WardEntity({
    this.name,
    this.documentID,
  });

  factory WardEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$WardEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$WardEntityToJson(this);

  @override
  String get id => documentID;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WardEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          documentID == other.documentID;

  @override
  int get hashCode => name.hashCode ^ documentID.hashCode;

  @override
  String toString() => 'WardEntity{name: $name, documentID: $documentID}';
}
