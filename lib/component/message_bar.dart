import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/utils/utils.dart';

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
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 30,
        child: Center(child: Text(hint ?? '')),
        // ListView(
        //   shrinkWrap: true,
        //   children: socket.messages
        //       .map((message) => Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 4.0),
        //             child: Text(message),
        //           ))
        //       .toList(),
        // ),
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

  Widget rowTextIconWidget(String text, Function()? onPressed, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (onPressed != null)
          SizedBox(
            height: 16,
            child: IconButton(padding: EdgeInsets.zero, onPressed: onPressed, icon: Icon(icon, size: 16)),
          ),
      ],
    );
  }

  Widget userWidget(UserState user, int index) {
    assert(index >= 0 && index < 4);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person, color: userIndexedColors[index]),
        user.ready
            ? Icon(Icons.check_box, color: Colors.green, size: 16)
            : Icon(Icons.question_mark, color: Colors.blueGrey, size: 16),
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
            "Room: ${gameState.id}",
            gameState.status.isNotStarted
                ? () {
                    Clipboard.setData(ClipboardData(text: gameState.id));
                  }
                : () {
                    socket.sync();
                  },
            gameState.status.isNotStarted ? Icons.copy : Icons.sync,
          ),
          rowTextIconWidget(
            "Seed: ${gameState.mapSeed}",
            gameState.status.isNotStarted
                ? () {
                    var rng = Random();
                    socket.room(RoomUserOperation.edit(gameState.id, rng.nextInt(0xffffffff), gameState.mapType));
                  }
                : null,
            Icons.refresh,
          ),
          rowTextIconWidget(
            "Type: ${gameState.mapType.name}",
            gameState.status.isNotStarted
                ? () {
                    final mapType = gameState.mapType == MapType.expert ? MapType.standard : MapType.expert;
                    socket.room(RoomUserOperation.edit(gameState.id, gameState.mapSeed, mapType));
                  }
                : null,
            Icons.swap_horiz,
          ),
        ],
      );

      final userInfo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: gameState.users
            .asMap()
            .map((index, user) {
              return MapEntry(index, userWidget(user, index));
            })
            .values
            .toList(),
      );

      final currentUserState = gameState.users.firstWhere((element) => element.id == currentUserId);

      final buttons = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            ),
            onPressed: () {
              socket.room(RoomUserOperation.leave(gameState.id));
            },
            child: const Text("Leave"),
          ),
          SizedBox(height: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            ),
            onPressed: () {
              if (currentUserState.ready) {
                socket.room(RoomUserOperation.unprepare(gameState.id));
              } else {
                socket.room(RoomUserOperation.prepare(gameState.id));
              }
            },
            child: Text(currentUserState.ready ? "Unprepare" : "Prepare"),
          ),
        ],
      );

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
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
            if (gameState.status.isNotStarted) buttons,
          ],
        ),
      );
    });
  }
}
