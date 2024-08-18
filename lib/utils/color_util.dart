import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtil {
  static int parseColor(String? color) {
    if (color == null || color.isEmpty) {
      return 0xFFFFFFF;
    }
    color = color.replaceAll('#', '').trim();
    if (color.length == 8) {
      return int.parse('0x$color');
    } else {
      return int.parse('0xFF$color');
    }
  }

  static const Color color_999999 = Color(0xff999999);
  static const Color color_666666 = Color(0xff666666);
  static const Color color_333333 = Color(0xff333333);

  static const Color lineColor = Color(0xffEAEAEA);
  static const Color grayColor = Color(0xffC1C1C1);

  //设置颜色
  static Color getColor(String? value) {
    if (null == value || value == "") {
      return Colors.transparent;
    }
    var color = '0xFF$value';
    return Color(int.parse(color));
  }

  ///
  /// Converts the given [hex] color string to the corresponding int
  ///
  static int hexToInt(String hex) {
    if (hex.startsWith('#')) {
      hex = hex.replaceFirst('#', 'FF');
      return int.parse(hex, radix: 16);
    } else {
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return int.parse(hex, radix: 16);
    }
  }

  ///
  /// Converts the given integer [i] to a hex string with a leading #.
  ///
  static String intToHex(int i) {
    var s = i.toRadixString(16);
    if (s.length == 8) {
      return '#${s.substring(2).toUpperCase()}';
    } else {
      return '#${s.toUpperCase()}';
    }
  }

  /// 字符串转颜色
  ///
  /// [string] 字符串
  ///
  static Color strToColor(String string) {
    final int hash = string.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  /// 随机颜色
  ///
  static Color randomRGB() {
    return Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
  }

  static Color randomARGB() {
    Random random = Random();
    return Color.fromARGB(random.nextInt(180), random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}
