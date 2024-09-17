/// DateFormat.
enum DateFormat {
  DEFAULT, //yyyy-MM-dd HH:mm:ss.SSS
  NORMAL, //yyyy-MM-dd HH:mm:ss
  YEAR_MONTH_DAY_HOUR_MINUTE, //yyyy-MM-dd HH:mm
  YEAR_MONTH_DAY, //yyyy-MM-dd
  YEAR_MONTH, //yyyy-MM
  MONTH_DAY, //MM-dd
  DAY, //dd
  MONTH_DAY_HOUR_MINUTE, //MM-dd HH:mm
  HOUR_MINUTE_SECOND, //HH:mm:ss
  HOUR_MINUTE, //HH:mm
  MINUTE_SECOND, //mm:ss

  ZH_DEFAULT, //yyyy年MM月dd日 HH时mm分ss秒SSS毫秒
  ZH_NORMAL, //yyyy年MM月dd日 HH时mm分ss秒  /  timeSeparate: ":" --> yyyy年MM月dd日 HH:mm:ss
  ZH_YEAR_MONTH_DAY_HOUR_MINUTE, //yyyy年MM月dd日 HH时mm分  /  timeSeparate: ":" --> yyyy年MM月dd日 HH:mm
  ZH_YEAR_MONTH_DAY, //yyyy年MM月dd日
  ZH_YEAR_MONTH, //yyyy年MM月
  ZH_MONTH_DAY, //MM月dd日
  ZH_MONTH_DAY_HOUR_MINUTE, //MM月dd日 HH时mm分  /  timeSeparate: ":" --> MM月dd日 HH:mm
  ZH_HOUR_MINUTE_SECOND, //HH时mm分ss秒
  ZH_HOUR_MINUTE, //HH时mm分
}

/// 一些常用格式参照。可以自定义格式，例如："yyyy/MM/dd HH:mm:ss"，"yyyy/M/d HH:mm:ss"。
/// 格式要求
/// year -> yyyy/yy   month -> MM/M    day -> dd/d
/// hour -> HH/H      minute -> mm/m   second -> ss/s
class DataFormats {
  static const String DEFAULT = "yyyy-MM-dd HH:mm:ss.SSS";
  static const String NORMAL = "yyyy-MM-dd HH:mm:ss";
  static const String YEAR_MONTH_DAY_HOUR_MINUTE = "yyyy-MM-dd HH:mm";
  static const String YEAR_MONTH_DAY = "yyyy-MM-dd";
  static const String YEAR_MONTH = "yyyy-MM";
  static const String MONTH_DAY = "MM-dd";
  static const String DAY = "dd";
  static const String MONTH_DAY_HOUR_MINUTE = "MM-dd HH:mm";
  static const String HOUR_MINUTE_SECOND = "HH:mm:ss";
  static const String HOUR_MINUTE = "HH:mm";

  static const String ZH_DEFAULT = "yyyy年MM月dd日 HH时mm分ss秒SSS毫秒";
  static const String ZH_NORMAL = "yyyy年MM月dd日 HH时mm分ss秒";
  static const String ZH_YEAR_MONTH_DAY_HOUR_MINUTE = "yyyy年MM月dd日 HH时mm分";
  static const String ZH_YEAR_MONTH_DAY = "yyyy年MM月dd日";
  static const String ZH_YEAR_MONTH = "yyyy年MM月";
  static const String ZH_MONTH_DAY = "MM月dd日";
  static const String ZH_MONTH_DAY_HOUR_MINUTE = "MM月dd日 HH时mm分";
  static const String ZH_HOUR_MINUTE_SECOND = "HH时mm分ss秒";
  static const String ZH_HOUR_MINUTE = "HH时mm分";

  static const String LINE_YEAR_MONTH_DAY_HOUR_MINUTE = "yyyy/MM/dd HH:mm";
  static const String LINE_YEAR_MONTH_DAY = "yyyy/MM/dd";
  static const String LINE_YEAR_MONTH = "yyyy/MM";
  static const String LINE_MONTH_DAY = "MM/dd";
  static const String LINE_MONTH_DAY_HOUR_MINUTE = "MM/dd HH:mm";

  static const String POINT_YEAR_MONTH_DAY = "yyyy.MM.dd";
  static const String POINT_YEAR_MONTH = "yyyy.MM";
  static const String POINT_MONTH_DAY = "MM.dd";
  static const String POINT_MONTH_DAY_HOUR_MINUTE = "MM.dd HH:mm";
}

/// month->days.
const Map<int, int> MONTH_DAY = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

