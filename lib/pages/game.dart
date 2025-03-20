import 'package:flutter/material.dart';
import 'dart:math' as math;

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: const GameBody(),
      ),
    );
  }
}

class GameBody extends StatefulWidget {
  const GameBody({super.key});

  @override
  State<GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<GameBody> {
  List<Map<String, double>> activePoints = [
    {'sectorIndex': 1, 'sequenceIndex': 0.5},
    {'sectorIndex': 1, 'sequenceIndex': 1},
    {'sectorIndex': 1, 'sequenceIndex': 2},
    {'sectorIndex': 1, 'sequenceIndex': 3},
    {'sectorIndex': 1, 'sequenceIndex': 4},
    {'sectorIndex': 1, 'sequenceIndex': 4.5},
    {'sectorIndex': 3, 'sequenceIndex': 3},
    {'sectorIndex': 11, 'sequenceIndex': 3},
    {'sectorIndex': 6, 'sequenceIndex': 2},
    {'sectorIndex': 6, 'sequenceIndex': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 获取父容器的宽度和高度
        double parentSize = math.min(constraints.maxWidth, constraints.maxHeight);
        // 设置最小值为 440
        double size = math.max(parentSize, 440);
        return CircleSectors(
          containerSize: size,
          activePoints: activePoints,
        );
      },
    );
  }
}

class CircleSectors extends StatelessWidget {
  const CircleSectors({
    super.key,
    required this.containerSize,
    required this.activePoints,
  });
  final double containerSize;
  final List<Map<String, double>> activePoints;

  @override
  Widget build(BuildContext context) {
    // const double size = 1200; // 容器大小
    double radius = (containerSize - 30) / 2; // 圆半径
    double buttonSize = containerSize / 17; // 按钮大小
    const double baseRadius = 50; // 基础半径
    const int sectorCount = 18; // 等分数
    const int buttonsPerSector = 6; // 每个扇区的按钮数

    const double eachSectorDegree = 360 / sectorCount;
    const double startDegree = 180; // 0/80/180/260

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
              double radians = (centerDegree - 90) * math.pi / 180;
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
                          onTap: () => print('扇区 ${sectorIndex + 1} - 按钮 ${buttonIndex + 1} 被点击'),
                          child: (buttonIndex != 0 || isPrime(sectorIndex + 1))
                              ? Container(
                                  width: buttonSize,
                                  height: buttonSize,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3), // 更浅的颜色
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Center(
                                    // 调整文本旋转以保持正向
                                    child: Transform.rotate(
                                      angle: -rotation,
                                      child: xplanetIcon(buttonIndex, size: buttonSize - 2),
                                      // child: Icon(Icons.bra, color: Colors.blue, size: buttonSize - 2),
                                      // Text(
                                      //   '${sectorIndex + 1}-${buttonIndex + 1}',
                                      //   style: TextStyle(color: Colors.white, fontSize: 10),
                                      // ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ),
                    );
                  }),

                  // 在最外层显示序号
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
                ],
              );
            }),

            // 中心按钮
            GestureDetector(
              onTap: () => print('中心按钮被点击'),
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
                    '中心',
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
              double centerDegree = 20 * (sectorIndex - 1) + startDegree;
              // 转换增加偏移量
              centerDegree += (sequenceIndex - 0.5) * (eachSectorDegree / 4);
              // 转换为极坐标角度（右侧为0，逆时针）
              double radians = (centerDegree - 90) * math.pi / 180;

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

  xplanetIcon(int buttonIndex, {double size = 30}) {
    switch (buttonIndex) {
      case 0:
        return Image.asset('assets/icons/comet.png', width: size, height: size);
      case 1:
        return Image.asset('assets/icons/asteroid.png', width: size, height: size);
      case 2:
        return Image.asset('assets/icons/dwarf_planet.png', width: size, height: size);
      case 3:
        return Image.asset('assets/icons/nebula.png', width: size, height: size);
      case 4:
        return Image.asset('assets/icons/bracket.png', width: size, height: size);
      case 5:
        return Image.asset('assets/icons/x.png', width: size, height: size);
      default:
        return SizedBox();
    }
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

  SectorBorderPainter({required this.sectorCount, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // 绘制扇区边界线
    for (int i = 0; i < sectorCount; i++) {
      double angle = 2 * math.pi * (i + 0.5) / sectorCount;
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
