import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:planetx_client/controller/sector_status.dart';
import 'package:planetx_client/controller/setting.dart';
import 'package:planetx_client/controller/socket.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/recommend.dart';
import 'package:planetx_client/model/room.dart';
import 'package:planetx_client/utils/utils.dart';

class StarMap extends StatefulWidget {
  const StarMap({super.key});

  @override
  State<StarMap> createState() => _StarMapState();
}

class _StarMapState extends State<StarMap> {
  final socket = Get.find<SocketController>();
  final ss = Get.find<SectorStatusController>();
  final setting = Get.find<SettingController>();

  SectorStatus targetSectorStatus = SectorStatus.confirm;

  bool showMeetingView = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      GameStateResp state = socket.currentGameState.value;
      List<SecretToken> stokens = socket.currentSecretTokens;
      List<Token> tokens = socket.currentTokens;

      int recommendCount = socket.currentRecommendCount.value;
      bool canLocate = socket.currentRecommendCanLocate.value;

      // if (state.status.isNotStarted) {
      //   return const SizedBox.shrink();
      // }

      // this is a flip animation from left to right
      // ref: https://github.com/GONZALEZD/flutter_demos/blob/main/flip_animation/lib/main.dart
      var animatedMap = AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        transitionBuilder: (child, animation) {
          final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
              animation: rotateAnim,
              child: child,
              builder: (context, child) {
                final tiltSign = showMeetingView ? 1.0 : -1.0;
                final tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003 * tiltSign;
                final rawRotation = rotateAnim.value;
                final value = math.min(rawRotation, math.pi / 2);
                return Transform(
                  transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
                  alignment: Alignment.center,
                  child: child,
                );
              });
        },
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: showMeetingView ? buildMeetingMap(state, stokens, tokens) : buildStarMap(state),
      );

      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.1)),
        child: Stack(
          children: [
            Column(children: [SizedBox(height: 40), animatedMap]),
            // 操作按钮
            if (showMeetingView) Align(alignment: Alignment.topCenter, child: selfTokenCounter(tokens)),
            if (showMeetingView) Positioned(child: othersSecretTokenCounter(stokens)),
            Positioned(bottom: 0, child: recommendBar(recommendCount, canLocate)),
            if (!showMeetingView)
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: Row(
                    children: [
                      SegmentedButton(
                        segments: [
                          for (var status in SectorStatus.values)
                            ButtonSegment(
                              value: status,
                              label: status.label,
                              icon: SizedBox(width: 12, child: status.icon),
                            )
                        ],
                        selected: {targetSectorStatus},
                        showSelectedIcon: false,
                        onSelectionChanged: (Set<SectorStatus> newSelection) {
                          setState(() {
                            targetSectorStatus = newSelection.first;
                          });
                        },
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity(horizontal: -2, vertical: -2),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        child: IconButton(
                          onPressed: ss.canUndo ? () => setState(() => ss.undo()) : null,
                          icon: Icon(Icons.undo, size: 20),
                          tooltip: "starmap_button_undo".tr,
                        ),
                      ),
                      SizedBox(
                        child: IconButton(
                          onPressed: ss.canRedo ? () => setState(() => ss.redo()) : null,
                          icon: Icon(Icons.redo, size: 20),
                          tooltip: "starmap_button_redo".tr,
                        ),
                      ),
                      Tooltip(
                          message: "starmap_button_history_desc".tr,
                          child: Text("${ss.currentIndex} / ${ss.historyCount}", style: TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
              ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => setState(() => showMeetingView = !showMeetingView),
                icon: Icon(showMeetingView ? Icons.switch_left_rounded : Icons.switch_right_rounded, size: 30),
                tooltip: "starmap_button_flip".tr,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget selfTokenCounter(List<Token> tokens) {
    Map<SectorType, int> tokenCount = {};
    for (var token in tokens) {
      if (token.placed) {
        continue;
      }
      if (tokenCount.containsKey(token.type)) {
        tokenCount[token.type] = tokenCount[token.type]! + 1;
      } else {
        tokenCount[token.type] = 1;
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var entry in tokenCount.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(entry.key.iconName, width: 16, height: 16),
              SizedBox(width: 4),
              Text('${entry.value}'),
            ],
          ),
      ],
    );
  }

  Widget othersSecretTokenCounter(List<SecretToken> stokens) {
    Map<int, int> tokenCount = {}; // userIndex -> count
    for (var token in stokens) {
      if (token.sectorIndex != 0) {
        continue;
      }
      if (tokenCount.containsKey(token.userIndex)) {
        tokenCount[token.userIndex] = tokenCount[token.userIndex]! + 1;
      } else {
        tokenCount[token.userIndex] = 1;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var entry in tokenCount.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 16, color: userIndexedColors[entry.key - 1]),
              SizedBox(width: 4),
              Text('${entry.value}'),
            ],
          ),
      ],
    );
  }

  Widget recommendBar(int recommendCount, bool canLocate) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          child: LoadingTextButton(
            onPressed: () => socket.recommend(RecommendOperation.canLocate),
            buttonStyle: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
            ),
            child: Icon(canLocate ? Icons.check : Icons.question_mark, size: 16),
          ),
        ),
        LoadingTextButton(
          onPressed: () => socket.recommend(RecommendOperation.count),
          buttonStyle: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(0),
          ),
          child: Text("#$recommendCount"),
        ),
      ],
    );
  }

  Widget buildStarMap(GameStateResp state) {
    // final sectorStatus = socket.localSectorStatus;
    return Obx(() {
      final sectorStatus = ss.sectorStatus.value;
      return LayoutBuilder(
        key: ValueKey(showMeetingView),
        builder: (context, constraints) {
          // 获取父容器的宽度和高度
          double parentSize = math.min(constraints.maxWidth, constraints.maxHeight);
          // 设置最小值
          double size = math.max(parentSize, 300);
          return CircleSectors(
            containerSize: size,
            season: setting.season,
            state: state,
            sectorStatus: sectorStatus,
            onSectorTap: (sectorIndex, sequenceIndex) {
              print('扇区 $sectorIndex - 按钮 $sequenceIndex 被点击');
              setState(() {
                switch (targetSectorStatus) {
                  case SectorStatus.confirm:
                    sectorStatus[sectorIndex].fillRange(0, 6, SectorStatus.excluded);
                    sectorStatus[sectorIndex][sequenceIndex] = SectorStatus.confirm;
                    ss.updateStatus();
                    break;
                  case SectorStatus.excluded: // switch status
                    if (sectorStatus[sectorIndex][sequenceIndex] == SectorStatus.confirm) {
                      sectorStatus[sectorIndex][sequenceIndex] = SectorStatus.excluded;
                    } else {
                      sectorStatus[sectorIndex][sequenceIndex] = SectorStatus.confirm;
                    }
                    ss.updateStatus();
                    break;
                }
              });
            },
            onCenterTap: () {
              setState(() {
                setting.spinSeason();
              });
            },
          );
        },
      );
    });
  }

  LayoutBuilder buildMeetingMap(GameStateResp state, List<SecretToken> secretTokens, List<Token> tokens) {
    return LayoutBuilder(
      key: ValueKey(showMeetingView),
      builder: (context, constraints) {
        // 获取父容器的宽度和高度
        double parentSize = math.min(constraints.maxWidth, constraints.maxHeight);
        // 设置最小值
        double size = math.max(parentSize, 300);
        return CircleMeetings(
          containerSize: size,
          season: setting.season,
          state: state,
          secretTokens: secretTokens,
          tokens: tokens,
          onCenterTap: () {
            setState(() {
              setting.spinSeason();
            });
          },
        );
      },
    );
  }
}

