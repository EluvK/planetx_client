// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'op.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyOperation _$SurveyOperationFromJson(Map<String, dynamic> json) => SurveyOperation(
      $enumDecode(_$SectorTypeEnumMap, json['sector_type']),
      (json['start'] as num).toInt(),
      (json['end'] as num).toInt(),
    );

Map<String, dynamic> _$SurveyOperationToJson(SurveyOperation instance) => <String, dynamic>{
      'sector_type': _$SectorTypeEnumMap[instance.sectorType]!,
      'start': instance.start,
      'end': instance.end,
    };

const _$SectorTypeEnumMap = {
  SectorType.Comet: 'comet',
  SectorType.Asteroid: 'asteroid',
  SectorType.DwarfPlanet: 'dwarf_planet',
  SectorType.Nebula: 'nebula',
  SectorType.Space: 'space',
  SectorType.X: 'x',
};

TargetOperation _$TargetOperationFromJson(Map<String, dynamic> json) => TargetOperation(
      (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$TargetOperationToJson(TargetOperation instance) => <String, dynamic>{
      'index': instance.index,
    };

ResearchOperation _$ResearchOperationFromJson(Map<String, dynamic> json) => ResearchOperation(
      $enumDecode(_$ClueEnumEnumMap, json['index']),
    );

Map<String, dynamic> _$ResearchOperationToJson(ResearchOperation instance) => <String, dynamic>{
      'index': _$ClueEnumEnumMap[instance.index]!,
    };

const _$ClueEnumEnumMap = {
  ClueEnum.A: 'A',
  ClueEnum.B: 'B',
  ClueEnum.C: 'C',
  ClueEnum.D: 'D',
  ClueEnum.E: 'E',
  ClueEnum.F: 'F',
  ClueEnum.X1: 'X1',
  ClueEnum.X2: 'X2',
};

LocateOperation _$LocateOperationFromJson(Map<String, dynamic> json) => LocateOperation(
      (json['index'] as num).toInt(),
      $enumDecode(_$SectorTypeEnumMap, json['pre_sector_type']),
      $enumDecode(_$SectorTypeEnumMap, json['next_sector_type']),
    );

Map<String, dynamic> _$LocateOperationToJson(LocateOperation instance) => <String, dynamic>{
      'index': instance.index,
      'pre_sector_type': _$SectorTypeEnumMap[instance.preSectorType]!,
      'next_sector_type': _$SectorTypeEnumMap[instance.nextSectorType]!,
    };

ReadyPublishOperation _$ReadyPublishOperationFromJson(Map<String, dynamic> json) => ReadyPublishOperation(
      (json['sectors'] as List<dynamic>).map((e) => $enumDecode(_$SectorTypeEnumMap, e)).toList(),
    );

Map<String, dynamic> _$ReadyPublishOperationToJson(ReadyPublishOperation instance) => <String, dynamic>{
      'sectors': instance.sectors.map((e) => _$SectorTypeEnumMap[e]!).toList(),
    };

DoPublishOperation _$DoPublishOperationFromJson(Map<String, dynamic> json) => DoPublishOperation(
      (json['index'] as num).toInt(),
      $enumDecode(_$SectorTypeEnumMap, json['sector_type']),
    );

Map<String, dynamic> _$DoPublishOperationToJson(DoPublishOperation instance) => <String, dynamic>{
      'index': instance.index,
      'sector_type': _$SectorTypeEnumMap[instance.sectorType]!,
    };

ClueSecret _$ClueSecretFromJson(Map<String, dynamic> json) => ClueSecret(
      $enumDecode(_$ClueEnumEnumMap, json['index']),
      json['secret'] as String,
    );

Map<String, dynamic> _$ClueSecretToJson(ClueSecret instance) => <String, dynamic>{
      'index': _$ClueEnumEnumMap[instance.index]!,
      'secret': instance.secret,
    };

ClueDetail _$ClueDetailFromJson(Map<String, dynamic> json) => ClueDetail(
      $enumDecode(_$ClueEnumEnumMap, json['index']),
      json['detail'] as String,
    );

Map<String, dynamic> _$ClueDetailToJson(ClueDetail instance) => <String, dynamic>{
      'index': _$ClueEnumEnumMap[instance.index]!,
      'detail': instance.detail,
    };
