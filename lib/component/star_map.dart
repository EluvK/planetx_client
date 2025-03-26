import 'package:flutter/material.dart';
import 'dart:math' as math;

enum SectorStatus { confirm, doubt, deny }

extension SectorStatusExtension on SectorStatus {
  (Border, Color, BlendMode) get imageColor {
    switch (this) {
      case SectorStatus.confirm:
        return (Border.all(color: Colors.green), Colors.transparent, BlendMode.srcOver);
      case SectorStatus.doubt:
        return (Border.all(color: Colors.grey), Colors.grey.withAlpha(200), BlendMode.dstOut);
      case SectorStatus.deny:
        return (Border.all(color: Colors.transparent), Colors.black.withAlpha(10), BlendMode.srcIn);
    }
  }

  Text get label {
    switch (this) {
      case SectorStatus.confirm:
        return Text('确认');
      case SectorStatus.doubt:
        return Text('怀疑');
      case SectorStatus.deny:
        return Text('否定');
    }
  }
}

enum Season { spring, summer, autumn, winter }

extension SeasonExtension on Season {
  double get degree {
    switch (this) {
      case Season.spring:
        return 0;
      case Season.summer:
        return 90;
      case Season.autumn:
        return 180;
      case Season.winter:
        return 270;
    }
  }
}

class StarMap extends StatefulWidget {
  const StarMap({super.key});

  @override
  State<StarMap> createState() => _StarMapState();
}

class _StarMapState extends State<StarMap> {
  // 评审点 - 标准
  // 3 4.5
  // 6 4.5
  // 9 4.5
  // 12 4.5
  // X1 10 4.5

  // 评审点 - 大师
  // 3 4.5
  // 6 4.5
  // 9 4.5
  // 12 4.5
  // 15 4.5
  // 18 4.5
  // X1 7 4.5
  // X2 16 4.5

  List<Map<String, double>> activePoints = [
    {'sectorIndex': 1, 'sequenceIndex': 1},
    {'sectorIndex': 1, 'sequenceIndex': 2},
    {'sectorIndex': 1, 'sequenceIndex': 3},
    {'sectorIndex': 1, 'sequenceIndex': 4},
    {'sectorIndex': 3, 'sequenceIndex': 1},
    {'sectorIndex': 3, 'sequenceIndex': 2},
    {'sectorIndex': 3, 'sequenceIndex': 3},
    {'sectorIndex': 3, 'sequenceIndex': 4},
    {'sectorIndex': 6, 'sequenceIndex': 2},
    {'sectorIndex': 6, 'sequenceIndex': 4},
    {'sectorIndex': 11, 'sequenceIndex': 3},
    {'sectorIndex': 3, 'sequenceIndex': 5},
    {'sectorIndex': 6, 'sequenceIndex': 5},
    {'sectorIndex': 9, 'sequenceIndex': 5},
    {'sectorIndex': 12, 'sequenceIndex': 5},
  ];

  final sectorStatus = List.generate(18, (index) => List.generate(6, (index) => SectorStatus.doubt));

  SectorStatus targetSectorStatus = SectorStatus.confirm;

  int seasonIndex = 0;

