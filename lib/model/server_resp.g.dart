// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespVersion _$RespVersionFromJson(Map<String, dynamic> json) => RespVersion(
      json['version'] as String,
    );

Map<String, dynamic> _$RespVersionToJson(RespVersion instance) => <String, dynamic>{
      'version': instance.version,
    };

RespRejoinRoom _$RespRejoinRoomFromJson(Map<String, dynamic> json) => RespRejoinRoom(
      json['rejoin_room'] as String,
    );

Map<String, dynamic> _$RespRejoinRoomToJson(RespRejoinRoom instance) => <String, dynamic>{
      'rejoin_room': instance.rejoinRoom,
    };

RespRoomError _$RespRoomErrorFromJson(Map<String, dynamic> json) => RespRoomError(
      $enumDecode(_$RoomErrorsEnumMap, json['room_errors']),
    );

Map<String, dynamic> _$RespRoomErrorToJson(RespRoomError instance) => <String, dynamic>{
      'room_errors': _$RoomErrorsEnumMap[instance.roomErrors]!,
    };

const _$RoomErrorsEnumMap = {
  RoomErrors.RoomNotFound: 'room_not_found',
  RoomErrors.RoomStarted: 'room_started',
  RoomErrors.RoomFull: 'room_full',
  RoomErrors.UserNotFoundInRoom: 'user_not_found_in_room',
};

RespOpError _$RespOpErrorFromJson(Map<String, dynamic> json) => RespOpError(
      $enumDecode(_$OpErrorsEnumMap, json['op_errors']),
    );

Map<String, dynamic> _$RespOpErrorToJson(RespOpError instance) => <String, dynamic>{
      'op_errors': _$OpErrorsEnumMap[instance.opErrors]!,
    };

const _$OpErrorsEnumMap = {
  OpErrors.UserNotFoundInRoom: 'user_not_found_in_room',
  OpErrors.GameNotFound: 'game_not_found',
  OpErrors.NotUsersTurn: 'not_users_turn',
  OpErrors.InvalidMoveInStage: 'invalid_move_in_stage',
  OpErrors.InvalidIndex: 'invalid_index',
  OpErrors.InvalidClue: 'invalid_clue',
  OpErrors.InvalidSectorType: 'invalid_sector_type',
  OpErrors.InvalidIndexOfPrime: 'invalid_index_of_prime',
  OpErrors.TokenNotEnough: 'token_not_enough',
  OpErrors.SectorAlreadyRevealed: 'sector_already_revealed',
  OpErrors.TargetTimeExhausted: 'target_time_exhausted',
  OpErrors.ResearchContiuously: 'research_contiuously',
  OpErrors.EndGameCanNotLocate: 'end_game_can_not_locate',
};
