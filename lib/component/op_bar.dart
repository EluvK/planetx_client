// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/utils/picker.dart';

class OpBar extends StatefulWidget {
  const OpBar({super.key});

  @override
  State<OpBar> createState() => _OpBarState();
}

enum OpEnum {
  Survey,
  Target,
  Research,
  Locate,
  ReadyPublish,
  DoPublish,
}

extension on OpEnum {
  String get name {
    switch (this) {
      case OpEnum.Survey:
        return 'Survey';
      case OpEnum.Target:
        return 'Target';
      case OpEnum.Research:
        return 'Research';
      case OpEnum.Locate:
        return 'Locate';
      case OpEnum.ReadyPublish:
        return 'ReadyPublish';
      case OpEnum.DoPublish:
        return 'DoPublish';
    }
  }
}

class _OpBarState extends State<OpBar> {
  final socket = Get.find<SocketController>();

  OpEnum? _expandedOp;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (socket.currentGameState.value.status.isNotStarted) {
        return const SizedBox.shrink();
      }
      if (_expandedOp == null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              for (var op in OpEnum.values)
                ElevatedButton(
                  onPressed: () => setState(() => _expandedOp = op),
                  child: Text(op.name),
                ),
            ],
          ),
        );
      } else {
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _expandedOp = null),
            ),
            Expanded(
              child: _buildExpandedContent(_expandedOp!),
            ),
          ],
        );
      }
    });
  }

  Widget _buildExpandedContent(OpEnum op) {
    switch (op) {
      case OpEnum.Survey:
        return SurveyOpWidget();
      case OpEnum.Target:
        return TargetOpWidget();
      case OpEnum.Research:
        return ResearchOpWidget();
      case OpEnum.Locate:
        return LocateOpWidget();
      case OpEnum.ReadyPublish:
        return _buildReadyPublish();
      case OpEnum.DoPublish:
        return _buildDoPublish();
    }
  }

  Widget _buildLocate() {
    return const Text('Locate');
  }

  Widget _buildReadyPublish() {
    return const Text('ReadyPublish');
  }

  Widget _buildDoPublish() {
    return const Text('DoPublish');
  }
}

class SurveyOpWidget extends StatefulWidget {
  const SurveyOpWidget({super.key});

  @override
  State<SurveyOpWidget> createState() => _SurveyOpWidgetState();
}

class _SurveyOpWidgetState extends State<SurveyOpWidget> {
  int from = 1;
  int to = 10;
  late int st;
  late int ed;
  late int max;
  SectorType type = SectorType.Comet;
  final socket = Get.find<SocketController>();

  @override
  void initState() {
    st = socket.currentGameState.value.startIndex;
    ed = socket.currentGameState.value.endIndex;
    max = socket.currentGameState.value.mapType.sectorCount;
    from = st;
    to = ed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Survey:'),
        NumberPicker(
          value: from,
          onChanged: (value) => setState(() => from = value),
          from: st,
          to: ed,
          max: max,
          title: 'from',
        ),
        Text('-'),
        NumberPicker(
          value: to,
          onChanged: (value) => setState(() => to = value),
          from: from,
          to: ed,
          max: max,
          title: 'to',
        ),
        SectorPicker(
          value: type,
          onChanged: (value) => setState(() => type = value),
          includeX: false,
        ),
        Text('Price_3-4/2-4'),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.survey(type, from, to));
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class TargetOpWidget extends StatefulWidget {
  const TargetOpWidget({super.key});

  @override
  State<TargetOpWidget> createState() => _TargetOpWidgetState();
}

class _TargetOpWidgetState extends State<TargetOpWidget> {
  var res = 1;
  final socket = Get.find<SocketController>();
  late int st;
  late int ed;
  late int max;

  @override
  void initState() {
    st = socket.currentGameState.value.startIndex;
    ed = socket.currentGameState.value.endIndex;
    max = socket.currentGameState.value.mapType.sectorCount;
    res = st;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Target:'),
        NumberPicker(
          value: res,
          onChanged: (value) => setState(() => res = value),
          title: 'from',
          from: st,
          to: ed,
          max: max,
        ),
        Text('Price_4'),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.target(res));
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class ResearchOpWidget extends StatefulWidget {
  const ResearchOpWidget({super.key});

  @override
  State<ResearchOpWidget> createState() => _ResearchOpWidgetState();
}

class _ResearchOpWidgetState extends State<ResearchOpWidget> {
  final socket = Get.find<SocketController>();
  ClueEnum input = ClueEnum.A;

  @override
  Widget build(BuildContext context) {
    List<ClueSecret> clues = socket.currentClueSecret;
    // todo can add some marker to show which clues are already used
    List<Clue> cluesDetails = socket.currentClueDetails;

    return Row(
      children: [
        Text('Research:'),
        CluePicker(
          clueSecrets: clues
              .where((element) => element.index != ClueEnum.X1 && element.index != ClueEnum.X2
                  // && cluesDetails.firstWhereOrNull((e) => e.index == element.index) == null
                  )
              .toList(),
          value: input,
          onChanged: (value) {
            print(value);
            setState(() => input = value);
          },
        ),
        Text('Price_1'),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.research(input));
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class LocateOpWidget extends StatefulWidget {
  const LocateOpWidget({super.key});

  @override
  State<LocateOpWidget> createState() => _LocateOpWidgetState();
}

class _LocateOpWidgetState extends State<LocateOpWidget> {
  final socket = Get.find<SocketController>();

  int index = 1;
  SectorType pre = SectorType.Space;
  SectorType next = SectorType.Space;

  @override
  Widget build(BuildContext context) {
    int mapSize = socket.currentGameState.value.mapType.sectorCount;
    return Row(
      children: [
        Text('Locate:'),
        SectorPicker(value: pre, onChanged: (value) => setState(() => pre = value)),
        // Text(' -'),
        NumberPicker(
          value: index,
          onChanged: (value) => setState(() => index = value),
          title: 'Locate X',
          from: 1,
          to: mapSize,
          max: mapSize,
        ),
        // Text('- '),
        SectorPicker(value: next, onChanged: (value) => setState(() => next = value)),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.locate(index, pre, next));
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}
