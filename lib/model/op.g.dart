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
  SectorType.X: 'x',
  SectorType.Space: 'space',
};

TargetOperation _$TargetOperationFromJson(Map<String, dynamic> json) => TargetOperation(
      (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$TargetOperationToJson(TargetOperation instance) => <String, dynamic>{
      'index': instance.index,
    };

ResearchOperation _$ResearchOperationFromJson(Map<String, dynamic> json) => ResearchOperation(
      (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$ResearchOperationToJson(ResearchOperation instance) => <String, dynamic>{
      'index': instance.index,
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
