// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/utils/picker.dart';
import 'package:planetx_client/utils/utils.dart';

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

  reset() {
    setState(() => _expandedOp = null);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (socket.currentGameState.value.status.isNotStarted) {
        return const SizedBox.shrink();
      }

      final GameStage currentGameStage = socket.currentGameState.value.gameStage;
      List<OpEnum> ops;
      switch (currentGameStage) {
        case GameStage.userMove:
          ops = [
            OpEnum.Survey,
            OpEnum.Target,
            OpEnum.Research,
            OpEnum.Locate,
          ];
        case GameStage.meetingProposal:
          ops = [OpEnum.ReadyPublish];
        case GameStage.meetingPublish:
          ops = [OpEnum.DoPublish];
        default:
          ops = [];
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: _expandedOp == null
            ? Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  for (var op in ops)
                    ElevatedButton(
                      onPressed: () => setState(() => _expandedOp = op),
                      child: Text(op.name),
                    ),
                ],
              )
            : Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _expandedOp = null),
                  ),
                  Expanded(
                    child: _buildExpandedContent(_expandedOp!),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildExpandedContent(OpEnum op) {
    switch (op) {
      case OpEnum.Survey:
        return SurveyOpWidget(reset: reset);
      case OpEnum.Target:
        return TargetOpWidget(reset: reset);
      case OpEnum.Research:
        return ResearchOpWidget(reset: reset);
      case OpEnum.Locate:
        return LocateOpWidget(reset: reset);
      case OpEnum.ReadyPublish:
        return ReadyPublishOpWidget(reset: reset);
      case OpEnum.DoPublish:
        return DoPublishOpWidget(reset: reset);
    }
  }
}

class SurveyOpWidget extends StatefulWidget {
  const SurveyOpWidget({super.key, required this.reset});

  final void Function() reset;

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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
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
        _opCost(4 - (_range(from, to, max) - 1) ~/ 3),
        // Text('Price_3-4/2-4'),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.survey(type, from, to));
            widget.reset();
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class TargetOpWidget extends StatefulWidget {
  const TargetOpWidget({super.key, required this.reset});

  final void Function() reset;
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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
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
        _opCost(4),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.target(res));
            widget.reset();
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class ResearchOpWidget extends StatefulWidget {
  const ResearchOpWidget({super.key, required this.reset});

  final void Function() reset;

  @override
  State<ResearchOpWidget> createState() => _ResearchOpWidgetState();
}

class _ResearchOpWidgetState extends State<ResearchOpWidget> {
  final socket = Get.find<SocketController>();
  ClueEnum input = ClueEnum.A;

  @override
  Widget build(BuildContext context) {
    List<ClueSecret> clues = socket.currentClueSecret;
    List<Clue> cluesDetails = socket.currentClueDetails;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Research:'),
        CluePicker(
          clueSecrets: clues
              .where((element) => element.index != ClueEnum.X1 && element.index != ClueEnum.X2
                  // && cluesDetails.firstWhereOrNull((e) => e.index == element.index) == null
                  )
              .toList(),
          clueDetails: cluesDetails,
          value: input,
          onChanged: (value) {
            print(value);
            setState(() => input = value);
          },
        ),
        _opCost(1),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.research(input));
            widget.reset();
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class LocateOpWidget extends StatefulWidget {
  const LocateOpWidget({super.key, required this.reset});

  final void Function() reset;

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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
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
        _opCost(5),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.locate(index, pre, next));
            widget.reset();
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

@override
Widget _opCost(int cost) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [Icon(Icons.numbers_rounded), Text(cost.toString())],
  );
}

int _range(int from, int to, int max) {
  if (from < to) {
    return to - from + 1;
  } else {
    return max - from + to;
  }
}

class ReadyPublishOpWidget extends StatefulWidget {
  const ReadyPublishOpWidget({super.key, required this.reset});

  final void Function() reset;

  @override
  State<ReadyPublishOpWidget> createState() => _ReadyPublishOpWidgetState();
}

class _ReadyPublishOpWidgetState extends State<ReadyPublishOpWidget> {
  final socket = Get.find<SocketController>();

  Nullable<SectorType> firstToken = Nullable.none();
  Nullable<SectorType> secondToken = Nullable.none();

  @override
  Widget build(BuildContext context) {
    final cnt = socket.currentGameState.value.mapType.meteringSectorCount;
    Map<SectorType, int> tokenCount = {};
    for (var token in socket.currentTokens) {
      if (token.placed) continue;
      if (tokenCount[token.type] == null) {
        tokenCount[token.type] = 1;
      } else {
        tokenCount[token.type] = tokenCount[token.type]! + 1;
      }
    }
    Map<SectorType, int> tokenCount1 = tokenCount;
    Map<SectorType, int> tokenCount2 = tokenCount1;
    if (firstToken.isSome) {
      tokenCount2[firstToken.value!] = tokenCount1[firstToken.value!]! - 1;
    }
    if (secondToken.isSome) {
      tokenCount2[secondToken.value!] = tokenCount1[secondToken.value!]! - 1;
    }
    // print(tokenCount);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('ReadyPublish:'),
        TokenPicker(
          value: firstToken,
          onChanged: (value) => setState(() {
            print("value: $value");
            firstToken = value;
          }),
          tokenCount: tokenCount1,
        ),
        if (cnt == 2)
          TokenPicker(
            value: secondToken,
            onChanged: (value) => setState(() => secondToken = value),
            tokenCount: tokenCount2,
          ),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.readyPublish([
              if (firstToken.isSome) firstToken.value!,
              if (secondToken.isSome) secondToken.value!,
            ]));
            widget.reset();
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}

class DoPublishOpWidget extends StatefulWidget {
  const DoPublishOpWidget({super.key, required this.reset});

  final void Function() reset;

  @override
  State<DoPublishOpWidget> createState() => _DoPublishOpWidgetState();
}

class _DoPublishOpWidgetState extends State<DoPublishOpWidget> {
  final socket = Get.find<SocketController>();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('DoPublish:'),
        ElevatedButton(
          onPressed: () {
            socket.op(Operation.doPublish(
              //todo
              2, SectorType.Comet,
            ));
            widget.reset();
          },
          child: Text('submit'),
        ),
      ],
    );
  }
}
