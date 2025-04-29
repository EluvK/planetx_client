import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/utils/rules.dart';
import 'package:planetx_client/utils/utils.dart';

// Define reusable styles
const buttonPadding = EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0);
const rowTextStyle = TextStyle(fontSize: 14);
const iconSize = 16.0;

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final socket = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hint = socket.currentGameState.value.hint;

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(3),
        ),
        // height: 30,
        child: Center(child: Text(hint ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      );
    });
  }
}

class RoomInfos extends StatefulWidget {
  const RoomInfos({super.key});

  @override
  State<RoomInfos> createState() => _RoomInfosState();
}

class _RoomInfosState extends State<RoomInfos> {
  final socket = Get.find<SocketController>();
  final setting = Get.find<SettingController>();

  Widget rowTextIconWidget(
      String text, IconData icon, bool started, Function() functionBeforeStart, Function()? functionAfterStart) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: rowTextStyle),
        if (!started)
          SizedBox(
            height: iconSize,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: functionBeforeStart,
              icon: Icon(icon, size: iconSize),
            ),
          ),
        if (started && functionAfterStart != null)
          SizedBox(
            height: iconSize,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: functionAfterStart,
              icon: Icon(icon, size: iconSize),
            ),
          ),
      ],
    );
  }

  Widget userWidget(UserState user, int index) {
    assert(index >= 0 && index < 4);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          user.isBot ? Icons.tag_faces_rounded : Icons.person,
          color: userIndexedColors[index],
        ),
        Icon(
          user.ready ? Icons.check_box : Icons.question_mark,
          color: user.ready ? Colors.green : Colors.blueGrey,
          size: iconSize,
        ),
        Text(user.name),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = setting.userId.value;
    return Obx(() {
      GameStateResp gameState = socket.currentGameState.value;
      if (gameState.id == "") {
        return const SizedBox.shrink();
      }
      final gameInfo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTextIconWidget(
            "room_info_room".trParams({"room": gameState.id}),
            gameState.status.isNotStarted ? Icons.copy : Icons.sync,
            gameState.status.isNotStarted,
            () => Clipboard.setData(ClipboardData(text: gameState.id)),
            () => socket.sync(),
          ),
          rowTextIconWidget(
            "room_info_seed".trParams({"seed": gameState.mapSeed.toString()}),
            Icons.refresh,
            gameState.status.isNotStarted,
            () {
              var rng = Random();
              socket.room(RoomUserOperation.edit(gameState.id, rng.nextInt(0xffffffff), gameState.mapType));
            },
            null,
          ),
          rowTextIconWidget(
            "room_info_mode".trParams({"mode": gameState.mapType.name}),
            Icons.swap_horiz,
            gameState.status.isNotStarted,
            () {
              final mapType = gameState.mapType == MapType.expert ? MapType.standard : MapType.expert;
              socket.room(RoomUserOperation.edit(gameState.id, gameState.mapSeed, mapType));
            },
            null,
          ),
        ],
      );

      final userInfo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...gameState.users.asMap().map((index, user) {
            return MapEntry(index, userWidget(user, index));
          }).values,
        ],
      );

      final currentUserState = gameState.users.firstWhere((element) => element.id == currentUserId);

      final buttons = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leaveButton(gameState, context),
          Spacer(),
          if (gameState.status.isNotStarted) prepareButton(currentUserState, gameState),
          SizedBox(width: 4),
          if (gameState.status.isNotStarted) switchBotButton(gameState),
          Spacer(),
          gameRuleButton(gameState),
        ],
      );

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.all(8),
        child: Wrap(
          spacing: 2.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            gameInfo,
            userInfo,
            buttons,
          ],
        ),
      );
    });
  }

  Widget switchBotButton(GameStateResp gameState) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: buttonPadding),
      onPressed: () {
        socket.room(RoomUserOperation.switchBot(gameState.id));
      },
      child: Text("room_button_switch_bot".tr),
    );
  }

  Widget prepareButton(UserState currentUserState, GameStateResp gameState) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: buttonPadding),
      onPressed: () {
        if (currentUserState.ready) {
          socket.room(RoomUserOperation.unprepare(gameState.id));
        } else {
          socket.room(RoomUserOperation.prepare(gameState.id));
        }
      },
      child: Text(currentUserState.ready ? "room_button_unprepare".tr : "room_button_prepare".tr),
    );
  }

  Widget leaveButton(GameStateResp gameState, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: buttonPadding),
      onPressed: () {
        if (gameState.status.isNotStarted || gameState.status.isEnd) {
          socket.room(RoomUserOperation.leave(gameState.id));
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("room_button_leave".tr),
                content: Text("room_button_leave_confirm".tr),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("cancel".tr, style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      socket.room(RoomUserOperation.leave(gameState.id));
                      Navigator.of(context).pop();
                      Get.offAllNamed('/');
                    },
                    child: Text("confirm".tr, style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Text("room_button_leave".tr),
    );
  }

  Widget gameRuleButton(GameStateResp gameState) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: buttonPadding),
      onPressed: () {
        showRulesDialog(context, gameState.mapType);
      },
      child: Text("room_button_show_rules".tr),
    );
  }
}
