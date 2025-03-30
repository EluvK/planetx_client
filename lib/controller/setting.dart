import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/user.dart';
import 'package:uuid/uuid.dart';

class SettingController extends GetxController {
  final box = GetStorage("XPlanetStorage");

  RxString userName = ''.obs;
  RxString userId = ''.obs;

  RxString serverAddress = 'https://api.planetx-online.top'.obs;

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
  final socketController = Get.find<SocketController>();
  final nameController = TextEditingController(text: Get.find<SettingController>().userName.value);
  final addressController = TextEditingController(text: Get.find<SettingController>().serverAddress.value);
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      SocketStatus status = socketController.socketStatus.value;
      return Center(
        child: SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "${'nickname'.tr} (${'nickname_hint'.tr})",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        settingController.setUserName(nameController.text);
                        socketController.reconnect(force: true);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  focusNode: focus,
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'service_address'.tr, suffixIcon: status.icon),
                  onChanged: (value) {},
                  onTapOutside: (e) {
                    settingController.setServerAddress(addressController.text);
                    print("onTapOutside: $e");
                    focus.unfocus();
                    socketController.reconnect();
                  },
                ),
                SizedBox(height: 20),
                languageButton(),
              ],
            ),
          ),
        ),
      );
    });
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
}
