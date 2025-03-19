class RoomUserOperation {
  final dynamic value;

  RoomUserOperation(this.value);

  factory RoomUserOperation.create() => RoomUserOperation(RoomCreateOperation());
  factory RoomUserOperation.join(String name) => RoomUserOperation(RoomJoinOperation(name));
  factory RoomUserOperation.leave(String name) => RoomUserOperation(RoomLeaveOperation(name));
  factory RoomUserOperation.prepare() => RoomUserOperation(RoomPrepareOperation());
  factory RoomUserOperation.unprepare() => RoomUserOperation(RoomUnprepareOperation());

  factory RoomUserOperation.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey('join')) {
        return RoomUserOperation(RoomJoinOperation(json['join']));
      } else if (json.containsKey('leave')) {
        return RoomUserOperation(RoomLeaveOperation(json['leave']));
      } else {
        throw Exception('unknown RoomUserOperation type');
      }
    } else if (json == String) {
      if (json == 'create') {
        return RoomUserOperation.create();
      } else if (json == 'prepare') {
        return RoomUserOperation.prepare();
      } else if (json == 'unprepare') {
        return RoomUserOperation.unprepare();
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
      case RoomJoinOperation _:
        return {'join': (value as RoomJoinOperation).value};
      case RoomLeaveOperation _:
        return {'leave': (value as RoomLeaveOperation).value};
      case RoomPrepareOperation _:
        return 'prepare';
      case RoomUnprepareOperation _:
        return 'unprepare';
      default:
        throw Exception('unknown RoomUserOperation type');
    }
  }
}

class RoomCreateOperation {
  RoomCreateOperation();
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
  RoomPrepareOperation();
}

class RoomUnprepareOperation {
  RoomUnprepareOperation();
}
