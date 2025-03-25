import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/socket.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final socket = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 30,
        child: ListView(
          shrinkWrap: true,
          children: socket.messages
              .map((message) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(message),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _RoomInfos extends StatefulWidget {
  const _RoomInfos();

  @override
  State<_RoomInfos> createState() => _RoomInfosState();
}

class _RoomInfosState extends State<_RoomInfos> {
  final socket = Get.find<SocketController>();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
