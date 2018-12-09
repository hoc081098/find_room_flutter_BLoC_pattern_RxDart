import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'banner_entity.g.dart';

@JsonSerializable()
@immutable
class BannerEntity implements FirebaseModel {
  final String image;
  final String description;
  final String documentID;

  BannerEntity({
    this.image,
    this.description,
    this.documentID,
  });

  factory BannerEntity.fromDocument(DocumentSnapshot doc) => _$BannerEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$BannerEntityToJson(this);

  @override
  String get id => documentID;
}
