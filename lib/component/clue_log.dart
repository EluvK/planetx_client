import 'package:flutter/material.dart';

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
  X2,
}

class ClueLog extends StatefulWidget {
  const ClueLog({super.key});

  @override
  State<ClueLog> createState() => _ClueLogState();
}

class _ClueLogState extends State<ClueLog> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        for (var clue in ClueEnum.values)
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(clue.name),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Clue ${clue.index + 1}"),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
