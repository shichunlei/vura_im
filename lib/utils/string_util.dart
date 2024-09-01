import 'package:flutter/services.dart';
import 'package:vura/utils/toast_util.dart';

class StringUtil {
  static bool isEmpty(String? v) {
    return v == null || v.trim().isEmpty;
  }

  static bool isNotEmpty(String? str) {
    return null != str && '' != str && str.isNotEmpty;
  }

  static bool isDouble(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  static String getIndexStr(int index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  }

  static bool isNumber(String str) {
    RegExp reg = RegExp(r"\d");
    return reg.hasMatch(str);
  }

  static String numToString(int number) {
    return number < 1000
        ? "$number"
        : number > 9999
            ? "${(number / 10000).toStringAsPrecision(2)}万"
            : "${(number / 1000).toStringAsPrecision(2)}K";
  }

  /// 复制到剪粘板
  ///
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(text: "已复制到剪切版");
  }

  /// 字符串是否含有汉字
  static bool strHasZH(String str) {
    RegExp reg = RegExp(r"[\u4e00-\u9fa5]");
    return reg.hasMatch(str);
  }

  /// 校验邮箱格式
  ///
  static bool isEmail(String? email) {
    if (email == null) return false;
    Pattern pattern = r'\w[-\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\.)+[A-Za-z]{2,14}';
    RegExp regex = RegExp(pattern as String, caseSensitive: false, multiLine: false);
    return regex.hasMatch(email);
  }

  /// 手机号分割 15944443333 -> 155 4444 3333
  static String splitPhoneNumber(String src) {
    Pattern regex = RegExp(r'(1\w{2})(\w{4})(\w{4})');
    return src.replaceAllMapped(regex, (match) => '${match[1]} ${match[2]} ${match[3]}');
  }

  /// 手机号码中间4位替换成*
  ///
  /// [mobile] 手机号码 18601952581
  ///
  /// return 186****2581
  ///
  static String formatMobile(String? mobile) {
    if (isEmpty(mobile) || mobile!.length != 11) return (mobile ?? "");
    Pattern regex = RegExp(r'(1\w{2})(\w{4})(\w{4})');
    return mobile.replaceAllMapped(regex, (match) => '${match[1]}****${match[3]}');
  }

  static String truncateString(String input) {
    if (input.length <= 20) {
      return input;
    } else {
      return input.substring(0, 20);
    }
  }

  static String numToChinese(int num) {
    if (num == 0) return "零";

    List<String> units = ["", "十", "百", "千"];
    List<String> numChinese = ["", "万", "亿", "兆"];
    List<String> digits = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"];

    String result = '';
    int unitPos = 0; // 用于标识万、亿、兆等单位
    bool needZero = false;

    while (num > 0) {
      String part = '';
      int partNum = num % 10000;

      for (int i = 0; i < 4 && partNum > 0; i++) {
        int digit = partNum % 10;
        if (digit > 0) {
          part = digits[digit] + units[i] + part;
          needZero = true;
        } else {
          if (needZero) {
            part = digits[0] + part;
            needZero = false;
          }
        }
        partNum ~/= 10;
      }

      result = part + numChinese[unitPos] + result;
      unitPos++;
      num ~/= 10000;
    }

    // 处理数字10的特殊情况
    if (result.startsWith("一十")) {
      result = result.substring(1);
    }

    return result;
  }
}
