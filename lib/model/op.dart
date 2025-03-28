import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'op.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum SectorType {
  Comet, // 彗星
  Asteroid, // 小行星
  DwarfPlanet, // 矮行星
  Nebula, // 气体云
  Space, // 空域
  X;

  factory SectorType.fromStarMapIndex(int index) {
    switch (index) {
      case 0:
        return SectorType.Comet;
      case 1:
        return SectorType.Asteroid;
      case 2:
        return SectorType.DwarfPlanet;
      case 3:
        return SectorType.Nebula;
      case 4:
        return SectorType.Space;
      case 5:
        return SectorType.X;
      default:
        throw Exception('unknown SectorType index');
    }
  }

  factory SectorType.fromString(String str) {
    switch (str) {
      case 'comet':
        return SectorType.Comet;
      case 'asteroid':
        return SectorType.Asteroid;
      case 'dwarf_planet':
        return SectorType.DwarfPlanet;
      case 'nebula':
        return SectorType.Nebula;
      case 'space':
        return SectorType.Space;
      case 'x':
        return SectorType.X;
      default:
        throw Exception('unknown SectorType string');
    }
  }

  @override
  String toString() {
    switch (this) {
      case SectorType.Comet:
        return 'Comet';
      case SectorType.Asteroid:
        return 'Asteroid';
      case SectorType.DwarfPlanet:
        return 'DwarfPlanet';
      case SectorType.Nebula:
        return 'Nebula';
      case SectorType.Space:
        return 'Space';
      case SectorType.X:
        return 'X';
    }
  }
}

extension SectorTypeExtension on SectorType {
  String get iconName {
    switch (this) {
      case SectorType.Comet:
        return 'assets/icons/comet.png';
      case SectorType.Asteroid:
        return 'assets/icons/asteroid.png';
      case SectorType.DwarfPlanet:
        return 'assets/icons/dwarf_planet.png';
      case SectorType.Nebula:
        return 'assets/icons/nebula.png';
      case SectorType.Space:
        return 'assets/icons/bracket.png';
      case SectorType.X:
        return 'assets/icons/x.png';
    }
  }
}

@JsonEnum(fieldRename: FieldRename.snake)
enum MeetingResultStatus {
  Revealed,
  BeforeRevealed1,
  BeforeRevealed2,
  Publish;

  factory MeetingResultStatus.fromIndex(int index) {
    switch (index) {
      case 0:
        return MeetingResultStatus.Revealed;
      case 1:
        return MeetingResultStatus.BeforeRevealed1;
      case 2:
        return MeetingResultStatus.BeforeRevealed2;
      case 3:
        return MeetingResultStatus.Publish;
      default:
        throw Exception('unknown MeetingResultStatus index');
    }
  }

  // meetingIcons defined at star_map.dart anyway.
}

class Operation {
  final dynamic value;

  Operation(this.value);

  factory Operation.survey(SectorType sectorType, int start, int end) {
    return Operation(SurveyOperation(sectorType, start, end));
  }
  factory Operation.target(int index) {
    return Operation(TargetOperation(index));
  }
  factory Operation.research(ClueEnum index) {
    return Operation(ResearchOperation(index));
  }
  factory Operation.locate(int index, SectorType preSectorType, SectorType nextSectorType) {
    return Operation(LocateOperation(index, preSectorType, nextSectorType));
  }
  factory Operation.readyPublish(List<SectorType> sectors) {
    return Operation(ReadyPublishOperation(sectors));
  }
  factory Operation.doPublish(int index, SectorType sectorType) {
    return Operation(DoPublishOperation(index, sectorType));
  }

