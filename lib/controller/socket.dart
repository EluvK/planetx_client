import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

import 'package:socket_io_client/socket_io_client.dart';

class SocketController extends GetxController {
  late Socket socket;
  final settingController = Get.find<SettingController>();

  final currentRoom = RoomResult("", []).obs;

  @override
  Future<void> onInit() async {
    _beginInit = true;
    socket = io('http://127.0.0.1:7878/xplanet', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('connect');
      socket.emit("auth", settingController.user.toJson());
    });
    socket.onDisconnect((data) {
      print('disconnect $data');
      Get.snackbar("断开连接", data.toString());
    });
    socket.onConnectError((data) {
      print('connect_error $data');
      // Get.snackbar("连接错误", data.toString());
    });
    socket.on("server_resp", (data) {
      print(data);
      Get.snackbar("服务端", data.toString());
    });
    socket.on("room_result", (data) {
      print("room_result: $data");
      final room = RoomResult.fromJson(data);
      currentRoom.value = room;
      Get.snackbar("房间", data.toString());
    });

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

  void op(Operation operation) {
    socket.emit('op', operation.toJson());
  }

  void room(RoomUserOperation operation) {
    socket.emit('room', operation.toJson());
  }
}
