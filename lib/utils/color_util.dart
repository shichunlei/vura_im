import 'package:flutter/material.dart';

class ColorUtil {
  static const Color mainColor = Color(0xff83C240);

  static const Color color_999999 = Color(0xff999999);
  static const Color color_666666 = Color(0xff666666);
  static const Color color_333333 = Color(0xff333333);

  static const Color lineColor = Color(0xfff5f5f5);
  static const Color grayColor = Color(0xffC1C1C1);

  /// 字符串转颜色
  ///
  /// [string] 字符串
  ///
  static Color strToColor(String string) {
    final int hash = string.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }
}
