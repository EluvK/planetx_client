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

GameStateResp _$GameStateRespFromJson(Map<String, dynamic> json) => GameStateResp(
      json['id'] as String,
      $enumDecode(_$GameStateEnumMap, json['status']),
      json['hint'] as String?,
      (json['users'] as List<dynamic>).map((e) => UserState.fromJson(e as Map<String, dynamic>)).toList(),
      (json['start_index'] as num).toInt(),
      (json['end_index'] as num).toInt(),
      (json['map_seed'] as num).toInt(),
      $enumDecode(_$MapTypeEnumMap, json['map_type']),
    );

Map<String, dynamic> _$GameStateRespToJson(GameStateResp instance) => <String, dynamic>{
      'id': instance.id,
      'status': _$GameStateEnumMap[instance.status]!,
      'hint': instance.hint,
      'users': instance.users,
      'start_index': instance.startIndex,
      'end_index': instance.endIndex,
      'map_seed': instance.mapSeed,
      'map_type': _$MapTypeEnumMap[instance.mapType]!,
    };

const _$GameStateEnumMap = {
  GameState.notStarted: 'not_started',
  GameState.starting: 'starting',
  GameState.wait: 'wait',
  GameState.autoMove: 'auto_move',
  GameState.end: 'end',
};

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
      json['id'] as String,
      json['name'] as String,
      json['ready'] as bool,
      UserLocationSequence.fromJson(json['location'] as Map<String, dynamic>),
      json['should_move'] as bool,
      (json['moves'] as List<dynamic>).map((e) => Operation.fromJson(e as Map<String, dynamic>)).toList(),
      (json['moves_result'] as List<dynamic>).map((e) => OperationResult.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ready': instance.ready,
      'location': instance.location,
      'should_move': instance.shouldMove,
      'moves': instance.moves,
      'moves_result': instance.movesResult,
    };

UserLocationSequence _$UserLocationSequenceFromJson(Map<String, dynamic> json) => UserLocationSequence(
      (json['index'] as num).toInt(),
      (json['child_index'] as num).toInt(),
    );

Map<String, dynamic> _$UserLocationSequenceToJson(UserLocationSequence instance) => <String, dynamic>{
      'index': instance.index,
      'child_index': instance.childIndex,
    };
