import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_entity.g.dart';

@immutable
@JsonSerializable()
class UserEntity implements FirebaseModel {
  final String documentID;

  final String email;

  final String phone;

  @JsonKey(name: 'full_name')
  final String fullName;

  final String address;

  final String avatar;

  @JsonKey(name: 'is_active')
  final bool isActive;

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

  const UserEntity({
    this.documentID,
    this.email,
    this.phone,
    this.fullName,
    this.address,
    this.avatar,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String get id => this.documentID;

  factory UserEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$UserEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  @override
  String toString() => 'UserEntity{documentID: $documentID, email: $email,'
      ' phone: $phone, fullName: $fullName, address: $address, avatar: $avatar,'
      ' isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          documentID == other.documentID &&
          email == other.email &&
          phone == other.phone &&
          fullName == other.fullName &&
          address == other.address &&
          avatar == other.avatar &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      documentID.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      fullName.hashCode ^
      address.hashCode ^
      avatar.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
