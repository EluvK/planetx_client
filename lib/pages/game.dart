import 'package:flutter/material.dart';
import 'dart:math' as math;

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const GameBody(),
    );
  }
}

class GameBody extends StatefulWidget {
  const GameBody({super.key});

  @override
  State<GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<GameBody> {
  @override
  Widget build(BuildContext context) {
    return CircleSectors();
  }
}

class CircleSectors extends StatelessWidget {
  const CircleSectors({super.key});

  @override
  Widget build(BuildContext context) {
    const double size = 600; // 容器大小
    const double radius = (size - 30) / 2; // 圆半径
    const double baseRadius = 50; // 基础半径
    const double buttonSize = size / 20; // 按钮大小
    const int sectorCount = 18; // 等分数
    const int buttonsPerSector = 5; // 每个扇区的按钮数

    const double eachSectorDegree = 360 / sectorCount;
    const double startDegree = 180; // 0/80/180/260

    final List<Map<String, int>> activePoints = [
      {'sectorIndex': 1, 'sequenceIndex': 1}, // 扇区 1，序列 1
      {'sectorIndex': 1, 'sequenceIndex': 2}, // 扇区 1，序列 1
      {'sectorIndex': 1, 'sequenceIndex': 3}, // 扇区 1，序列 1
      {'sectorIndex': 1, 'sequenceIndex': 4}, // 扇区 1，序列 1
      {'sectorIndex': 3, 'sequenceIndex': 3}, // 扇区 3，序列 3
      {'sectorIndex': 6, 'sequenceIndex': 2}, // 扇区 6，序列 2
      {'sectorIndex': 6, 'sequenceIndex': 4}, // 扇区 6，序列 2
      // 添加更多点...
    ];

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 绘制扇区边界线和最外层圆形边框
            CustomPaint(
              size: Size(size, size),
              painter: SectorBorderPainter(
                sectorCount: sectorCount,
                radius: radius,
              ),
            ),

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
                      left: size / 2 + x - buttonSize / 2,
                      top: size / 2 + y - buttonSize / 2,
                      child: Transform.rotate(
                        angle: rotation,
                        child: GestureDetector(
                          onTap: () => print('扇区 ${sectorIndex + 1} - 按钮 ${buttonIndex + 1} 被点击'),
                          child: (buttonIndex != 0 || isPrime(sectorIndex + 1))
                              ? Container(
                                  width: buttonSize,
                                  height: buttonSize,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Center(
                                    // 调整文本旋转以保持正向
                                    child: Transform.rotate(
                                      angle: -rotation,
                                      child: Text(
                                        '${sectorIndex + 1}-${buttonIndex + 1}',
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
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
                    left: size / 2 + (radius + 10) * math.cos(radians) - 5, // 调整位置
                    top: size / 2 + (radius + 10) * math.sin(radians) - 10, // 调整位置
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
              int sectorIndex = point['sectorIndex']!;
              int sequenceIndex = point['sequenceIndex']!;

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
                left: size / 2 + x - 5, // 调整位置
                top: size / 2 + y - 5, // 调整位置
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
