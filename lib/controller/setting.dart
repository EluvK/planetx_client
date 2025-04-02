import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:planetx_client/model/user.dart';
import 'package:planetx_client/utils/utils.dart';
import 'package:uuid/uuid.dart';

class SettingController extends GetxController {
  final box = GetStorage("XPlanetStorage");

  RxString userName = ''.obs;
  RxString userId = ''.obs;

  RxString serverAddress = 'https://api.planetx-online.top'.obs;
  final preferSeason = Season.spring.obs;

  final locale = const Locale('en').obs;

  @override
  Future<void> onInit() async {
    _beginInit = true;
    if (box.read('userId') == null) {
      final id = Uuid().v4();
      userId.value = id;
      box.write('userId', id);
    } else {
      userId.value = box.read('userId');
    }

    if (box.read('userName') == null) {
      final name = 'User-${userId.value.substring(0, 4)}';
      userName.value = name;
      box.write('userName', name);
    } else {
      userName.value = box.read('userName');
    }

    if (box.read('serverAddress') == null) {
      serverAddress.value = 'https://api.planetx-online.top';
      box.write('serverAddress', serverAddress.value);
    } else {
      serverAddress.value = box.read('serverAddress');
    }

    locale.value = Locale(box.read('locale') ?? 'zh');

    if (box.read('season') == null) {
      preferSeason.value = Season.spring;
      box.write('season', preferSeason.value.name);
    } else {
      preferSeason.value = Season.values.byName(box.read('season'));
    }

    super.onInit();
    _initialized = true;
  }

  bool _beginInit = false;
  bool _initialized = false;
  Future<void> ensureInitialization() async {
    if (!_beginInit) {
      await onInit();
    }
    while (!_initialized) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    return;
  }

  User get user => User(userName.value, userId.value);

  void setUserName(String name) {
    userName.value = name;
    box.write('userName', name);
  }

  String get serverUrl => serverAddress.value;

  void setServerAddress(String address) {
    serverAddress.value = address;
    box.write('serverAddress', address);
  }

  Locale get localeValue => locale.value;
  void setLocale(Locale locale) {
    this.locale.value = locale;
    box.write('locale', locale.languageCode);
    Get.updateLocale(locale);
  }

  Season get season => preferSeason.value;
  void setSeason(Season season) {
    preferSeason.value = season;
    box.write('season', season.name);
  }

  void spinSeason(){
    preferSeason.value = Season.values[(preferSeason.value.index + 1) % Season.values.length];
    box.write('season', preferSeason.value.name);
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: _Setting(),
    );
  }
}

class _Setting extends StatefulWidget {
  const _Setting();

  @override
  State<_Setting> createState() => __SettingState();
}

class __SettingState extends State<_Setting> {
  final settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              languageButton(),
              const SizedBox(height: 8),
              preferSeason(),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageButton() {
    var btn = DropdownButton<Locale>(
      value: settingController.locale.value,
      onChanged: (Locale? newValue) {
        settingController.setLocale(newValue!);
      },
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('zh'),
          child: Text('中文'),
        ),
      ],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('language'.tr), btn],
    );
  }

  Widget preferSeason() {
    var btn = DropdownButton<Season>(
      value: settingController.season,
      onChanged: (Season? newValue) {
        setState(() {
          settingController.setSeason(newValue!);
        });
      },
      items: Season.values.map((season) {
        return DropdownMenuItem(
          value: season,
          child: Text(season.fmt),
        );
      }).toList(),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('preferSeason'.tr), btn],
    );
  }
}
