import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

TableCell cell(Widget child) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    ),
  );
}

class GameResult extends StatefulWidget {
  const GameResult({super.key});

  @override
  State<GameResult> createState() => _GameResultState();
}

class _GameResultState extends State<GameResult> {
  final socket = Get.find<SocketController>();
  final setting = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var result = socket.currentGameState.value.gameResult;
      var mapType = socket.currentGameState.value.mapType;
      if (result == null) {
        return const SizedBox.shrink();
      }

      List<TableRow> tableRows = [
        TableRow(
          children: [
            cell(Text("result_user_name".tr)),
            cell(Text("result_first".tr)),
            cell(Wrap(
              children: [
                Image.asset(SectorType.Asteroid.iconName, width: 20, height: 20),
                Text("result_asteroid".tr),
              ],
            )),
            cell(Wrap(children: [
              Image.asset(SectorType.Comet.iconName, width: 20, height: 20),
              Text("result_comet".tr),
            ])),
            cell(Wrap(children: [
              Image.asset(SectorType.DwarfPlanet.iconName, width: 20, height: 20),
              if (mapType == MapType.standard) Text("result_dwarf_planet_standard".tr),
              if (mapType == MapType.expert) Text("result_dwarf_planet_expert".tr),
            ])),
            cell(Wrap(children: [
              Image.asset(SectorType.Nebula.iconName, width: 20, height: 20),
              Text("result_nebula".tr),
            ])),
            cell(Wrap(children: [
              Image.asset(SectorType.X.iconName, width: 20, height: 20),
              Text("result_x".tr),
            ])),
            cell(Text("result_sum".tr)),
            cell(Text("result_step".tr)),
          ],
        ),
        for (var user in result)
          TableRow(
            children: [
              cell(Text(user.name)),
              cell(Text(user.first.toString())),
              cell(Text(user.asteroid.toString())),
              cell(Text(user.comet.toString())),
              cell(Text(user.dwarfPlanet.toString())),
              cell(Text(user.nebula.toString())),
              cell(Text(user.x.toString())),
              cell(Text(user.sum.toString())),
              cell(Text(user.step.toString())),
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
