// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomEditOperation _$RoomEditOperationFromJson(Map<String, dynamic> json) => RoomEditOperation(
      json['room_id'] as String,
      (json['map_seed'] as num).toInt(),
      $enumDecode(_$MapTypeEnumMap, json['map_type']),
    );

Map<String, dynamic> _$RoomEditOperationToJson(RoomEditOperation instance) => <String, dynamic>{
      'room_id': instance.roomId,
      'map_seed': instance.mapSeed,
      'map_type': _$MapTypeEnumMap[instance.mapType]!,
    };

const _$MapTypeEnumMap = {
  MapType.standard: 'standard',
  MapType.expert: 'expert',
};

GameStateResp _$GameStateRespFromJson(Map<String, dynamic> json) => GameStateResp(
      json['id'] as String,
      GameState.fromJson(json['status']),
      $enumDecode(_$GameStageEnumMap, json['game_stage']),
      json['hint'] as String?,
      (json['users'] as List<dynamic>).map((e) => UserState.fromJson(e as Map<String, dynamic>)).toList(),
      (json['start_index'] as num).toInt(),
      (json['end_index'] as num).toInt(),
      (json['map_seed'] as num).toInt(),
      $enumDecode(_$MapTypeEnumMap, json['map_type']),
    );

Map<String, dynamic> _$GameStateRespToJson(GameStateResp instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'game_stage': _$GameStageEnumMap[instance.gameStage]!,
      'hint': instance.hint,
      'users': instance.users,
      'start_index': instance.startIndex,
      'end_index': instance.endIndex,
      'map_seed': instance.mapSeed,
      'map_type': _$MapTypeEnumMap[instance.mapType]!,
    };

const _$GameStageEnumMap = {
  GameStage.userMove: 'user_move',
  GameStage.meetingProposal: 'meeting_proposal',
  GameStage.meetingPublish: 'meeting_publish',
  GameStage.gameEnd: 'game_end',
};

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
      json['id'] as String,
      json['name'] as String,
      json['ready'] as bool,
      UserLocationSequence.fromJson(json['location'] as Map<String, dynamic>),
      json['should_move'] as bool,
      (json['moves'] as List<dynamic>).map((e) => Operation.fromJson(e as Map<String, dynamic>)).toList(),
      (json['moves_result'] as List<dynamic>).map((e) => OperationResult.fromJson(e as Map<String, dynamic>)).toList(),
      (json['used_token'] as List<dynamic>).map((e) => SecretToken.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ready': instance.ready,
      'location': instance.location,
      'should_move': instance.shouldMove,
      'moves': instance.moves,
      'moves_result': instance.movesResult,
      'used_token': instance.usedToken,
    };

SecretToken _$SecretTokenFromJson(Map<String, dynamic> json) => SecretToken(
      json['user_id'] as String,
      (json['user_index'] as num).toInt(),
      (json['sector_index'] as num).toInt(),
      (json['meeting_index'] as num).toInt(),
      $enumDecodeNullable(_$SectorTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$SecretTokenToJson(SecretToken instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_index': instance.userIndex,
      'sector_index': instance.sectorIndex,
      'meeting_index': instance.meetingIndex,
      'type': _$SectorTypeEnumMap[instance.type],
    };

const _$SectorTypeEnumMap = {
  SectorType.Comet: 'comet',
  SectorType.Asteroid: 'asteroid',
  SectorType.DwarfPlanet: 'dwarf_planet',
  SectorType.Nebula: 'nebula',
  SectorType.Space: 'space',
  SectorType.X: 'x',
};

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      json['placed'] as bool,
      SecretToken.fromJson(json['secret'] as Map<String, dynamic>),
      $enumDecode(_$SectorTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'placed': instance.placed,
      'secret': instance.secret,
      'type': _$SectorTypeEnumMap[instance.type]!,
    };

UserLocationSequence _$UserLocationSequenceFromJson(Map<String, dynamic> json) => UserLocationSequence(
      (json['index'] as num).toInt(),
      (json['child_index'] as num).toInt(),
    );

Map<String, dynamic> _$UserLocationSequenceToJson(UserLocationSequence instance) => <String, dynamic>{
      'index': instance.index,
      'child_index': instance.childIndex,
    };
