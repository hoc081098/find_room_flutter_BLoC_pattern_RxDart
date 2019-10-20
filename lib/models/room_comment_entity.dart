import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'room_comment_entity.g.dart';

@JsonSerializable()
@immutable
class RoomCommentEntity implements FirebaseModel {
  final String documentID;

  final String content;

  @JsonKey(name: 'room_id')
  final String roomId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'user_avatar')
  final String userAvatar;

  @JsonKey(name: 'user_name')
  final String userName;

  @JsonKey(
    name: 'created_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
    nullable: true,
  )
  final Timestamp createdAt;

  @JsonKey(
    name: 'updated_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
    nullable: true,
  )
  final Timestamp updatedAt;

  const RoomCommentEntity(
    this.documentID,
    this.content,
    this.roomId,
    this.userId,
    this.userAvatar,
    this.userName,
    this.createdAt,
    this.updatedAt,
  );

  factory RoomCommentEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$RoomCommentEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$RoomCommentEntityToJson(this);

  @override
  String get id => documentID;
}
