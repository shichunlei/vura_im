import 'package:flutter/material.dart';

class RectIndicator extends StatelessWidget {
  final int position;
  final int count;
  final Color color;
  final Color activeColor;
  final double width;
  final double activeWidth;
  final double height;
  final double gap;

  const RectIndicator({
    super.key,
    this.width = 50.0,
    this.activeWidth = 50.0,
    this.height = 4,
    this.gap = 10,
    required this.position,
    required this.count,
    this.color = Colors.white,
    this.activeColor = const Color(0xFF3E4750),
  });

  _indicator(BuildContext context, bool isActive) {
    return AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: gap / 2),
        height: height,
        width: isActive ? activeWidth : width,
        decoration:
            BoxDecoration(color: isActive ? color : activeColor, borderRadius: BorderRadius.circular(height / 2.0)),
        duration: const Duration(milliseconds: 150));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            count, (index) => index == position ? _indicator(context, true) : _indicator(context, false)));
  }
}
