import 'package:flutter_test/flutter_test.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

void main() {
  serdeOperation();
  serdeRoomOperation();
}

void serdeRoomOperation() {
  return group('serde room Operation', () {
    test('room op create', () {
      final op = RoomUserOperation.create();
      final json = op.toJson();
      expect(json, "create");
    });

    test('room op join', () {
      final op = RoomUserOperation.join("1");
      final json = op.toJson();
      expect(json, {'join': "1"});
    });
  });
}

void serdeOperation() {
  return group('serde Operation', () {
    test('op survey', () {
      final op = Operation.survey(SectorType.Comet, 1, 2);
      final json = op.toJson();
      expect(json, {
        'survey': {
          'sector_type': 'comet',
          'start': 1,
          'end': 2,
        }
      });
    });
    test('op target', () {
      final op = Operation.target(1);
      final json = op.toJson();
      expect(json, {
        'target': {
          'index': 1,
        }
      });
    });

    test('op research', () {
      final op = Operation.research(ClueEnum.A);
      final json = op.toJson();
      expect(json, {
        'research': {
          'index': "A",
        }
      });
    });

    test('op locate', () {
      final op = Operation.locate(1, SectorType.Comet, SectorType.Asteroid);
      final json = op.toJson();
      expect(json, {
        'locate': {
          'index': 1,
          'pre_sector_type': 'comet',
          'next_sector_type': 'asteroid',
        }
      });
    });

    test('op ready publish', () {
      final op = Operation.readyPublish([SectorType.Comet, SectorType.Asteroid]);
      final json = op.toJson();
      expect(json, {
        'ready_publish': {
          'sectors': ['comet', 'asteroid'],
        }
      });
    });

    test('op do publish', () {
      final op = Operation.doPublish(1, SectorType.Comet);
      final json = op.toJson();
      expect(json, {
        'do_publish': {
          'index': 1,
          'sector_type': 'comet',
        }
      });
    });

    test('op from json', () {
      final json = {
        'survey': {
          'sector_type': 'comet',
          'start': 1,
          'end': 2,
        }
      };
      final op = Operation.fromJson(json);
      expect(op.value, SurveyOperation(SectorType.Comet, 1, 2));
    });

    test('op from json', () {
      final json = {
        'target': {
          'index': 1,
        }
      };
      final op = Operation.fromJson(json);
      expect(op.value, TargetOperation(1));
    });

    test('op from json', () {
      final json = {
        'research': {
          'index': "A",
        }
      };
      final op = Operation.fromJson(json);
      expect(op.value, ResearchOperation(ClueEnum.A));
    });

    test('op from json', () {
      final json = {
        'locate': {
          'index': 1,
          'pre_sector_type': 'comet',
          'next_sector_type': 'dwarf_planet',
        }
      };
      final op = Operation.fromJson(json);
      expect(op.value, LocateOperation(1, SectorType.Comet, SectorType.DwarfPlanet));
    });

    test('op from json', () {
      final json = {
        'ready_publish': {
          'sectors': ['comet', 'asteroid'],
        }
      };
      final op = Operation.fromJson(json);
      var exp = ReadyPublishOperation([SectorType.Comet, SectorType.Asteroid]);
      expect(op.value, exp);
    });

    test('op from json', () {
      final json = {
        'do_publish': {
          'index': 1,
          'sector_type': 'comet',
        }
      };
      final op = Operation.fromJson(json);
      expect(op.value, DoPublishOperation(1, SectorType.Comet));
    });

    test('op from json unknown', () {
      final json = {
        'unknown': {
          'index': 1,
        }
      };
      expect(() => Operation.fromJson(json), throwsException);
    });
  });
}
