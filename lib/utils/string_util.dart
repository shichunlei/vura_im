class StringUtil {
  static bool isEmpty(String? v) {
    return v == null || v.trim().isEmpty;
  }

  static bool isNotEmpty(String? str) {
    return null != str && '' != str && str.isNotEmpty;
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
}
