import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum SocketStatus { connecting, connected, disconnected, error }

extension SocketStatusExtension on SocketStatus {
  Icon get icon {
    switch (this) {
      case SocketStatus.connecting:
        return Icon(Icons.sync_outlined, color: Colors.blue);
      case SocketStatus.connected:
        return Icon(Icons.check_box, color: Colors.green);
      case SocketStatus.disconnected:
        return Icon(Icons.close_outlined, color: Colors.red);
      case SocketStatus.error:
        return Icon(Icons.error_outline, color: Colors.red);
    }
  }
}

class SocketController extends GetxController {
  IO.Socket? socket;
  final socketStatus = SocketStatus.disconnected.obs;
  final settingController = Get.find<SettingController>();

  final currentGameState = GameStateResp.placeholder().obs;
  final currentMovesResult = <OperationResult>[].obs; // operation results for self. sensitive data
  final currentClueSecret = <ClueSecret>[].obs;
  final currentClueDetails = <Clue>[].obs; // operation results for self. sensitive data
  final currentTokens = <Token>[].obs; // operation results for self. sensitive data
  final currentSecretTokens = <SecretToken>[].obs;

  // final messages = <String>[].obs; // Observable list to store messages

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

  void reconnect({bool force = false}) {
    final address = "${settingController.serverAddress.value}/xplanet";
    print("address: $address");

    if (!force && socket != null && socket!.connected && socket!.io.uri == address) return;

    socketStatus.value = SocketStatus.connecting;
    if (socket != null) {
      socket!.disconnect();
    }

    socket = IO.io(address, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 5000,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print('connect');
      socketStatus.value = SocketStatus.connected;
      socket!.emit("auth", settingController.user.toJson());
    });
    socket!.onDisconnect((data) {
      socketStatus.value = SocketStatus.disconnected;
      print('disconnect $data');
      Get.snackbar("断开连接", data.toString());
    });
    socket!.onConnectError((data) {
      socketStatus.value = SocketStatus.error;
      print('connect_error $data');
      // Get.snackbar("连接错误", data.toString());
    });
    socket!.on("server_resp", (data) {
      print(data);
      // Get.snackbar("服务端", data.toString());
    });
    socket!.on("game_state", (data) {
      print("game_state: $data");
      final gs = GameStateResp.fromJson(data);
      currentGameState.value = gs;
      if (Get.currentRoute != "/game" && currentGameState.value.id != "") Get.toNamed("/game");
      if (Get.currentRoute == "/game" && currentGameState.value.id == "") Get.offAllNamed("/");
      // addMessage("game state: ${gs.id}");
      // Get.snackbar("房间", data.toString());
    });
    socket!.on("game_start", (data) {
      print("clue_secret: $data");
      // Get.snackbar("线索", data.toString());
      currentClueSecret.value = (data as List).map((e) => ClueSecret.fromJson(e)).toList();
      currentClueDetails.clear();
      currentMovesResult.clear();
    });
    // socket!.on("op", (data) {
    //   print("op: $data");
    //   Get.snackbar("操作", data.toString());
    // });
    socket!.on("op_result", (data) {
      print("op_result: $data");
      Get.snackbar("操作结果", data.toString());
      final opResult = OperationResult.fromJson(data);
      currentMovesResult.add(opResult);
      if (opResult.value is ResearchOperationResult) {
        final researchOpResult = opResult.value as ResearchOperationResult;
        currentClueDetails.add(researchOpResult);
      }
    });

    socket!.on("token", (data) {
      print("token: $data");
      // Get.snackbar("token", data.toString());
      List<Token> tokens = (data as List).map((e) => Token.fromJson(e)).toList();
      print("tokens: $tokens");
      currentTokens.value = tokens;
    });

    socket!.on("board_tokens", (data) {
      print("board_tokens: $data");
      // Get.snackbar("board_tokens", data.toString());
      List<SecretToken> tokens = (data as List).map((e) => SecretToken.fromJson(e)).toList();
      print("tokens: $tokens");
      currentSecretTokens.value = tokens;
    });
  }

  void op(Operation operation) {
    if (socket == null) {
      Get.snackbar("未连接", "请先连接服务器");
      return;
    }
    socket!.emit('op', operation.toJson());
  }

  void room(RoomUserOperation operation) async {
    if (socket == null) {
      reconnect();
    }

    for (var i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      if (socket != null && socket!.connected) break;
    }
    socket!.emit('room', operation.toJson());
  }

  // void addMessage(String message) {
  //   messages.add(message);
  //   Future.delayed(const Duration(seconds: 10), () {
  //     messages.remove(message);
  //   });
  // }
}
