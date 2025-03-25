import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
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

  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb) {
  //   BrowserContextMenu.disableContextMenu();
  // }

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
      themeMode: ThemeMode.light,
      theme: FlexThemeData.light(
        scheme: FlexScheme.blumineBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
        ),
        tones: FlexTones.material(Brightness.light).onMainsUseBW(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // fontFamily: 'lxgw',
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.blumineBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 14,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
        ),
        tones: FlexTones.material(Brightness.dark).onMainsUseBW(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // fontFamily: 'lxgw',
      ),
    );
    return app;
  }
}
