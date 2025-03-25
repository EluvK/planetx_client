import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:planetx_client/model/user.dart';
import 'package:uuid/uuid.dart';

class SettingController extends GetxController {
  final box = GetStorage("XPlanetStorage");

  RxString userName = ''.obs;
  RxString userId = ''.obs;

  RxString serverAddress = 'http://127.0.0.1:7878'.obs;

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
      serverAddress.value = 'http://127.0.0.1:7878';
      box.write('serverAddress', serverAddress.value);
    } else {
      serverAddress.value = box.read('serverAddress');
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
}
