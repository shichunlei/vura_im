class StringUtil {
  static bool isEmpty(String? v) {
    return v == null || v.trim().isEmpty;
  }

  static bool isNotEmpty(String? str) {
    return null != str && '' != str && str.isNotEmpty;
  }

  /// 字符串是否含有汉字
  static bool strHasZH(String str) {
    RegExp reg = RegExp(r"[\u4e00-\u9fa5]");
    return reg.hasMatch(str);
  }

  static String formatPrice(double? price, {int fixed = 4}) {
    if (price == null) return "0";
    return price.toStringAsFixed(fixed).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  static String truncateString(String input) {
    if (input.length <= 20) {
      return input;
    } else {
      return input.substring(0, 20);
    }
  }

  static String truncateString2(String? text, {int maxLength = 12}) {
    if (text == null) return "";
    if (text.length <= maxLength) return text;
    int splitIndex = maxLength ~/ 2;
    return '${text.substring(0, splitIndex)}...${text.substring(text.length - splitIndex)}';
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
