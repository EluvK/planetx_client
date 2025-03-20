import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/pages/game.dart';
import 'package:planetx_client/pages/home.dart';

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
    var app = GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/game',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/game', page: () => GamePage()),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
    );
    return app;
  }
}
