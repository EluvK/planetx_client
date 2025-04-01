import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/pages/game.dart';
import 'package:planetx_client/pages/home.dart';
import 'package:planetx_client/pages/test.dart';
import 'package:planetx_client/utils/translation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  usePathUrlStrategy();

  await GetStorage.init('XPlanetStorage');
  HttpOverrides.global = MyHttpOverrides();

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final setting = Get.find<SettingController>();
    var locale = setting.localeValue;
    var app = GetMaterialApp(
      title: 'The Search for Planet X',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      translations: Translation(),
      locale: locale,
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/test', page: () => TestPage()),
        GetPage(name: '/game', page: () => GamePage()),
        GetPage(name: '/setting', page: () => SettingPage()),
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
        fontFamily: 'lxgw',
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
        fontFamily: 'lxgw',
      ),
    );
    return app;
  }
}
