// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:planetx_client/utils/number_picker.dart';

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
  OpEnum? _expandedOp;

  @override
  Widget build(BuildContext context) {
    if (_expandedOp == null) {
      return Wrap(
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
  }

  Widget _buildExpandedContent(OpEnum op) {
    switch (op) {
      case OpEnum.Survey:
        return _buildSurvey();
      case OpEnum.Target:
        return TargetOpWidget();
      case OpEnum.Research:
        return _buildResearch();
      case OpEnum.Locate:
        return _buildLocate();
      case OpEnum.ReadyPublish:
        return _buildReadyPublish();
      case OpEnum.DoPublish:
        return _buildDoPublish();
    }
  }

  Widget _buildSurvey() {
    return Row(
      children: [
        Text('Survey'),
        SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: null,
          child: Text('submit'),
        ),
      ],
    );
  }

  Widget _buildResearch() {
    return const Text('Research');
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

class TargetOpWidget extends StatefulWidget {
  const TargetOpWidget({super.key});

  @override
  State<TargetOpWidget> createState() => _TargetOpWidgetState();
}

class _TargetOpWidgetState extends State<TargetOpWidget> {
  var fromValue = 1;
  var toValue = 10;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Target'),
        SizedBox(width: 8.0),
        NumberPicker(
          value: fromValue,
          onChanged: (value) {
            setState(() {
              fromValue = value;
            });
          },
          from: 1,
          to: 10,
          title: 'from',
        ),
        Text(' to '),
        NumberPicker(
          value: toValue,
          onChanged: (value) {
            setState(() {
              toValue = value;
            });
          },
          from: 1,
          to: 10,
          title: 'to',
        ),
        ElevatedButton(
          onPressed: null,
          child: Text('submit'),
        ),
      ],
    );
  }
}
