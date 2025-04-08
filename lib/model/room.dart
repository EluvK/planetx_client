import 'package:json_annotation/json_annotation.dart';
import 'package:planetx_client/model/op.dart';

part 'room.g.dart';

class RoomUserOperation {
  final dynamic value;

  RoomUserOperation(this.value);

  factory RoomUserOperation.create() => RoomUserOperation(RoomCreateOperation());
  factory RoomUserOperation.edit(String id, int seed, MapType mapType) =>
      RoomUserOperation(RoomEditOperation(id, seed, mapType));
  factory RoomUserOperation.join(String id) => RoomUserOperation(RoomJoinOperation(id));
  factory RoomUserOperation.leave(String id) => RoomUserOperation(RoomLeaveOperation(id));
  factory RoomUserOperation.prepare(String id) => RoomUserOperation(RoomPrepareOperation(id));
  factory RoomUserOperation.unprepare(String id) => RoomUserOperation(RoomUnprepareOperation(id));

  factory RoomUserOperation.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey('join')) {
        return RoomUserOperation(RoomJoinOperation(json['join']));
      } else if (json.containsKey('edit')) {
        return RoomUserOperation(RoomEditOperation.fromJson(json['edit']));
      } else if (json.containsKey('leave')) {
        return RoomUserOperation(RoomLeaveOperation(json['leave']));
      } else if (json.containsKey('prepare')) {
        return RoomUserOperation(RoomPrepareOperation(json['prepare']));
      } else if (json.containsKey('unprepare')) {
        return RoomUserOperation(RoomUnprepareOperation(json['unprepare']));
      } else {
        throw Exception('unknown RoomUserOperation type');
      }
    } else if (json == String) {
      if (json == 'create') {
        return RoomUserOperation.create();
      } else {
        throw Exception('unknown RoomUserOperation type');
      }
    }
    throw Exception('unknown RoomUserOperation type');
  }

  dynamic toJson() {
    switch (value) {
      case RoomCreateOperation _:
        return 'create';
      case RoomEditOperation edit:
        return {'edit': edit.toJson()};
      case RoomJoinOperation _:
        return {'join': (value as RoomJoinOperation).value};
      case RoomLeaveOperation _:
        return {'leave': (value as RoomLeaveOperation).value};
      case RoomPrepareOperation _:
        return {'prepare': (value as RoomPrepareOperation).value};
      case RoomUnprepareOperation _:
        return {'unprepare': (value as RoomUnprepareOperation).value};
      default:
        throw Exception('unknown RoomUserOperation type');
    }
  }
}

class RoomCreateOperation {
  RoomCreateOperation();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RoomEditOperation {
  final String roomId;
  final int mapSeed;
  final MapType mapType;
  RoomEditOperation(this.roomId, this.mapSeed, this.mapType);

  factory RoomEditOperation.fromJson(Map<String, dynamic> json) => _$RoomEditOperationFromJson(json);
  Map<String, dynamic> toJson() => _$RoomEditOperationToJson(this);
}

class RoomJoinOperation {
  final String value;
  RoomJoinOperation(this.value);
}

class RoomLeaveOperation {
  final String value;
  RoomLeaveOperation(this.value);
}

class RoomPrepareOperation {
  final String value;
  RoomPrepareOperation(this.value);
}

class RoomUnprepareOperation {
  final String value;
  RoomUnprepareOperation(this.value);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameStateResp {
  final String id;
  final GameState status;
  final GameStage gameStage;
  final String? hint;
  final List<UserState> users;
  final int startIndex;
  final int endIndex;
  final int mapSeed;
  final MapType mapType;
  final List<UserResultSummary>? gameResult;

  GameStateResp(
    this.id,
    this.status,
    this.gameStage,
    this.hint,
    this.users,
    this.startIndex,
    this.endIndex,
    this.mapSeed,
    this.mapType,
    this.gameResult,
  );

  factory GameStateResp.placeholder() => GameStateResp(
        '',
        GameState.notStarted(),
        GameStage.userMove,
        '',
        [],
        0,
        0,
        0,
        MapType.standard,
        null,
      );

  factory GameStateResp.fromJson(Map<String, dynamic> json) => _$GameStateRespFromJson(json);
  Map<String, dynamic> toJson() => _$GameStateRespToJson(this);
}

class GameState {
  final dynamic value;
  GameState(this.value);

