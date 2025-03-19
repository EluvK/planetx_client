import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

void main() async {
  await GetStorage.init('XPlanetStorage');

  await Get.putAsync(() async {
    final controller = SettingController();
    return controller;
  });
  await Get.find<SettingController>().ensureInitialization();

  await Get.putAsync(() async {
    final controller = SocketController();
    return controller;
  });
  await Get.find<SocketController>().ensureInitialization();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    final controller = Get.find<SocketController>();
    controller.op(Operation.survey(SectorType.Comet, 1, 2));
    setState(() {
      _counter++;
    });
  }

  Widget updateName() {
    return ElevatedButton(
      onPressed: () {
        final controller = Get.find<SettingController>();
        controller.setUserName('new name');
      },
      child: Text('update name'),
    );
  }

  Widget createRoom() {
    return ElevatedButton(
      onPressed: () {
        final controller = Get.find<SocketController>();
        controller.room(RoomUserOperation.create());
      },
      child: Text('create room'),
    );
  }

  Widget joinRoom() {
    return ElevatedButton(
      onPressed: () {
        final controller = Get.find<SocketController>();
        controller.room(RoomUserOperation.join('room name'));
      },
      child: Text('join room'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            updateName(),
            createRoom(),
            joinRoom(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
