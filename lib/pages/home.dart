import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/room.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ElevatedButton(
              onPressed: () {
                socketController.room(RoomUserOperation.create());
              },
              child: Text('home_create_room'.tr),
            ),
            SizedBox(height: 30),
            TextField(
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]'))],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Number',
                suffixIcon: textController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () => textController.clear(),
                        icon: Icon(Icons.clear),
                      ),
              ),
              controller: textController,
            ),
            ElevatedButton(
              onPressed: () {
                socketController.room(RoomUserOperation.join(textController.text));
              },
              child: Text('home_join_room'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
