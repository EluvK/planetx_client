import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/user.dart';

class OpLog extends StatefulWidget {
  const OpLog({super.key});

  @override
  State<OpLog> createState() => _OpLogState();
}

class _OpLogState extends State<OpLog> {
  final socket = Get.find<SocketController>();
  final setting = Get.find<SettingController>();

  TableCell cell(Widget child) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = setting.userId.value;

    return Obx(() {
      List<Operation> userMoves =
          socket.currentGameState.value.users.firstWhere((element) => element.id == currentUserId).moves;
      List<OperationResult> results = socket.currentMovesResult;
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

      return Table(
        border: TableBorder.all(),
        children: tableRows,
      );
    });
  }
}
