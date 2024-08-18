import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiColorRing extends StatelessWidget {
  final double honePercentage;
  final double zouPercentage;
  final double heiPercentage;

  const MultiColorRing({super.key, this.honePercentage = .0, this.zouPercentage = .0, this.heiPercentage = .0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CustomPaint(
            painter: MultiColorRingPainter(
                honePercentage: honePercentage, zouPercentage: zouPercentage, heiPercentage: heiPercentage),
            size: const Size(double.infinity, double.infinity)));
  }
}

class MultiColorRingPainter extends CustomPainter {
  final double honePercentage;
  final double zouPercentage;
  final double heiPercentage;

  MultiColorRingPainter({this.honePercentage = .0, this.zouPercentage = .0, this.heiPercentage = .0});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double ringWidth = 6.r; // 圆环的宽度

    // 计算圆的半径
    final double radius = min(width, height) / 2 - ringWidth;
    // 创建一个路径
    final Path path = Path();

    // 绘制圆环的路径
    path.addArc(Rect.fromCircle(center: Offset(width / 2, height / 2), radius: radius), -pi / 2, pi * 2);

    // 绘制“红”部分
    final Paint redPaint = Paint()
      ..color = const Color(0xffED6F55)
      ..style = PaintingStyle.stroke // 设置为描边样式
      ..strokeWidth = ringWidth;
    canvas.drawPath(path, redPaint);

    // 更新路径，绘制“走”部分
    path.reset();
    path.addArc(Rect.fromCircle(center: Offset(width / 2, height / 2), radius: radius),
        -pi / 2 + (pi * 2 * honePercentage), pi * 2 * zouPercentage);
    final Paint bluePaint = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;
    canvas.drawPath(path, bluePaint);

    // 更新路径，绘制“黑”部分
    path.reset();
    path.addArc(Rect.fromCircle(center: Offset(width / 2, height / 2), radius: radius),
        -pi / 2 + (pi * 2 * honePercentage) + (pi * 2 * zouPercentage), pi * 2 * heiPercentage);
    final Paint greenPaint = Paint()
      ..color = const Color(0xff7E7E7E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;
    canvas.drawPath(path, greenPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
