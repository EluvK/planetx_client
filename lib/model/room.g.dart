// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomEditOperation _$RoomEditOperationFromJson(Map<String, dynamic> json) => RoomEditOperation(
      json['id'] as String,
      (json['seed'] as num).toInt(),
      $enumDecode(_$MapTypeEnumMap, json['map_type']),
    );

Map<String, dynamic> _$RoomEditOperationToJson(RoomEditOperation instance) => <String, dynamic>{
      'id': instance.id,
      'seed': instance.seed,
      'map_type': _$MapTypeEnumMap[instance.mapType]!,
    };

const _$MapTypeEnumMap = {
  MapType.standard: 'standard',
  MapType.expert: 'expert',
};

RoomResult _$RoomResultFromJson(Map<String, dynamic> json) => RoomResult(
      json['room_id'] as String,
      (json['users'] as List<dynamic>).map((e) => RoomUser.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$RoomResultToJson(RoomResult instance) => <String, dynamic>{
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