/// Date Util.
class DateUtil {
  static const List<String> ZH_LONG_WEEKDAY_LIST = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];

  /// get DateTime By Milliseconds.
  static DateTime getDateTimeByMs(int? milliseconds, {bool isUtc = false}) {
    if (milliseconds == null) return DateTime.now();
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
  }

  /// get DateStr By Milliseconds.
  /// milliseconds    milliseconds.
  /// format          DateFormat type.
  /// dateSeparate    date separate.
  /// timeSeparate    time separate.
  static String? getDateStrByMs(int? milliseconds,
      {DateFormat format = DateFormat.NORMAL, String? dateSeparate, String? timeSeparate, bool isUtc = false}) {
    DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getDateStrByDateTime(dateTime, format: format, dateSeparate: dateSeparate, timeSeparate: timeSeparate);
  }

  /// get DateStr By DateTime.
  /// dateTime        dateTime.
  /// format          DateFormat type.
  /// dateSeparate    date separate.
  /// timeSeparate    time separate.
  static String? getDateStrByDateTime(DateTime? dateTime,
      {DateFormat format = DateFormat.NORMAL, String? dateSeparate, String? timeSeparate}) {
    if (dateTime == null) return null;
    String dateStr = dateTime.toString();
    if (isZHFormat(format)) {
      dateStr = formatZHDateTime(dateStr, format, timeSeparate);
    } else {
      dateStr = formatDateTime(dateStr, format, dateSeparate, timeSeparate);
    }
    return dateStr;
  }

  /// format ZH DateTime.
  /// time            time string.
  /// format          DateFormat type.
  ///timeSeparate    time separate.
  static String formatZHDateTime(String time, DateFormat format, String? timeSeparate) {
    time = convertToZHDateTimeString(time, timeSeparate);
    switch (format) {
      case DateFormat.ZH_NORMAL: //yyyy年MM月dd日 HH时mm分ss秒
        time =
            time.substring(0, "yyyy年MM月dd日 HH时mm分ss秒".length - (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case DateFormat.ZH_YEAR_MONTH_DAY_HOUR_MINUTE: //yyyy年MM月dd日 HH时mm分
        time = time.substring(0, "yyyy年MM月dd日 HH时mm分".length - (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case DateFormat.ZH_YEAR_MONTH_DAY: //yyyy年MM月dd日
        time = time.substring(0, "yyyy年MM月dd日".length);
        break;
      case DateFormat.ZH_YEAR_MONTH: //yyyy年MM月
        time = time.substring(0, "yyyy年MM月".length);
        break;
      case DateFormat.ZH_MONTH_DAY: //MM月dd日
        time = time.substring("yyyy年".length, "yyyy年MM月dd日".length);
        break;
      case DateFormat.ZH_MONTH_DAY_HOUR_MINUTE: //MM月dd日 HH时mm分
        time = time.substring(
            "yyyy年".length, "yyyy年MM月dd日 HH时mm分".length - (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case DateFormat.ZH_HOUR_MINUTE_SECOND: //HH时mm分ss秒
        time = time.substring("yyyy年MM月dd日 ".length,
            "yyyy年MM月dd日 HH时mm分ss秒".length - (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case DateFormat.ZH_HOUR_MINUTE: //HH时mm分
        time = time.substring("yyyy年MM月dd日 ".length,
            "yyyy年MM月dd日 HH时mm分".length - (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      default:
        break;
    }
    return time;
  }

  /// format DateTime.
  /// time            time string.
  /// format          DateFormat type.
  /// dateSeparate    date separate.
  /// timeSeparate    time separate.
  static String formatDateTime(String time, DateFormat format, String? dateSeparate, String? timeSeparate) {
    switch (format) {
      case DateFormat.NORMAL: //yyyy-MM-dd HH:mm:ss
        time = time.substring(0, "yyyy-MM-dd HH:mm:ss".length);
        break;
      case DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE: //yyyy-MM-dd HH:mm
        time = time.substring(0, "yyyy-MM-dd HH:mm".length);
        break;
      case DateFormat.YEAR_MONTH_DAY: //yyyy-MM-dd
        time = time.substring(0, "yyyy-MM-dd".length);
        break;
      case DateFormat.YEAR_MONTH: //yyyy-MM
        time = time.substring(0, "yyyy-MM".length);
        break;
      case DateFormat.MONTH_DAY: //MM-dd
        time = time.substring("yyyy-".length, "yyyy-MM-dd".length);
        break;
      case DateFormat.DAY: //MM-dd
        time = time.substring("yyyy-MM-".length, "yyyy-MM-dd".length);
        break;
      case DateFormat.MONTH_DAY_HOUR_MINUTE: //MM-dd HH:mm
        time = time.substring("yyyy-".length, "yyyy-MM-dd HH:mm".length);
        break;
      case DateFormat.HOUR_MINUTE_SECOND: //HH:mm:ss
        time = time.substring("yyyy-MM-dd ".length, "yyyy-MM-dd HH:mm:ss".length);
        break;
      case DateFormat.HOUR_MINUTE: //HH:mm
        time = time.substring("yyyy-MM-dd ".length, "yyyy-MM-dd HH:mm".length);
        break;
      case DateFormat.MINUTE_SECOND: //mm:ss
        time = time.substring("yyyy-MM-dd HH:".length, "yyyy-MM-dd HH:mm:ss".length);
        break;
      default:
        break;
    }
    time = dateTimeSeparate(time, dateSeparate, timeSeparate);
    return time;
  }

  /// is format to ZH DateTime String
  static bool isZHFormat(DateFormat format) {
    return format == DateFormat.ZH_DEFAULT ||
        format == DateFormat.ZH_NORMAL ||
        format == DateFormat.ZH_YEAR_MONTH_DAY_HOUR_MINUTE ||
        format == DateFormat.ZH_YEAR_MONTH_DAY ||
        format == DateFormat.ZH_YEAR_MONTH ||
        format == DateFormat.ZH_MONTH_DAY ||
        format == DateFormat.ZH_MONTH_DAY_HOUR_MINUTE ||
        format == DateFormat.ZH_HOUR_MINUTE_SECOND ||
        format == DateFormat.ZH_HOUR_MINUTE;
  }

  /// convert To ZH DateTime String
  static String convertToZHDateTimeString(String time, String? timeSeparate) {
    time = time.replaceFirst("-", "年");
    time = time.replaceFirst("-", "月");
    time = time.replaceFirst(" ", "日 ");
    if (timeSeparate == null || timeSeparate.isEmpty) {
      time = time.replaceFirst(":", "时");
      time = time.replaceFirst(":", "分");
      time = time.replaceFirst(".", "秒");
      time = "$time毫秒";
    } else {
      time = time.replaceAll(":", timeSeparate);
    }
    return time;
  }

  /// date Time Separate.
  static String dateTimeSeparate(String time, String? dateSeparate, String? timeSeparate) {
    if (dateSeparate != null) {
      time = time.replaceAll("-", dateSeparate);
    }
    if (timeSeparate != null) {
      time = time.replaceAll(":", timeSeparate);
    }
    return time;
  }

  /// get ZH WeekDay.
  static String? getZHLongWeekDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday = ZH_LONG_WEEKDAY_LIST[dateTime.weekday - 1];
    return weekday;
  }

  /// Return whether it is leap year.
  /// 是否为闰年
  static bool isLeapYearByYear(int year) {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
  }

  /// is yesterday by millis.
  /// 是否是昨天.
  static bool isYesterdayByMillis(int millis) {
    return isYesterday(DateTime.fromMillisecondsSinceEpoch(millis));
  }

  /// is yesterday by dateTime.
  /// 是否是昨天.
  static bool isYesterday(DateTime dateTime) {
    DateTime locDateTime = DateTime.now();

    if (yearIsEqual(dateTime, locDateTime)) {
      int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYear(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int days = dateTime.day;
    for (int i = 1; i < month; i++) {
      days = days + MONTH_DAY[i]!;
    }
    if (isLeapYearByYear(year) && month > 2) {
      days = days + 1;
    }
    return days;
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

  static bool isSameYear(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds).year == DateTime.now().year;
  }

  /// is today.
  /// 是否是当天.
  static bool isToday(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == 0) return false;
    DateTime old = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    return isTodayByDateTime(old, isUtc: isUtc);
  }

  /// is today.
  /// 是否是当天.
  static bool isTodayByDateTime(DateTime date, {bool isUtc = false}) {
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// is Week.
  /// 是否是本周.
  static bool isWeek(int milliseconds, {bool isUtc = false}) {
    if (milliseconds <= 0) {
      return false;
    }
    DateTime oOld = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime nNow = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    DateTime old = nNow.millisecondsSinceEpoch > oOld.millisecondsSinceEpoch ? oOld : nNow;
    DateTime now = nNow.millisecondsSinceEpoch > oOld.millisecondsSinceEpoch ? nNow : oOld;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <= 7 * 24 * 60 * 60 * 1000);
  }

  static String getWechatTime(int duration) {
    if (isToday(duration)) {
      return getDateStrByMs(duration, format: DateFormat.HOUR_MINUTE)!;
    }
    if (isYesterdayByMillis(duration)) {
      return "昨天 ${getDateStrByMs(duration, format: DateFormat.HOUR_MINUTE)}";
    }
    if (isWeek(duration)) {
      return "${getZHLongWeekDay(DateTime.fromMillisecondsSinceEpoch(duration))} ${getDateStrByMs(duration, format: DateFormat.HOUR_MINUTE)}";
    }
    if (isSameYear(duration)) {
      return getDateStrByMs(duration, format: DateFormat.MONTH_DAY_HOUR_MINUTE)!;
    }

    return getDateStrByMs(duration, format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE)!;
  }

  static String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours时$minutes分$seconds秒';
    }
    if (minutes > 0) {
      return '$minutes分$seconds秒';
    }
    return '$seconds秒';
  }

  static String timeAgo(int timestamp) {
    DateTime now = DateTime.now();
    DateTime givenTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration diff = now.difference(givenTime);

    if (diff.inDays > 0) {
      return '${diff.inDays}天前';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}小时前';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