class LoadingTextButton extends StatefulWidget {
  const LoadingTextButton({super.key, required this.onPressed, required this.child, required this.buttonStyle});

  final Function() onPressed;
  final ButtonStyle buttonStyle;
  final Widget child;

  @override
  State<LoadingTextButton> createState() => _LoadingTextButtonState();
}

class _LoadingTextButtonState extends State<LoadingTextButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() => isLoading = true);
        await widget.onPressed();
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => isLoading = false);
      },
      style: widget.buttonStyle,
      child: isLoading
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : widget.child,
    );
  }
}

class CircleMeetings extends StatelessWidget {
  const CircleMeetings({
    super.key,
    required this.containerSize,
    required this.season,
    required this.state,
    required this.secretTokens,
    required this.tokens,
    required this.onCenterTap,
  });

  final double containerSize;
  final Season season;
  final GameStateResp state;

  final List<SecretToken> secretTokens;
  final List<Token> tokens;
  final void Function() onCenterTap;

  @override
  Widget build(BuildContext context) {
    double radius = (containerSize - 30) / 2; // 圆半径
    const double baseRadius = 40; // 基础半径
    MapType mapType = state.mapType;
    int sectorCount = mapType.sectorCount;
    double eachSectorDegree = 360 / sectorCount;
    double startDegree = season.degree;

    const int meetingReviewTimePerSector = 4; // 每个扇区的会议揭露时间

    double dynamicTokenSize = containerSize / 24; // 动态Token大小
    List<Icon> meetingTokenBackgroundIcons = [
      Icon(Icons.autorenew_rounded, size: dynamicTokenSize),
      Icon(Icons.crop_free, size: dynamicTokenSize, color: Colors.grey),
      Icon(Icons.crop_free, size: dynamicTokenSize, color: Colors.grey),
      Icon(Icons.add_box_outlined, size: dynamicTokenSize, color: Colors.blueGrey),
    ];

    final List<SecretToken> meetingTokens = secretTokens.where((token) => token.sectorIndex != 0).toList();
    for (var token in secretTokens) {
      print(token.toJson());
    }

    return Center(
      child: SizedBox(
        width: containerSize,
        height: containerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 添加同心圆形边框
            ...List.generate(meetingReviewTimePerSector, (buttonIndex) {
              double circleRadius =
                  baseRadius + (radius - baseRadius) * (buttonIndex + 1) / (meetingReviewTimePerSector + 0.6);
              return CustomPaint(
                size: Size(containerSize, containerSize),
                painter: CircleBorderPainter(
                  radius: circleRadius,
                  color: Colors.grey.withOpacity(0.3), // 更浅的颜色
                ),
              );
            }),

            ...List.generate(sectorCount, (sectorIndex) {
              // 计算扇区中心角度（从顶部开始顺时针）
              double centerDegree = eachSectorDegree * sectorIndex + startDegree + eachSectorDegree / 2;
              // 转换为极坐标角度（右侧为0，逆时针）
              double radians = (centerDegree) * math.pi / 180;
              // 计算旋转角度（使按钮朝向圆心）
              double rotation = -(radians + math.pi);

              return Stack(
                children: [
                  ...List.generate(meetingReviewTimePerSector, (meetingIndex) {
                    // 计算按钮的半径位置（从内到外均匀分布）
                    // double buttonRadius =  radius * (buttonIndex + 1) / (buttonsPerSector + 1);
                    double buttonRadius =
                        baseRadius + (radius - baseRadius) * (meetingIndex + 1) / (meetingReviewTimePerSector + 0.6);
                    // 计算按钮的笛卡尔坐标
                    double x = buttonRadius * math.cos(radians);
                    double y = buttonRadius * math.sin(radians);

                    return Positioned(
                      left: containerSize / 2 + x - dynamicTokenSize / 2,
                      top: containerSize / 2 + y - dynamicTokenSize / 2,
                      child: SizedBox(
                        width: dynamicTokenSize.toDouble(),
                        height: dynamicTokenSize.toDouble(),
                        // decoration: BoxDecoration(
                        //   color: Colors.transparent,
                        //   shape: BoxShape.circle,
                        //   border: Border.all(color: Colors.grey),
                        // ),
                        child: meetingTokenBackgroundIcons[meetingIndex],
                      ),
                    );
                  }),
                ],
              );
            }),

            ...circleBasic(containerSize, onCenterTap, season, state),

            // 生成 SecretToken 点
            ...meetingTokens.map((token) {
              double sectorIndex = token.sectorIndex.toDouble();
              double meetingIndex = token.meetingIndex.toDouble();
              if (meetingIndex == 4) {
                meetingIndex = 3.24;
              }
              // 计算扇区中心角度（从顶部开始顺时针）
              // const double maxTokenCount = 6;
              double centerDegree = eachSectorDegree * (sectorIndex - 1) + startDegree;
              double delta = (eachSectorDegree) * (1.25 - (token.userIndex + 1) / 5);
              centerDegree += delta;

              // 转换为极坐标角度（右侧为0，逆时针）
              double radians = (centerDegree) * math.pi / 180;
              double buttonRadius =
                  baseRadius + (radius - baseRadius) * (meetingIndex + 1) / (meetingReviewTimePerSector + 0.6);
              double x = buttonRadius * math.cos(radians);
              double y = buttonRadius * math.sin(radians);
              // print(centerDegree);

              return Positioned(
                left: containerSize / 2 + x - dynamicTokenSize / 2, // 调整位置
                top: containerSize / 2 + y - dynamicTokenSize / 2, // 调整位置
                child: secretTokenWidget(dynamicTokenSize, token),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget secretTokenWidget(double dynamicTokenSize, SecretToken token) {
    if (token.type == null) {
      // Tooltip message: "token.type?.name", // todo use token here?
      return Container(
        width: dynamicTokenSize.toDouble(),
        height: dynamicTokenSize.toDouble(),
        decoration: BoxDecoration(color: userIndexedColors[token.userIndex - 1], shape: BoxShape.circle),
        child: Icon(Icons.token_outlined, color: Colors.white, size: dynamicTokenSize.toDouble()),
      );
    }
    var type = token.type!;
    return Container(
      width: dynamicTokenSize.toDouble(),
      height: dynamicTokenSize.toDouble(),
      decoration: BoxDecoration(
        // color: Colors.transparent,
        color: userIndexedColors[token.userIndex - 1].withAlpha(80),
        shape: BoxShape.circle,
        border: Border.all(color: userIndexedColors[token.userIndex - 1], width: 3),
      ),
      child: Image.asset(
        type.iconName,
        // width: dynamicTokenSize - 10,
        // height: dynamicTokenSize - 10,
        // color: Colors.blueGrey,
        // colorBlendMode: BlendMode.dstIn,
      ),
    );
  }
}

class CircleSectors extends StatelessWidget {
  const CircleSectors({
    super.key,
    required this.containerSize,
    required this.season,
    required this.state,
    required this.sectorStatus,
    required this.onSectorTap,
    required this.onCenterTap,
  });
  final double containerSize;
  final Season season;
  final GameStateResp state;
  final List<List<SectorStatus>> sectorStatus;
  final void Function(int, int) onSectorTap;
  final void Function() onCenterTap;

  @override
  Widget build(BuildContext context) {
    double radius = (containerSize - 30) / 2; // 圆半径
    double buttonSize = containerSize / 19; // 按钮大小
    const double baseRadius = 40; // 基础半径
    MapType mapType = state.mapType;
    int sectorCount = mapType.sectorCount;
    const int buttonsPerSector = 6; // 每个扇区的按钮数

    double eachSectorDegree = 360 / sectorCount;
    double startDegree = season.degree;

    return Center(
      child: SizedBox(
        width: containerSize,
        height: containerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 添加同心圆形边框
            ...List.generate(buttonsPerSector, (buttonIndex) {
              double circleRadius =
                  baseRadius + (radius - baseRadius) * (buttonIndex + 1) / (buttonsPerSector + 0.6) - buttonSize / 1.6;
              return CustomPaint(
                size: Size(containerSize, containerSize),
                painter: CircleBorderPainter(
                  radius: circleRadius,
                  color: Colors.grey.withOpacity(0.3), // 更浅的颜色
                ),
              );
            }),

            ...circleBasic(containerSize, onCenterTap, season, state),

            // 生成扇区和按钮
            ...List.generate(sectorCount, (sectorIndex) {
              // 计算扇区中心角度（从顶部开始顺时针）
              double centerDegree = eachSectorDegree * sectorIndex + startDegree + eachSectorDegree / 2;
              // 转换为极坐标角度（右侧为0，逆时针）
              double radians = (centerDegree) * math.pi / 180;
              // 计算旋转角度（使按钮朝向圆心）
              double rotation = -(radians + math.pi);

              return Stack(
                children: [
                  // 生成每个扇区的按钮
                  ...List.generate(buttonsPerSector, (buttonIndex) {
                    // 计算按钮的半径位置（从内到外均匀分布）
                    // double buttonRadius =  radius * (buttonIndex + 1) / (buttonsPerSector + 1);
                    double buttonRadius =
                        baseRadius + (radius - baseRadius) * (buttonIndex + 1) / (buttonsPerSector + 0.6);
                    // 计算按钮的笛卡尔坐标
                    double x = buttonRadius * math.cos(radians);
                    double y = buttonRadius * math.sin(radians);

                    return Positioned(
                      left: containerSize / 2 + x - buttonSize / 2,
                      top: containerSize / 2 + y - buttonSize / 2,
                      child: Transform.rotate(
                        angle: rotation,
                        child: GestureDetector(
                          onTap: () => onSectorTap(sectorIndex, buttonIndex),
                          onSecondaryTap: () => onSectorTap(sectorIndex, buttonIndex),
                          child: (buttonIndex != 0 || isPrime(sectorIndex + 1))
                              ? xplanetIcon(
                                  buttonSize,
                                  rotation,
                                  SectorType.fromStarMapIndex(buttonIndex),
                                  sectorStatus[sectorIndex][buttonIndex],
                                )
                              : SizedBox(),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Container xplanetIcon(double buttonSize, double rotation, SectorType type, SectorStatus status) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: status.imageColor.$1,
      ),
      child: Transform.rotate(
        angle: -rotation,
        child: Image.asset(
          type.iconName,
          width: buttonSize - 2,
          height: buttonSize - 2,
          color: status.imageColor.$2,
          colorBlendMode: status.imageColor.$3,
        ),
      ),
    );
  }
}

List<Widget> circleBasic(
  double containerSize,
  void Function() onCenterTap,
  Season season,
  GameStateResp state,
) {
  double radius = (containerSize - 30) / 2; // 圆半径
  MapType mapType = state.mapType;
  int sectorCount = mapType.sectorCount;
  double eachSectorDegree = 360 / sectorCount;
  double startDegree = season.degree;

  List<UserState> personPoints = state.users;
  List<int> meetingPoints = mapType.meetingPoints;
  List<int> xCluePoints = mapType.xCluePoints;

  int meetingPointSize = math.max((containerSize / 32).toInt(), 18); // 会议点大小
  int xCluePointSize = math.max((containerSize / 34).toInt(), 16); // X线索点大小
  int personPointSize = math.max((containerSize / 30).toInt(), 20); // 人员点大小

  // 绘制扇区边界线和最外层圆形边框
  var drawSectorsBorder = CustomPaint(
    size: Size(containerSize, containerSize),
    painter: SectorBorderPainter(
      sectorCount: sectorCount,
      radius: radius,
      startDegree: startDegree,
      startIndex: state.startIndex,
      endIndex: state.endIndex,
    ),
  );

  // 绘制内外数字
  const double baseRadius = 40; // 基础半径
  var drawNumbers = List.generate(sectorCount, (sectorIndex) {
    // 计算扇区中心角度（从顶部开始顺时针）
    double centerDegree = eachSectorDegree * sectorIndex + startDegree + eachSectorDegree / 2;
    // 转换为极坐标角度（右侧为0，逆时针）
    double radians = (centerDegree) * math.pi / 180;
    // 计算旋转角度（使按钮朝向圆心）
    double rotation = radians + math.pi;

    return Stack(
      children: [
        // 在最外层显示序号
        Positioned(
          left: containerSize / 2 + (radius + 10) * math.cos(radians) - 5, // 调整位置
          top: containerSize / 2 + (radius + 10) * math.sin(radians) - 10, // 调整位置
          child: Transform.rotate(
            angle: rotation,
            child: Text('${sectorIndex + 1}', style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ),
        // 在最里层显示序号
        Positioned(
          left: containerSize / 2 + (baseRadius + 2) * math.cos(radians) - 5, // 调整位置
          top: containerSize / 2 + (baseRadius + 2) * math.sin(radians) - 10, // 调整位置
          child: Transform.rotate(
            angle: rotation,
            child: Text(
              '${sectorIndex + 1}',
              style: visibleSector(sectorIndex, state.startIndex, state.endIndex)
                  ? TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)
                  : TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  });

  // 中心按钮
  var drawCenterSwitch = GestureDetector(
    onTap: () => onCenterTap(),
    child: Tooltip(
      message: "starmap_point_center_hint".tr,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: Text(season.fmt, style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    ),
  );

  // 生成会议点
  var drawMeetingPoints = meetingPoints.map((point) {
    double sectorIndex = point.toDouble();
    double centerDegree = eachSectorDegree * sectorIndex + startDegree - 0.1 * (eachSectorDegree / 4);
    double radians = (centerDegree) * math.pi / 180;
    double x = radius * math.cos(radians);
    double y = radius * math.sin(radians);

    return Positioned(
      left: containerSize / 2 + x - meetingPointSize / 2, // 调整位置
      top: containerSize / 2 + y - meetingPointSize / 2, // 调整位置
      child: Tooltip(
        message: "starmap_point_conference_hint".tr,
        child: Container(
          width: meetingPointSize.toDouble(),
          height: meetingPointSize.toDouble(),
          decoration: BoxDecoration(color: Colors.lightGreen, shape: BoxShape.circle),
          child: Icon(Icons.bookmark, color: Colors.white, size: meetingPointSize / 1.5),
        ),
      ),
    );
  });

  // 生成X线索点
  var drawXcluePoints = xCluePoints.map((point) {
    double sectorIndex = point.toDouble();
    double centerDegree = eachSectorDegree * sectorIndex + startDegree - 0.1 * (eachSectorDegree / 4);
    double radians = (centerDegree) * math.pi / 180;
    double x = radius * math.cos(radians);
    double y = radius * math.sin(radians);

    return Positioned(
      left: containerSize / 2 + x - xCluePointSize / 2, // 调整位置
      top: containerSize / 2 + y - xCluePointSize / 2, // 调整位置
      child: Tooltip(
        message: "starmap_point_x_hint".tr,
        child: Container(
          width: xCluePointSize.toDouble(),
          height: xCluePointSize.toDouble(),
          decoration: BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
          child: Icon(Icons.close, color: Colors.white, size: xCluePointSize / 1.5),
        ),
      ),
    );
  });

  // 生成人员点
  var drawPersonPoints = personPoints.indexed.map((indexState) {
    int personIndex = indexState.$1;
    double sectorIndex = indexState.$2.location.index.toDouble();
    double sequenceIndex = indexState.$2.location.childIndex.toDouble();
    String name = indexState.$2.name;

    // 计算小点的角度（扇区起始角度 + 序列偏移）
    // 计算扇区起点角度（从顶部开始顺时针）
    double centerDegree = (startDegree + 2) + // 两边预留2度的空隙
        eachSectorDegree * (sectorIndex - 1) +
        (sequenceIndex - 0.5) * ((eachSectorDegree - 4) / 4);
    // 转换为极坐标角度（右侧为0，逆时针）
    double radians = (centerDegree) * math.pi / 180;

    // 计算小点的笛卡尔坐标
    double x = radius * math.cos(radians);
    double y = radius * math.sin(radians);

    return Positioned(
      left: containerSize / 2 + x - personPointSize / 2, // 调整位置
      top: containerSize / 2 + y - personPointSize / 2, // 调整位置
      child: Tooltip(
        message: name,
        child: Container(
          width: personPointSize.toDouble(),
          height: personPointSize.toDouble(),
          decoration: BoxDecoration(color: userIndexedColors[personIndex], shape: BoxShape.circle),
          child: Icon(Icons.person_rounded, color: Colors.white, size: personPointSize / 1.5),
        ),
      ),
    );
  });

  return [
    drawSectorsBorder,
    ...drawNumbers,
    drawCenterSwitch,
    ...drawMeetingPoints,
    ...drawXcluePoints,
    ...drawPersonPoints,
  ];
}

bool visibleSector(int sectorIndex, int visibleIndexStart, int visibleIndexEnd) {
  if (visibleIndexStart > visibleIndexEnd) {
    return sectorIndex + 1 >= visibleIndexStart || sectorIndex + 1 <= visibleIndexEnd;
  } else {
    return sectorIndex + 1 >= visibleIndexStart && sectorIndex + 1 <= visibleIndexEnd;
  }
}

class CircleBorderPainter extends CustomPainter {
  final double radius;
  final Color color;

  CircleBorderPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // 绘制圆形边框
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SectorBorderPainter extends CustomPainter {
  final int sectorCount;
  final double radius;
  final double startDegree;

  final int? startIndex;
  final int? endIndex;

  SectorBorderPainter({
    required this.sectorCount,
    required this.radius,
    required this.startDegree,
    this.startIndex,
    this.endIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // 绘制扇区边界线
    for (int i = 0; i < sectorCount; i++) {
      double angle = math.pi * (2 * i / sectorCount + startDegree / 180);
      // print('i: $i, angle: $angle, cos: ${math.cos(angle)}, sin: ${math.sin(angle)}');
      // 开始和结束的边界线画粗一点
      bool paintBlod = (startIndex != null && startIndex! == i + 1) || (endIndex != null && endIndex! == i);
      canvas.drawLine(
          center,
          Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)),
          Paint()
            ..color = paintBlod ? Colors.black : Colors.blueGrey
            ..strokeWidth = paintBlod ? 2 : 1
            ..style = PaintingStyle.stroke);
    }

    // 绘制最外层圆形边框
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
