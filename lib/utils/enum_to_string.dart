import 'package:collection/collection.dart';

import 'string_util.dart';

/// A Calculator.
class EnumToString {
  static String? parse(enumItem) {
    if (enumItem == null) return null;
    return enumItem.toString().split('.')[1];
  }

  static T? fromString<T>(List<T> enumValues, String? value, {T? defaultValue}) {
    if (StringUtil.isEmpty(value)) return defaultValue;
    if (enumValues.every((item) => EnumToString.parse(item) != value)) return defaultValue;
    return enumValues.singleWhereOrNull((enumItem) => EnumToString.parse(enumItem) == value);
  }
}
