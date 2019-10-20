// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_comment_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomCommentEntity _$RoomCommentEntityFromJson(Map<String, dynamic> json) {
  return RoomCommentEntity(
    json['documentID'] as String,
    json['content'] as String,
    json['room_id'] as String,
    json['user_id'] as String,
    json['user_avatar'] as String,
    json['user_name'] as String,
    timestampFromJson(json['created_at'] as Timestamp),
    timestampFromJson(json['updated_at'] as Timestamp),
  );
}

Map<String, dynamic> _$RoomCommentEntityToJson(RoomCommentEntity instance) =>
    <String, dynamic>{
      'documentID': instance.documentID,
      'content': instance.content,
      'room_id': instance.roomId,
      'user_id': instance.userId,
      'user_avatar': instance.userAvatar,
      'user_name': instance.userName,
      'created_at': timestampToJson(instance.createdAt),
      'updated_at': timestampToJson(instance.updatedAt),
    };
