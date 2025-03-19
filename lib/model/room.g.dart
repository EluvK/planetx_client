// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomResp _$RoomRespFromJson(Map<String, dynamic> json) => RoomResp(
      json['room_id'] as String,
      (json['users'] as List<dynamic>).map((e) => RoomUser.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$RoomRespToJson(RoomResp instance) => <String, dynamic>{
      'room_id': instance.roomId,
      'users': instance.users,
    };

RoomUser _$RoomUserFromJson(Map<String, dynamic> json) => RoomUser(
      json['id'] as String,
      json['name'] as String,
      json['ready'] as bool,
    );

Map<String, dynamic> _$RoomUserToJson(RoomUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ready': instance.ready,
    };
