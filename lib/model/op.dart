// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'op.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum SectorType {
  Comet, // 彗星
  Asteroid, // 小行星
  DwarfPlanet, // 矮行星
  Nebula, // 气体云
  X,
  Space, // 空域
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
  factory Operation.research(int index) {
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
  final int index;

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
  bool operator ==(Object other) => other is ReadyPublishOperation && other.sectors == sectors;
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
      return OperationResult(TargetOperationResult(json['target']));
    } else if (json.containsKey('research')) {
      return OperationResult(ResearchOperationResult(json['research']));
    } else if (json.containsKey('locate')) {
      return OperationResult(LocateOperationResult(json['locate']));
    } else if (json.containsKey('ready_publish')) {
      return OperationResult(ReadyPublishOperationResult(json['ready_publish']));
    } else if (json.containsKey('do_publish')) {
      return OperationResult(DoPublishOperationResult(json['do_publish'][0], json['do_publish'][1]));
    } else {
      throw Exception('unknown OperationResult type');
    }
  }

  // Map<String, dynamic> toJson() {
  //   if (value is SurveyOperationResult) {
  //     return {'survey': (value as SurveyOperationResult).index};
  //   } else if (value is TargetOperationResult) {
  //     return {'target': (value as TargetOperationResult).sectorType};
  //   } else if (value is ResearchOperationResult) {
  //     return {'research': (value as ResearchOperationResult).content};
  //   } else if (value is LocateOperationResult) {
  //     return {'locate': (value as LocateOperationResult).success};
  //   } else if (value is ReadyPublishOperationResult) {
  //     return {'ready_publish': (value as ReadyPublishOperationResult).indexes};
  //   } else if (value is DoPublishOperationResult) {
  //     return {
  //       'do_publish': [value.index, value.sectorType]
  //     };
  //   } else {
  //     throw Exception('unknown OperationResult type');
  //   }
  // }
}

class SurveyOperationResult {
  final int index;
  SurveyOperationResult(this.index);
}

class TargetOperationResult {
  final SectorType sectorType;
  TargetOperationResult(this.sectorType);
}

class ResearchOperationResult {
  final String content;
  ResearchOperationResult(this.content);
}

class LocateOperationResult {
  final bool success;
  LocateOperationResult(this.success);
}

class ReadyPublishOperationResult {
  final List<int> indexes;
  ReadyPublishOperationResult(this.indexes);
}

class DoPublishOperationResult {
  final int index;
  final SectorType sectorType;
  DoPublishOperationResult(this.index, this.sectorType);
}
