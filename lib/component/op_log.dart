import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/user.dart';

TableCell cell(Widget child) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    ),
  );
}

class OpLog extends StatefulWidget {
  const OpLog({super.key});

  @override
  State<OpLog> createState() => _OpLogState();
}

class _OpLogState extends State<OpLog> {
  final socket = Get.find<SocketController>();
  final setting = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    final currentUserId = setting.userId.value;

    return Obx(() {
      List<Operation> userMoves =
          socket.currentGameState.value.users.firstWhereOrNull((element) => element.id == currentUserId)?.moves ?? [];
      List<OperationResult> results =
          socket.currentMovesResult.where((element) => !element.isPublishOperation).toList();
      Map<User, List<Operation>> otherUserMoves = {
        for (var e in socket.currentGameState.value.users) User(e.name, e.id): e.moves
      };
      final maxRow = otherUserMoves.values.map((e) => e.length).fold(0, (a, b) => a > b ? a : b);
      otherUserMoves.removeWhere((key, value) => key.id == currentUserId);

      // Combine userMoves and results into table rows
      List<TableRow> tableRows = [
        TableRow(
          children: [
            cell(Text("User")),
            cell(Text("Result")),
            for (var user in otherUserMoves.keys) cell(Text(user.name)),
          ],
        ),
        for (var i = 0; i < maxRow; i++)
          TableRow(
            children: [
              cell(Text(userMoves.length > i ? userMoves[i].fmt() : "")),
              cell(Text(results.length > i ? results[i].fmt() : "")),
              for (var user in otherUserMoves.keys)
                cell(Text(otherUserMoves[user]!.length > i ? otherUserMoves[user]![i].fmt() : "")),
            ],
          ),
      ];

      return Column(
        children: [
          const Text("Operation Log"),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Table(
              border: TableBorder.all(),
              children: tableRows,
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    });
  }
}

class MeetingLog extends StatefulWidget {
  const MeetingLog({super.key});

  @override
  State<MeetingLog> createState() => _MeetingLogState();
}

class _MeetingLogState extends State<MeetingLog> {
  @override
  Widget build(BuildContext context) {
    final socket = Get.find<SocketController>();

    return Obx(() {
      List<String> meetingStr = [];
      for (var m in socket.currentMovesResult.where((element) => element.isPublishOperation).toList()) {
        if (m.isReadyPublishOperation) {
          meetingStr.add(m.fmt());
        } else {
          meetingStr.last += "(${m.fmt()})";
        }
      }

      return Column(
        children: [
          const Text("Meeting Log"),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    cell(Text("Meeting")),
                  ],
                ),
                for (var i = 0; i < meetingStr.length; i++)
                  TableRow(
                    children: [
                      cell(Text(meetingStr[i])),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    });
  }
}
