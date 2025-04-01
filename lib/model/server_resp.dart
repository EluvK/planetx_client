// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_resp.g.dart';

class ServerResp {
  dynamic data;

  ServerResp({required this.data});

  factory ServerResp.version(String version) {
    return ServerResp(data: RespVersion(version));
  }

  Map<String, dynamic> toJson() {
    if (data is RespVersion) {
      (data as RespVersion).toJson();
    }
    if (data is RespRejoinRoom) {
      return (data as RespRejoinRoom).toJson();
    }
    if (data is RespRoomError) {
      return (data as RespRoomError).toJson();
    }
    if (data is RespOpError) {
      return (data as RespOpError).toJson();
    }
    throw Exception("Unknown data type: ${data.runtimeType}");
  }

  factory ServerResp.fromJson(Map<String, dynamic> json) {
    if (json['version'] != null) {
      return ServerResp(data: _$RespVersionFromJson(json));
    }
    if (json['rejoin_room'] != null) {
      return ServerResp(data: _$RespRejoinRoomFromJson(json));
    }
    if (json['room_errors'] != null) {
      return ServerResp(data: _$RespRoomErrorFromJson(json));
    }
    if (json['op_errors'] != null) {
      return ServerResp(data: _$RespOpErrorFromJson(json));
    }
    throw Exception("Unknown data type: ${json.runtimeType}");
  }

  get title {
    if (data is RespVersion) {
      return "server_resp_title_version".tr;
    }
    if (data is RespRejoinRoom) {
      return "server_resp_title_rejoin_room".tr;
    }
    if (data is RespRoomError) {
      return "server_resp_title_room_errors".tr;
    }
    if (data is RespOpError) {
      return "server_resp_title_op_errors".tr;
    }
    return "server_resp_title_unknown".tr;
  }

  get content {
    if (data is RespVersion) {
      return (data as RespVersion).version;
    }
    if (data is RespRejoinRoom) {
      return (data as RespRejoinRoom).roomId;
    }
    if (data is RespRoomError) {
      return (data as RespRoomError).roomErrors.fmt;
    }
    if (data is RespOpError) {
      return (data as RespOpError).opErrors.fmt;
    }
    return "unknown".tr;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RespVersion {
  String version;
  RespVersion(this.version);

  Map<String, dynamic> toJson() => _$RespVersionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RespRejoinRoom {
  String roomId;
  RespRejoinRoom(this.roomId);

  Map<String, dynamic> toJson() => _$RespRejoinRoomToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RespRoomError {
  RoomErrors roomErrors;
  RespRoomError(this.roomErrors);

  Map<String, dynamic> toJson() => _$RespRoomErrorToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RespOpError {
  OpErrors opErrors;
  RespOpError(this.opErrors);

  Map<String, dynamic> toJson() => _$RespOpErrorToJson(this);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum RoomErrors {
  RoomNotFound,
  RoomStarted,
  RoomFull,
  UserNotFoundInRoom,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum OpErrors {
  UserNotFoundInRoom,
  GameNotFound,

  NotUsersTurn,
  InvalidMoveInStage,
  InvalidIndex,
  InvalidClue,
  InvalidSectorType,
  InvalidIndexOfPrime,
  TokenNotEnough,

  SectorAlreadyRevealed,
  TargetTimeExhausted,
  ResearchContiuously,

  EndGameCanNotLocate,
}

extension RoomErrorsEnumMap on RoomErrors {
  String get fmt {
    switch (this) {
      case RoomErrors.RoomNotFound:
        return "room_error_room_not_found".tr;
      case RoomErrors.RoomStarted:
        return "room_error_room_started".tr;
      case RoomErrors.RoomFull:
        return "room_error_room_full".tr;
      case RoomErrors.UserNotFoundInRoom:
        return "room_error_user_not_found_in_room".tr;
    }
  }
}

extension OpErrorsEnumMap on OpErrors {
  String get fmt {
    switch (this) {
      case OpErrors.UserNotFoundInRoom:
        return "op_error_user_not_found_in_room".tr;
      case OpErrors.GameNotFound:
        return "op_error_game_not_found".tr;
      case OpErrors.NotUsersTurn:
        return "op_error_not_users_turn".tr;
      case OpErrors.InvalidMoveInStage:
        return "op_error_invalid_move_in_stage".tr;
      case OpErrors.InvalidIndex:
        return "op_error_invalid_index".tr;
      case OpErrors.InvalidClue:
        return "op_error_invalid_clue".tr;
      case OpErrors.InvalidSectorType:
        return "op_error_invalid_sector_type".tr;
      case OpErrors.InvalidIndexOfPrime:
        return "op_error_invalid_index_of_prime".tr;
      case OpErrors.TokenNotEnough:
        return "op_error_token_not_enough".tr;
      case OpErrors.SectorAlreadyRevealed:
        return "op_error_sector_already_revealed".tr;
      case OpErrors.TargetTimeExhausted:
        return "op_error_target_time_exhausted".tr;
      case OpErrors.ResearchContiuously:
        return "op_error_research_continuously".tr;
      case OpErrors.EndGameCanNotLocate:
        return "op_error_end_game_can_not_locate".tr;
    }
  }
}