  factory Operation.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('survey')) {
      return Operation(SurveyOperation.fromJson(json['survey']));
    } else if (json.containsKey('target')) {
      return Operation(TargetOperation.fromJson(json['target']));
    } else if (json.containsKey('research')) {
      return Operation(ResearchOperation.fromJson(json['research']));
    } else if (json.containsKey('locate')) {
      return Operation(LocateOperation.fromJson(json['locate']));
    } else if (json.containsKey('ready_publish')) {
      return Operation(ReadyPublishOperation.fromJson(json['ready_publish']));
    } else if (json.containsKey('do_publish')) {
      return Operation(DoPublishOperation.fromJson(json['do_publish']));
    } else {
      throw Exception('unknown Operation type');
    }
  }

  Map<String, dynamic> toJson() {
    if (value is SurveyOperation) {
      return {'survey': (value as SurveyOperation).toJson()};
    } else if (value is TargetOperation) {
      return {'target': (value as TargetOperation).toJson()};
    } else if (value is ResearchOperation) {
      return {'research': (value as ResearchOperation).toJson()};
    } else if (value is LocateOperation) {
      return {'locate': (value as LocateOperation).toJson()};
    } else if (value is ReadyPublishOperation) {
      return {'ready_publish': (value as ReadyPublishOperation).toJson()};
    } else if (value is DoPublishOperation) {
      return {'do_publish': (value as DoPublishOperation).toJson()};
    } else {
      throw Exception('unknown Operation type');
    }
  }

  String fmt() {
    if (value is SurveyOperation) {
      return 'Survey ${value.start}-${value.end}, ${value.sectorType}';
    } else if (value is TargetOperation) {
      return 'Target ${value.index}';
    } else if (value is ResearchOperation) {
      return 'Research ${value.index}';
    } else if (value is LocateOperation) {
      return 'Locate';
    } else if (value is ReadyPublishOperation) {
      return 'ReadyPublish ${value.sectors}';
    } else if (value is DoPublishOperation) {
      return 'DoPublish ${value.index} ${value.sectorType}';
    } else {
      throw Exception('unknown Operation type');
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SurveyOperation {
  final SectorType sectorType;
  final int start;
  final int end;

  SurveyOperation(this.sectorType, this.start, this.end);

  @override
  bool operator ==(Object other) =>
      other is SurveyOperation && other.sectorType == sectorType && other.start == start && other.end == end;
  @override
  int get hashCode => sectorType.hashCode ^ start.hashCode ^ end.hashCode;

  factory SurveyOperation.fromJson(Map<String, dynamic> json) => _$SurveyOperationFromJson(json);
  Map<String, dynamic> toJson() => _$SurveyOperationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TargetOperation {
  final int index;

  TargetOperation(this.index);

  @override
  bool operator ==(Object other) => other is TargetOperation && other.index == index;
  @override
  int get hashCode => index.hashCode;

  factory TargetOperation.fromJson(Map<String, dynamic> json) => _$TargetOperationFromJson(json);
  Map<String, dynamic> toJson() => _$TargetOperationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ResearchOperation {
  final ClueEnum index;

  ResearchOperation(this.index);

  @override
  bool operator ==(Object other) => other is ResearchOperation && other.index == index;
  @override
  int get hashCode => index.hashCode;

  factory ResearchOperation.fromJson(Map<String, dynamic> json) => _$ResearchOperationFromJson(json);
  Map<String, dynamic> toJson() => _$ResearchOperationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LocateOperation {
  final int index;
  final SectorType preSectorType;
  final SectorType nextSectorType;

  LocateOperation(this.index, this.preSectorType, this.nextSectorType);

  @override
  bool operator ==(Object other) =>
      other is LocateOperation &&
      other.index == index &&
      other.preSectorType == preSectorType &&
      other.nextSectorType == nextSectorType;
  @override
  int get hashCode => index.hashCode ^ preSectorType.hashCode ^ nextSectorType.hashCode;

  factory LocateOperation.fromJson(Map<String, dynamic> json) => _$LocateOperationFromJson(json);
  Map<String, dynamic> toJson() => _$LocateOperationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReadyPublishOperation {
  final List<SectorType> sectors;

  ReadyPublishOperation(this.sectors);

  @override
  bool operator ==(Object other) => other is ReadyPublishOperation && listEquals(sectors, other.sectors);
  @override
  int get hashCode => sectors.hashCode;

  factory ReadyPublishOperation.fromJson(Map<String, dynamic> json) => _$ReadyPublishOperationFromJson(json);
  Map<String, dynamic> toJson() => _$ReadyPublishOperationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DoPublishOperation {
  final int index;
  final SectorType sectorType;

  DoPublishOperation(this.index, this.sectorType);

  @override
  bool operator ==(Object other) =>
      other is DoPublishOperation && other.index == index && other.sectorType == sectorType;
  @override
  int get hashCode => index.hashCode ^ sectorType.hashCode;

  factory DoPublishOperation.fromJson(Map<String, dynamic> json) => _$DoPublishOperationFromJson(json);
  Map<String, dynamic> toJson() => _$DoPublishOperationToJson(this);
}

class OperationResult {
  final dynamic value;

  OperationResult(this.value);

  factory OperationResult.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('survey')) {
      return OperationResult(SurveyOperationResult(json['survey']));
    } else if (json.containsKey('target')) {
      return OperationResult(TargetOperationResult(SectorType.fromString(json['target'] as String)));
    } else if (json.containsKey('research')) {
      return OperationResult(ResearchOperationResult.fromJson(json['research']));
    } else if (json.containsKey('locate')) {
      return OperationResult(LocateOperationResult(json['locate']));
    } else if (json.containsKey('ready_publish')) {
      return OperationResult(ReadyPublishOperationResult(json['ready_publish']));
    } else if (json.containsKey('do_publish')) {
      return OperationResult(
          DoPublishOperationResult(json['do_publish'][0], SectorType.fromString(json['do_publish'][1] as String)));
    } else {
      throw Exception('unknown OperationResult type');
    }
  }

  Map<String, dynamic> toJson() {
    assert(false, 'OperationResult.toJson should not be called');
    if (value is SurveyOperationResult) {
      return {'survey': (value as SurveyOperationResult).index};
    } else if (value is TargetOperationResult) {
      return {'target': (value as TargetOperationResult).sectorType};
    } else if (value is ResearchOperationResult) {
      return {'research': (value as ResearchOperationResult).toJson()};
    } else if (value is LocateOperationResult) {
      return {'locate': (value as LocateOperationResult).success};
    } else if (value is ReadyPublishOperationResult) {
      return {'ready_publish': (value as ReadyPublishOperationResult).indexes};
    } else if (value is DoPublishOperationResult) {
      return {
        'do_publish': [value.index, value.sectorType]
      };
    } else {
      throw Exception('unknown OperationResult type');
    }
  }

  String fmt() {
    if (value is SurveyOperationResult) {
      return '${value.index}';
    } else if (value is TargetOperationResult) {
      return '${value.sectorType}';
    } else if (value is ResearchOperationResult) {
      return '${value.fmt()}';
    } else if (value is LocateOperationResult) {
      return '${value.success}';
    } else if (value is ReadyPublishOperationResult) {
      return '${value.indexes}';
    } else if (value is DoPublishOperationResult) {
      return '${value.index} ${value.sectorType}';
    } else {
      throw Exception('unknown OperationResult type');
    }
  }
}

class SurveyOperationResult {
  final int index;
  SurveyOperationResult(this.index);
}

class TargetOperationResult {
  final SectorType sectorType;
  TargetOperationResult(this.sectorType);
}

typedef ResearchOperationResult = Clue;

class LocateOperationResult {
  final bool success;
  LocateOperationResult(this.success);
}

class ReadyPublishOperationResult {
  final int indexes;
  ReadyPublishOperationResult(this.indexes);
}

class DoPublishOperationResult {
  final int index;
  final SectorType sectorType;
  DoPublishOperationResult(this.index, this.sectorType);
}

// -- clue

@JsonEnum(fieldRename: FieldRename.pascal)
enum ClueEnum {
  A,
  B,
  C,
  D,
  E,
  F,
  // ignore: constant_identifier_names
  X1,
  // ignore: constant_identifier_names
  X2;

  @override
  String toString() {
    switch (this) {
      case ClueEnum.A:
        return 'A';
      case ClueEnum.B:
        return 'B';
      case ClueEnum.C:
        return 'C';
      case ClueEnum.D:
        return 'D';
      case ClueEnum.E:
        return 'E';
      case ClueEnum.F:
        return 'F';
      case ClueEnum.X1:
        return 'X1';
      case ClueEnum.X2:
        return 'X2';
    }
  }
}

extension ClueEnumExtension on ClueEnum {
  int toIndex() {
    switch (this) {
      case ClueEnum.A:
        return 0;
      case ClueEnum.B:
        return 1;
      case ClueEnum.C:
        return 2;
      case ClueEnum.D:
        return 3;
      case ClueEnum.E:
        return 4;
      case ClueEnum.F:
        return 5;
      case ClueEnum.X1:
        return 6;
      case ClueEnum.X2:
        return 7;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ClueSecret {
  final ClueEnum index;
  final String secret; // todo maybe we need to refactor this too.

  ClueSecret(this.index, this.secret);

  factory ClueSecret.fromJson(Map<String, dynamic> json) => _$ClueSecretFromJson(json);
  Map<String, dynamic> toJson() => _$ClueSecretToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Clue {
  final ClueEnum index;
  final SectorType subject;
  final SectorType object;
  final ClueConnection conn;

  Clue(this.index, this.subject, this.object, this.conn);

  factory Clue.fromJson(Map<String, dynamic> json) => _$ClueFromJson(json);
  Map<String, dynamic> toJson() => _$ClueToJson(this);

  String fmt() {
    if (subject == SectorType.X) {
      if (conn.value == 'allAdjacent') {
        return '$subject 和 $object 相邻';
      } else if (conn.value == 'oneAdjacent') {
        return '$subject 和 $object 相邻';
      } else if (conn.value == 'notAdjacent') {
        return '$subject 不和 $object 相邻';
      } else if (conn.value == 'oneOpposite') {
        return '$subject 和 $object 正对';
      } else if (conn.value == 'notOpposite') {
        return '$subject 不和 $object 正对';
      } else if (conn.value is Map<String, dynamic>) {
        if (conn.value.containsKey('allInRange')) {
          return '$subject 在 $object 的 ${conn.value['allInRange']} 格范围内';
        } else if (conn.value.containsKey('notInRange')) {
          return '$subject 不在 $object 的 ${conn.value['notInRange']} 格内';
        } else {
          throw Exception('unknown ClueConnection type');
        }
      } else {
        throw Exception('unknown ClueConnection type');
      }
    }
    if (conn.value == 'allAdjacent') {
      return '所有 $subject 和 $object 相邻';
    } else if (conn.value == 'oneAdjacent') {
      return '至少一个 $subject 和 $object 相邻';
    } else if (conn.value == 'notAdjacent') {
      return '没有 $subject 和 $object 相邻';
    } else if (conn.value == 'oneOpposite') {
      return '至少一个 $subject 和 $object 正对';
    } else if (conn.value == 'notOpposite') {
      return '没有 $subject 和 $object 正对';
    } else if (conn.value is Map<String, dynamic>) {
      if (conn.value.containsKey('allInRange')) {
        if (object == subject) {
          return '所有 $subject 都在一个长度为 ${conn.value['allInRange']} 的区间内';
        } else {
          return '所有 $subject 在 $object 的 ${conn.value['allInRange']} 格范围内';
        }
      } else if (conn.value.containsKey('notInRange')) {
        return '没有 $subject 在 $object 的 ${conn.value['notInRange']} 格内';
      } else {
        throw Exception('unknown ClueConnection type');
      }
    } else {
      throw Exception('unknown ClueConnection type');
    }
  }
}

class ClueConnection {
  dynamic value;

  ClueConnection(this.value);

  factory ClueConnection.allAdjacent() {
    return ClueConnection('allAdjacent');
  }
  factory ClueConnection.oneAdjacent() {
    return ClueConnection('oneAdjacent');
  }
  factory ClueConnection.notAdjacent() {
    return ClueConnection('notAdjacent');
  }
  factory ClueConnection.oneOpposite() {
    return ClueConnection('oneOpposite');
  }
  factory ClueConnection.notOpposite() {
    return ClueConnection('notOpposite');
  }
  factory ClueConnection.allInRange(int range) {
    return ClueConnection({'allInRange': range});
  }
  factory ClueConnection.notInRange(int range) {
    return ClueConnection({'notInRange': range});
  }

  factory ClueConnection.fromJson(dynamic json) {
    if (json is String) {
      if (json == 'allAdjacent') {
        return ClueConnection.allAdjacent();
      } else if (json == 'oneAdjacent') {
        return ClueConnection.oneAdjacent();
      } else if (json == 'notAdjacent') {
        return ClueConnection.notAdjacent();
      } else if (json == 'oneOpposite') {
        return ClueConnection.oneOpposite();
      } else if (json == 'notOpposite') {
        return ClueConnection.notOpposite();
      } else {
        throw Exception('unknown ClueConnection type');
      }
    } else if (json is Map<String, dynamic>) {
      if (json.containsKey('allInRange')) {
        return ClueConnection.allInRange(json['allInRange']);
      } else if (json.containsKey('notInRange')) {
        return ClueConnection.notInRange(json['notInRange']);
      } else {
        throw Exception('unknown ClueConnection type');
      }
    } else {
      throw Exception('unknown ClueConnection type');
    }
  }

  dynamic toJson() {
    if (value is String) {
      return value;
    } else if (value is Map<String, dynamic>) {
      return value;
    } else {
      throw Exception('unknown ClueConnection type');
    }
  }
}
