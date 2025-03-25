// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

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
        return const Text('Survey');
      case OpEnum.Target:
        return const Text('Target');
      case OpEnum.Research:
        return const Text('Research');
      case OpEnum.Locate:
        return const Text('Locate');
      case OpEnum.ReadyPublish:
        return const Text('ReadyPublish');
      case OpEnum.DoPublish:
        return const Text('DoPublish');
    }
  }
}
