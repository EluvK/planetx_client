import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/component/star_map.dart';
import 'package:planetx_client/controller/sector_status.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/recommend.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/model/server_resp.dart';

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
  final socketServerVersion = "".obs; // socket version
  final settingController = Get.find<SettingController>();
  late final sectorStatusController = Get.find<SectorStatusController>();

  // final localSectorStatus = <List<SectorStatus>>[].obs; // local sector status for star map

  final currentGameState = GameStateResp.placeholder().obs;
  final currentMovesResult = <OperationResult>[].obs; // operation results for self. sensitive data
  final currentClueSecret = <ClueSecret>[].obs;
  final currentClueDetails = <Clue>[].obs; // operation results for self. sensitive data
  final currentTokens = <Token>[].obs; // operation results for self. sensitive data
  final currentSecretTokens = <SecretToken>[].obs;
  final currentRecommendCount = 0.obs;
  final currentRecommendCanLocate = false.obs;

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

    if (kIsWeb) {
      socket = IO.io(
        address,
        IO.OptionBuilder().setReconnectionAttempts(5).setReconnectionDelay(1000).setReconnectionDelayMax(5000).build(),
      );
    } else {
      socket = IO.io(
        address,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .build(),
      );
    }

    socket!.connect();
    socket!.onConnect((_) {
      print('connect');
      socketStatus.value = SocketStatus.connected;
      socket!.emit("auth", settingController.user.toJson());
    });
    socket!.onDisconnect((data) {
      socketStatus.value = SocketStatus.disconnected;
      print('disconnect $data');
      Get.snackbar("断开连接", data.toString(), snackPosition: SnackPosition.BOTTOM);
    });
    socket!.onConnectError((data) {
      socketStatus.value = SocketStatus.error;
      print('connect_error $data');
      // Get.snackbar("连接错误", data.toString(), snackPosition: SnackPosition.BOTTOM);
    });
    socket!.on("server_resp", serverRespHandler);
    socket!.on("game_state", (data) {
      print("game_state: $data");
      final gs = GameStateResp.fromJson(data);
      currentGameState.value = gs;
      if (Get.currentRoute != "/game" && currentGameState.value.id != "") {
        Get.toNamed("/game");
        sectorStatusController.newGame();
        // localSectorStatus.clear();
        // localSectorStatus.value = List.generate(18, (index) => List.generate(6, (index) => SectorStatus.doubt));
      }
      if (Get.currentRoute == "/game" && currentGameState.value.id == "") Get.offAllNamed("/");
      // addMessage("game state: ${gs.id}");
      // Get.snackbar("房间", data.toString(), snackPosition: SnackPosition.BOTTOM);
    });
    socket!.on("game_start", (data) {
      print("clue_secret: $data");
      // Get.snackbar("线索", data.toString(), snackPosition: SnackPosition.BOTTOM);
      currentClueSecret.value = (data as List).map((e) => ClueSecret.fromJson(e)).toList();
      currentClueDetails.clear();
      currentMovesResult.clear();
    });
    // socket!.on("op", (data) {
    //   print("op: $data");
    //   Get.snackbar("操作", data.toString(), snackPosition: SnackPosition.BOTTOM);
    // });
    socket!.on("op_result", (data) {
      print("op_result: $data");
      // Get.snackbar("操作结果", data.toString(), snackPosition: SnackPosition.BOTTOM);
      final opResult = OperationResult.fromJson(data);
      Get.snackbar("操作结果", opResult.fmt(), snackPosition: SnackPosition.BOTTOM);
      currentMovesResult.add(opResult);
      if (opResult.value is ResearchOperationResult) {
        final researchOpResult = opResult.value as ResearchOperationResult;
        currentClueDetails.add(researchOpResult);
      }
    });

    socket!.on("recommend_result", (data) {
      print("recommend_result: $data");
      // Get.snackbar("推荐结果", data.toString(), snackPosition: SnackPosition.BOTTOM);
      final recommendResult = RecommendOperationResult.fromJson(data);
      if (recommendResult.result is CountResult) {
        final countResult = recommendResult.result as CountResult;
        // Get.snackbar("推荐结果", "推荐数量: ${countResult.count}", snackPosition: SnackPosition.BOTTOM);
        currentRecommendCount.value = countResult.count;
      } else if (recommendResult.result is CanLocateResult) {
        final canLocateResult = recommendResult.result as CanLocateResult;
        // Get.snackbar("推荐结果", "是否可以定位: ${canLocateResult.canLocate}", snackPosition: SnackPosition.BOTTOM);
        currentRecommendCanLocate.value = canLocateResult.canLocate;
      }
    });

    socket!.on("token", (data) {
      print("token: $data");
      // Get.snackbar("token", data.toString(), snackPosition: SnackPosition.BOTTOM);
      List<Token> tokens = (data as List).map((e) => Token.fromJson(e)).toList();
      print("tokens: $tokens");
      currentTokens.value = tokens;
    });

    socket!.on("board_tokens", (data) {
      print("board_tokens: $data");
      // Get.snackbar("board_tokens", data.toString(), snackPosition: SnackPosition.BOTTOM);
      List<SecretToken> tokens = (data as List).map((e) => SecretToken.fromJson(e)).toList();
      print("board_tokens: $tokens");
      currentSecretTokens.value = tokens;
    });

    socket!.on("xclue", (data) {
      print("xclue: $data");
      // Get.snackbar("xclue", data.toString(), snackPosition: SnackPosition.BOTTOM);
      List<Clue> clues = (data as List).map((e) => Clue.fromJson(e)).toList();
      print("clues: $clues");
      currentClueDetails.addAll(clues);
    });
  }

  serverRespHandler(data) {
    print("data: $data");
    try {
      final resp = ServerResp.fromJson(data);
      if (resp.data is RespVersion) {
        socketServerVersion.value = (resp.data as RespVersion).version;
      } else {
        if (resp.data is RespRejoinRoom) {
          room(RoomUserOperation.join((resp.data as RespRejoinRoom).rejoinRoom));
        } else {}
        print(resp);
        Get.snackbar(resp.title, resp.content, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("服务端", "解析错误 $e", snackPosition: SnackPosition.BOTTOM);
      print("error: $e");
    }
  }

  void op(Operation operation) {
    if (socket == null) {
      Get.snackbar("未连接", "请先连接服务器", snackPosition: SnackPosition.BOTTOM);
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

  void sync() async {
    if (socket == null) {
      reconnect();
    }

    for (var i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      if (socket != null && socket!.connected) break;
    }
    socket!.emit('sync', {});
  }

  void recommend(RecommendOperation recommend) async {
    if (socket == null) {
      reconnect();
    }

    for (var i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      if (socket != null && socket!.connected) break;
    }
    socket!.emit('recommend', recommend);
  }

  // void addMessage(String message) {
  //   messages.add(message);
  //   Future.delayed(const Duration(seconds: 10), () {
  //     messages.remove(message);
  //   });
  // }
}