  @override
  Widget build(BuildContext context) {
    var starMap = LayoutBuilder(
      builder: (context, constraints) {
        // 获取父容器的宽度和高度
        double parentSize = math.min(constraints.maxWidth, constraints.maxHeight);
        // 设置最小值
        double size = math.max(parentSize, 360);
        return CircleSectors(
          containerSize: size,
          season: Season.values[seasonIndex],
          activePoints: activePoints,
          sectorStatus: sectorStatus,
          onSectorTap: (sectorIndex, sequenceIndex) {
            print('扇区 $sectorIndex - 按钮 $sequenceIndex 被点击');
            setState(() {
              switch (targetSectorStatus) {
                case SectorStatus.confirm:
                  if (sectorStatus[sectorIndex][sequenceIndex] == SectorStatus.confirm) {
                    // 重置当前扇区的状态
                    sectorStatus[sectorIndex].fillRange(0, 6, SectorStatus.doubt);
                  } else {
                    // 重置当前扇区的状态
                    sectorStatus[sectorIndex].fillRange(0, 6, SectorStatus.deny);
                    sectorStatus[sectorIndex][sequenceIndex] = SectorStatus.confirm;
                  }
                  break;
                case SectorStatus.doubt:
                  sectorStatus[sectorIndex][sequenceIndex] = SectorStatus.doubt;
                  break;
                case SectorStatus.deny:
                  sectorStatus[sectorIndex][sequenceIndex] = SectorStatus.deny;
                  break;
              }
            });
          },
          onCenterTap: () {
            setState(() {
              seasonIndex = (seasonIndex + 1) % 4;
            });
          },
        );
      },
    );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          // 操作按钮
          Row(
            children: [
              Text('切换状态：'),
              SegmentedButton(
                segments: [for (var status in SectorStatus.values) ButtonSegment(value: status, label: status.label)],
                selected: {targetSectorStatus},
                onSelectionChanged: (Set<SectorStatus> newSelection) {
                  setState(() {
                    targetSectorStatus = newSelection.first;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
          starMap,
          // 星图
          // Expanded(
          //   child: starMap,
          // ),
        ],
      ),
    );
  }
}

class CircleSectors extends StatelessWidget {
  const CircleSectors({
    super.key,
    required this.containerSize,
    required this.season,
    required this.sectorStatus,
    required this.activePoints,
    required this.onSectorTap,
    required this.onCenterTap,
  });
  final double containerSize;
  final Season season;
  final List<Map<String, double>> activePoints;
  final List<List<SectorStatus>> sectorStatus;
  final void Function(int, int) onSectorTap;
  final void Function() onCenterTap;

  @override
  Widget build(BuildContext context) {
    // const double size = 1200; // 容器大小
    double radius = (containerSize - 30) / 2; // 圆半径
    double buttonSize = containerSize / 17; // 按钮大小
    const double baseRadius = 40; // 基础半径
    const int sectorCount = 12; // 等分数
    const int buttonsPerSector = 6; // 每个扇区的按钮数

    const double eachSectorDegree = 360 / sectorCount;
    double startDegree = season.degree;

    return Center(
      child: SizedBox(
        width: containerSize,
        height: containerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 绘制扇区边界线和最外层圆形边框
            CustomPaint(
              size: Size(containerSize, containerSize),
              painter: SectorBorderPainter(
                sectorCount: sectorCount,
                radius: radius,
                startDegree: startDegree,
              ),
            ),

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

            // 生成扇区和按钮
            ...List.generate(sectorCount, (sectorIndex) {
              // 计算扇区中心角度（从顶部开始顺时针）
              double centerDegree = eachSectorDegree * sectorIndex + startDegree + eachSectorDegree / 2;
              // 转换为极坐标角度（右侧为0，逆时针）
              double radians = (centerDegree) * math.pi / 180;
              // print('sectorIndex: $sectorIndex, centerDegree: $centerDegree, radians: $radians');
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
                                  buttonIndex,
                                  sectorIndex,
                                  sectorStatus[sectorIndex][buttonIndex],
                                )
                              : SizedBox(),
                        ),
                      ),
                    );
                  }),

                  // 在最里层显示序号
                  Positioned(
                    left: containerSize / 2 + (radius + 10) * math.cos(radians) - 5, // 调整位置
                    top: containerSize / 2 + (radius + 10) * math.sin(radians) - 10, // 调整位置
                    child: Transform.rotate(
                      angle: -rotation,
                      child: Text(
                        '${sectorIndex + 1}',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                  // 在最外层显示序号
                  Positioned(
                    left: containerSize / 2 + (baseRadius + 2) * math.cos(radians) - 5, // 调整位置
                    top: containerSize / 2 + (baseRadius + 2) * math.sin(radians) - 10, // 调整位置
                    child: Transform.rotate(
                      angle: -rotation,
                      child: Text(
                        '${sectorIndex + 1}',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              );
            }),

            // 中心按钮
            GestureDetector(
              onTap: () => onCenterTap(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    season.name,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),

            // 生成最外层的小点（根据传入的列表）
            ...activePoints.map((point) {
              double sectorIndex = point['sectorIndex']!;
              double sequenceIndex = point['sequenceIndex']!;

              // 计算小点的角度（扇区起始角度 + 序列偏移）
              // 计算扇区起点角度（从顶部开始顺时针）
              double centerDegree;
              if (sequenceIndex == 5) {
                centerDegree = eachSectorDegree * sectorIndex + startDegree - 0.1 * (eachSectorDegree / 4);
              } else {
                centerDegree = eachSectorDegree * (sectorIndex - 1) +
                    startDegree +
                    (sequenceIndex - 0.5) * ((eachSectorDegree - 4) / 4) +
                    2; // 预留2度的空隙
              }
              // 转换为极坐标角度（右侧为0，逆时针）
              double radians = (centerDegree) * math.pi / 180;

              // 计算小点的笛卡尔坐标
              double x = radius * math.cos(radians);
              double y = radius * math.sin(radians);

              return Positioned(
                left: containerSize / 2 + x - 5, // 调整位置
                top: containerSize / 2 + y - 5, // 调整位置
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Container xplanetIcon(double buttonSize, double rotation, int buttonIndex, int sectorIndex, SectorStatus status) {
    String iconName = '';
    switch (buttonIndex) {
      case 0:
        iconName = 'assets/icons/comet.png';
        break;
      case 1:
        iconName = 'assets/icons/asteroid.png';
        break;
      case 2:
        iconName = 'assets/icons/dwarf_planet.png';
        break;
      case 3:
        iconName = 'assets/icons/nebula.png';
        break;
      case 4:
        iconName = 'assets/icons/bracket.png';
        break;
      case 5:
        iconName = 'assets/icons/x.png';
        break;
      default:
        return Container();
    }

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
          iconName,
          width: buttonSize - 2,
          height: buttonSize - 2,
          color: status.imageColor.$2,
          colorBlendMode: status.imageColor.$3,
        ),
      ),
    );
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

  SectorBorderPainter({required this.sectorCount, required this.radius, required this.startDegree});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // 绘制扇区边界线
    for (int i = 0; i < sectorCount; i++) {
      double angle = math.pi * (2 * i / sectorCount + startDegree / 180);
      // print('i: $i, angle: $angle, cos: ${math.cos(angle)}, sin: ${math.sin(angle)}');
      canvas.drawLine(
        center,
        Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)),
        paint,
      );
    }

    // 绘制最外层圆形边框
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

bool isPrime(int n) {
  // hard code 1 to 20 prime
  if (n == 2 || n == 3 || n == 5 || n == 7 || n == 11 || n == 13 || n == 17 || n == 19) {
    return true;
  }
  return false;
}
