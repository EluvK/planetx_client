import 'package:json_annotation/json_annotation.dart';

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
  final String id;
  final int seed;
  final MapType mapType;
  RoomEditOperation(this.id, this.seed, this.mapType);

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
class RoomResult {
  final String roomId;
  final List<RoomUser> users;

  RoomResult(this.roomId, this.users);

  factory RoomResult.fromJson(Map<String, dynamic> json) => _$RoomResultFromJson(json);
  Map<String, dynamic> toJson() => _$RoomResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RoomUser {
  final String id;
  final String name;
  final bool ready;

  RoomUser(this.id, this.name, this.ready);

  factory RoomUser.fromJson(Map<String, dynamic> json) => _$RoomUserFromJson(json);
  Map<String, dynamic> toJson() => _$RoomUserToJson(this);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum MapType {
  standard,
  expert,
}
