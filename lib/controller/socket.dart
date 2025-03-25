import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket? socket;
  final settingController = Get.find<SettingController>();

  final currentRoom = RoomResult("", []).obs;

  @override
  Future<void> onInit() async {
    _beginInit = true;

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

  void reconnect() {
    final address = "${settingController.serverAddress.value}/xplanet";
    print("address: $address");

    if (socket != null && socket!.connected && socket!.io.uri == address) return;

    if (socket != null && socket!.connected) {
      socket!.disconnect();
    }

    socket = IO.io(address, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print('connect');
      socket!.emit("auth", settingController.user.toJson());
    });
    socket!.onDisconnect((data) {
      print('disconnect $data');
      Get.snackbar("断开连接", data.toString());
    });
    socket!.onConnectError((data) {
      print('connect_error $data');
      // Get.snackbar("连接错误", data.toString());
    });
    socket!.on("server_resp", (data) {
      print(data);
      Get.snackbar("服务端", data.toString());
    });
    socket!.on("room_result", (data) {
      print("room_result: $data");
      final room = RoomResult.fromJson(data);
      currentRoom.value = room;
      Get.snackbar("房间", data.toString());
    });
    socket!.on("op", (data) {
      print("op: $data");
      Get.snackbar("操作", data.toString());
    });
    socket!.on("op_result", (data) {
      print("op_result: $data");
      Get.snackbar("操作结果", data.toString());
    });
  }

  void op(Operation operation) {
    if (socket == null) return;
    socket!.emit('op', operation.toJson());
  }

  void room(RoomUserOperation operation) {
    if (socket == null) return;
    socket!.emit('room', operation.toJson());
  }
}
