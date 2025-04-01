import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/utils/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Unfocuser(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('The Search for Planet X'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Get.toNamed('/setting');
              },
            ),
          ],
        ),
        body: const HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final textController = TextEditingController();
  final socketController = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('app_name'.tr, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            _NameEditor(),
            SizedBox(height: 12),
            _ServerAddressEditor(),
            SizedBox(height: 30),
            TextField(
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]'))],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'room_number_hint'.tr,
                suffixIcon: textController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () => textController.clear(),
                        icon: Icon(Icons.clear),
                      ),
              ),
              controller: textController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    socketController.room(RoomUserOperation.create());
                  },
                  child: Text('home_create_room'.tr),
                ),
                ElevatedButton(
                  onPressed: () {
                    socketController.room(RoomUserOperation.join(textController.text));
                  },
                  child: Text('home_join_room'.tr),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ServerAddressEditor extends StatefulWidget {
  const _ServerAddressEditor();

  @override
  State<_ServerAddressEditor> createState() => __ServerAddressEditorState();
}

class __ServerAddressEditorState extends State<_ServerAddressEditor> {
  final setting = Get.find<SettingController>();
  final socket = Get.find<SocketController>();
  late final addressController = TextEditingController(text: setting.serverAddress.value);
  final focus = FocusNode();

  @override
  void initState() {
    socket.reconnect();
    focus.addListener(() {
      // print('triggered focus listener: ${focus.hasFocus}');
      if (!focus.hasFocus && addressController.text.isNotEmpty) {
        // print("change address: ${addressController.text}");
        if (setting.serverAddress.value == addressController.text) return;
        setting.setServerAddress(addressController.text);
        socket.reconnect(force: true);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = socket.socketStatus.value;
      final serverVersion = socket.socketServerVersion.value;
      final clientVersion = VERSION;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            focusNode: focus,
            controller: addressController,
            decoration: InputDecoration(labelText: 'service_address'.tr, suffixIcon: status.icon),
            onChanged: (value) => setState(() {}),
            onSubmitted: (String value) {
              focus.unfocus();
              setState(() {});
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                Text(status == SocketStatus.connected ? 'server_version'.trParams({'version': serverVersion}) : '...',
                    style: TextStyle(fontSize: 12)),
                Text('client_version'.trParams({'version': clientVersion}), style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _NameEditor extends StatefulWidget {
  const _NameEditor();

  @override
  State<_NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<_NameEditor> {
  final setting = Get.find<SettingController>();
  late final nameController = TextEditingController(text: setting.userName.value);
  final focus = FocusNode();

  @override
  void initState() {
    focus.addListener(() {
      // print('triggered focus listener: ${focus.hasFocus}');
      if (!focus.hasFocus && nameController.text.isNotEmpty) {
        // print("change name: ${nameController.text}");
        if (setting.userName.value == nameController.text) return;
        setting.setUserName(nameController.text);
        Get.find<SocketController>().reconnect(force: true);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focus,
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'nickname'.tr,
        suffixIcon: (setting.userName.value == nameController.text)
            ? null
            : IconButton(
                icon: Icon(Icons.edit_rounded, color: Colors.grey),
                onPressed: () {
                  focus.unfocus();
                },
              ),
      ),
      onChanged: (value) => setState(() {}),
      onSubmitted: (String value) {
        focus.unfocus();
        setState(() {});
      },
    );
  }
}
