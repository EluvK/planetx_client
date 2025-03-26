import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:planetx_client/controller/socket.dart';

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
  final socket = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final clueSecret = socket.currentClueSecret;
      final clueDetails = socket.currentClueDetails;
      return Table(
        columnWidths: {
          0: const FlexColumnWidth(1),
          1: const FlexColumnWidth(2),
        },
        border: TableBorder.all(),
        children: [
          for (var clue in ClueEnum.values)
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "${clue.name}:${clue.index <= 5 ? "  " : " "}${clueSecret.length > clue.index ? clueSecret[clue.index] : ''}"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(clueDetails.length > clue.index ? clueDetails[clue.index] : ''),
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}
