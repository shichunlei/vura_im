import 'package:flutter/material.dart';

class CustomLineChartView extends StatelessWidget {
  final List<LineChartModel> tempList;

  const CustomLineChartView({super.key, this.tempList = const []});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(double.infinity, double.infinity), painter: CustomLineChartPainter(tempList));
  }
}

class CustomLineChartPainter extends CustomPainter {
  final List<LineChartModel> tempList;

  late Paint linePaint, dotPaint, xLinePaint;

  late Gradient gradient;

  CustomLineChartPainter(this.tempList) {
    linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xffED6F55)
      ..strokeWidth = 2;

    xLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;

    dotPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double distance = width / tempList.length;
    drawXLine(canvas, height, width);

    // 画线
    drawLine(tempList, distance, height, canvas);

    // 画点
    drawDot(tempList, distance, height, canvas);
  }

  /// 画X轴
  void drawXLine(Canvas canvas, double height, double width) {
    canvas.drawLine(const Offset(0, 0), Offset(width, 0), xLinePaint);
    canvas.drawLine(Offset(0, height / 4), Offset(width, height / 4), xLinePaint);
    canvas.drawLine(Offset(0, height / 2), Offset(width, height / 2), xLinePaint);
    canvas.drawLine(Offset(0, 3 * height / 4), Offset(width, 3 * height / 4), xLinePaint);
    canvas.drawLine(Offset(0, height), Offset(width, height), xLinePaint);
  }

  void drawLine(List<LineChartModel> dots, double distance, double height, Canvas canvas) {
    for (int i = 0; i < dots.length - 1; i++) {
      double x = distance * i + distance / 2;

      canvas.drawLine(Offset(x, height - height / 4 * dots[i].value),
          Offset(x + distance, height - height / 4 * dots[i + 1].value), linePaint);
    }
  }

  void drawDot(List<LineChartModel> dots, double distance, double height, Canvas canvas) {
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;

      // 画点
      canvas.drawCircle(Offset(x, height - height / 4 * dots[i].value), 4, dotPaint..color = dots[i].color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartModel {
  int value;
  Color color;

  LineChartModel(this.value, this.color);
}
