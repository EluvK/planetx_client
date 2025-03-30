import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';

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
      List<ClueSecret> clueSecret = socket.currentClueSecret;
      List<Clue> clueDetails = socket.currentClueDetails;
      return Column(
        children: [
          Text("title_clue_log".tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Table(
            columnWidths: {
              0: const FlexColumnWidth(2),
              1: const FlexColumnWidth(3),
            },
            border: TableBorder.all(),
            children: [
              for (var clue in clueSecret)
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${clue.index.name}: ${clue.secret}"),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(clueDetails.firstWhereOrNull((element) => element.index == clue.index)?.fmt() ?? ""),
                    ),
                  ),
                ]),
            ],
          ),
        ],
      );
    });
  }
}