  factory GameState.notStarted() => GameState('not_started');
  factory GameState.starting() => GameState('starting');
  factory GameState.wait(List<String> value) => GameState({'wait': value});
  factory GameState.autoMove() => GameState('auto_move');
  factory GameState.end() => GameState('end');

  factory GameState.fromJson(dynamic json) {
    if (json is String) {
      return GameState(json);
    } else if (json is Map<String, dynamic>) {
      if (json.containsKey('wait')) {
        if (json['wait'] is List<dynamic>) {
          List<String> r = (json['wait'] as List<dynamic>).map((e) => e as String).toList();
          return GameState.wait(r);
        } else {
          throw Exception('unknown GameState type');
        }
      } else {
        throw Exception('unknown GameState type');
      }
    } else {
      throw Exception('unknown GameState type');
    }
  }

  Map<String, dynamic> toJson() {
    if (value is String) {
      return {value: true};
    } else if (value is Map<String, dynamic>) {
      return value;
    } else {
      throw Exception('unknown GameState type');
    }
  }

  bool get isNotStarted => value == 'not_started';
  bool get isEnd => value == 'end';
}

@JsonEnum(fieldRename: FieldRename.snake)
enum GameStage {
  userMove,
  meetingProposal,
  meetingPublish,
  meetingCheck,
  lastMove,
  gameEnd,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserState {
  final String id;
  final String name;
  final bool ready;
  final UserLocationSequence location;
  final bool lastMove;
  final bool canLocate;
  final List<Operation> moves;
  // final List<OperationResult> movesResult;
  final List<SecretToken> usedToken;

  UserState(
    this.id,
    this.name,
    this.ready,
    this.location,
    this.lastMove,
    this.canLocate,
    this.moves,
    // this.movesResult,
    this.usedToken,
  );

  factory UserState.fromJson(Map<String, dynamic> json) => _$UserStateFromJson(json);
  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserResultSummary {
  final String id;
  final String name;
  final int sum;
  final int first;
  final int comet;
  final int asteroid;
  final int dwarfPlanet;
  final int nebula;
  final int x;
  final int step;
  
  UserResultSummary(
    this.id,
    this.name,
    this.sum,
    this.first,
    this.comet,
    this.asteroid,
    this.dwarfPlanet,
    this.nebula,
    this.x,
    this.step,
  );

  factory UserResultSummary.fromJson(Map<String, dynamic> json) => _$UserResultSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$UserResultSummaryToJson(this);

}

@JsonEnum(fieldRename: FieldRename.snake)
enum MapType {
  standard,
  expert,
}

extension MapTypeExt on MapType {
  int get sectorCount {
    switch (this) {
      case MapType.standard:
        return 12;
      case MapType.expert:
        return 18;
    }
  }

  List<int> get meetingPoints {
    switch (this) {
      case MapType.standard:
        return [0, 3, 6, 9];
      case MapType.expert:
        return [0, 3, 6, 9, 12, 15];
    }
  }

  List<int> get xCluePoints {
    switch (this) {
      case MapType.standard:
        return [10];
      case MapType.expert:
        return [7, 16];
    }
  }

  int get meteringSectorCount {
    switch (this) {
      case MapType.standard:
        return 1;
      case MapType.expert:
        return 2;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SecretToken {
  // used alone as placed token

  final String userId;
  final int userIndex; // game sequence 1, 2, 3, 4
  final int sectorIndex;
  final int meetingIndex; // 0 for known, 1,2, 3 is just published, // -1 for wrong guess
  final SectorType? type; // if meetingIndex == 0/-1 ,then this is not null.

  SecretToken(this.userId, this.userIndex, this.sectorIndex, this.meetingIndex, this.type);

  factory SecretToken.fromJson(Map<String, dynamic> json) => _$SecretTokenFromJson(json);
  Map<String, dynamic> toJson() => _$SecretTokenToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Token {
  final bool placed;
  final SecretToken secret;
  final SectorType type;

  Token(this.placed, this.secret, this.type);
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserLocationSequence {
  final int index;
  final int childIndex;

  UserLocationSequence(this.index, this.childIndex);

  factory UserLocationSequence.fromJson(Map<String, dynamic> json) => _$UserLocationSequenceFromJson(json);
  Map<String, dynamic> toJson() => _$UserLocationSequenceToJson(this);
}
