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
  static const List<String> MONTH_LIST = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  static const List<String> WEEKDAY_LIST = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];

  static const List<String> EN_WEEKDAY_LIST = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static const List<String> SHORT_WEEKDAY_LIST = ["M", "T", "W", "T", "F", "S", "S"];

  static const List<String> ZH_LONG_WEEKDAY_LIST = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];

  static const List<String> ZH_WEEKDAY_LIST = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  static const List<String> ZH_SHORT_WEEKDAY_LIST = ["一", "二", "三", "四", "五", "六", "日"];

  static const List<String> MONTH_ZH_LIST = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];

  static const List<String> MONTH_NUM_LIST = [
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月'
  ];

  /// get DateTime By DateStr.
  static DateTime? getDateTime(String dateStr, {bool? isUtc}) {
    DateTime? dateTime = DateTime.tryParse(dateStr);
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime!.toUtc();
      } else {
        dateTime = dateTime!.toLocal();
      }
    }
    return dateTime;
  }

  /// get DateTime By Milliseconds.
  static DateTime getDateTimeByMs(int? milliseconds, {bool isUtc = false}) {
    if (milliseconds == null) return DateTime.now();
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
  }

  /// get DateMilliseconds By DateStr.
  static int getDateMsByTimeStr(String dateStr, {bool isUtc = false}) {
    DateTime dateTime = DateTime.parse(dateStr);
    if (isUtc) {
      dateTime = dateTime.toUtc();
    } else {
      dateTime = dateTime.toLocal();
    }
    return dateTime.millisecondsSinceEpoch;
  }

  /// get Now Date Milliseconds.
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// get Now Date Str.(yyyy-MM-dd HH:mm:ss)
  static String? getNowDateStr() {
    return getDateStrByDateTime(DateTime.now());
  }

  /// get DateStr By DateStr.
  /// dateStr         date String.
  /// format          DateFormat type.
  /// dateSeparate    date separate.
  /// timeSeparate    time separate.
  static String? getDateStrByTimeStr(String dateStr,
      {DateFormat format = DateFormat.NORMAL, String? dateSeparate, String? timeSeparate, bool? isUtc}) {
    return getDateStrByDateTime(getDateTime(dateStr, isUtc: isUtc),
        format: format, dateSeparate: dateSeparate, timeSeparate: timeSeparate);
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

  /// format date by milliseconds.
  /// milliseconds 日期毫秒
  static String formatDateMs(int? milliseconds, {bool isUtc = false, String? format}) {
    return formatDate(getDateTimeByMs(milliseconds, isUtc: isUtc), format: format);
  }

  /// format date by date str.
  /// dateStr 日期字符串
  static String formatDateStr(String dateStr, {bool? isUtc, String? format}) {
    return formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);
  }

  /// format date by DateTime.
  /// format 转换格式(已提供常用格式 DataFormats，可以自定义格式："yyyy/MM/dd HH:mm:ss")
  /// 格式要求
  /// year -> yyyy/yy   month -> MM/M    day -> dd/d
  /// hour -> HH/H      minute -> mm/m   second -> ss/s
  static String formatDate(DateTime? dateTime, {bool? isUtc, String? format}) {
    if (dateTime == null) return "";
    format = format ?? DataFormats.NORMAL;
    if (format.contains("yy")) {
      String year = dateTime.year.toString();
      if (format.contains("yyyy")) {
        format = format.replaceAll("yyyy", year);
      } else {
        format = format.replaceAll("yy", year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  /// com format.
  static String _comFormat(int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format = format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  /// get WeekDay By Milliseconds.
  static String? getWeekDayByMs(int? milliseconds, {bool isUtc = false}) {
    DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getWeekDay(dateTime);
  }

  /// get WeekDay By DateStr.
  static String? getWeekDayByDateStr(String date, {bool isUtc = false}) {
    DateTime? dateTime = getDateTime(date, isUtc: isUtc);
    return getWeekDay(dateTime);
  }

  /// get ZH WeekDay By Milliseconds.
  static String? getZHWeekDayByMs(int? milliseconds, {bool isUtc = false}) {
    DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getZHLongWeekDay(dateTime);
  }

  /// get ZH WeekDay By DateStr.
  static String? getZHWeekDayByDateStr(String date, {bool isUtc = false, int type = 0}) {
    DateTime? dateTime = getDateTime(date, isUtc: isUtc);
    if (type == 0) {
      return getZHLongWeekDay(dateTime);
    } else if (type == 2) {
      return getZHWeekDay(dateTime);
    } else {
      return getWeekDayNum(dateTime);
    }
  }

  /// get WeekDay.
  static String? getWeekDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday = EN_WEEKDAY_LIST[dateTime.weekday - 1];
    return weekday;
  }

  /// get WeekDay.
  static String getWeekDay2(DateTime dateTime) {
    String weekday = WEEKDAY_LIST[dateTime.weekday - 1];

    return weekday;
  }

  /// get ZH WeekDay.
  static String? getZHLongWeekDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday = ZH_LONG_WEEKDAY_LIST[dateTime.weekday - 1];
    return weekday;
  }

  /// get ZH WeekDay.
  static String? getZHWeekDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday = ZH_WEEKDAY_LIST[dateTime.weekday - 1];
    return weekday;
  }

  static String? getWeekDayNum(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday = ZH_SHORT_WEEKDAY_LIST[dateTime.weekday - 1];
    return weekday;
  }

  /// Return whether it is leap year.
  /// 是否为闰年
  static bool isLeapYearByDateTime(DateTime dateTime) {
    return isLeapYearByYear(dateTime.year);
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
  static int getDayOfYearByMillis(int millis, {bool isUtc = false}) {
    return getDayOfYear(DateTime.fromMillisecondsSinceEpoch(millis, isUtc: isUtc));
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
  static bool yearIsEqualByMillis(int millis, int locMillis) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(millis), DateTime.fromMillisecondsSinceEpoch(locMillis));
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

  /// 是否为同一天
  static bool isEqualDay(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month && dateTime1.day == dateTime2.day) {
      return true;
    } else {
      return false;
    }
  }

  /// 是否为同一天
  static bool isEqualDayByMs(int? milliseconds1, int? milliseconds2) {
    if (milliseconds1 == null || milliseconds2 == null) return false;
    return isEqualDay(
        DateTime.fromMillisecondsSinceEpoch(milliseconds1), DateTime.fromMillisecondsSinceEpoch(milliseconds2));
  }

  /// 是否为同一天
  static bool isEqualDayByMsAndDateTime(DateTime dateTime, int? milliseconds) {
    if (milliseconds == null) return false;
    return isEqualDay(dateTime, DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }

  /// 是否为同一天
  static bool isEqualMouth(DateTime dateTime, DateTime dateTime2) {
    return dateTime.year == dateTime2.year && dateTime2.month == dateTime.month;
  }

  static bool isAtSameMomentAs(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day &&
        dateTime1.hour == dateTime2.hour &&
        dateTime1.minute == dateTime2.minute) {
      return true;
    } else {
      return false;
    }
  }

  /// 是否过期
  static bool isExpired(String dateStr) {
    return getNowDateMs() > getDateMsByTimeStr(dateStr);
  }

  /// 获取指定日期所在周的第一天
  static DateTime getWeekFirstDay({DateTime? currentDate, bool firstDayOfWeekIsMonday = true}) {
    currentDate ??= DateTime.now();

    if (firstDayOfWeekIsMonday) {
      // 计算日期与本周第一天之间的天数差
      int daysSinceMonday = currentDate.weekday - DateTime.monday;

      // 如果日期已经是周一，则直接返回
      if (daysSinceMonday == 0) {
        return currentDate;
      }

      // 否则，减去天数差以获取本周第一天
      return currentDate.subtract(Duration(days: daysSinceMonday));
    } else {
      int dayOfWeek = currentDate.weekday;

      // 如果日期已经是周日，则直接返回
      if (dayOfWeek == DateTime.sunday) {
        return currentDate;
      }

      return currentDate.subtract(Duration(days: dayOfWeek));
    }
  }

  /// 获取指定日期所在周的最后一天，如果一周第一天是周一，则最后一天为周日，如果第一天为周日，则最后一天为周六
  static DateTime getWeekEndDay({DateTime? currentDate, bool firstDayOfWeekIsMonday = true}) {
    currentDate ??= DateTime.now();

    if (firstDayOfWeekIsMonday) {
      // 计算日期与本周周日之间的天数差
      int daysUntilSunday = DateTime.sunday - currentDate.weekday;

      // 如果日期已经是周日，则直接返回
      if (daysUntilSunday == 0) {
        return currentDate;
      }

      // 否则，加上天数差以获取本周周日的日期
      return currentDate.add(Duration(days: daysUntilSunday));
    } else {
      int dayOfWeek = currentDate.weekday;

      // 如果日期已经是周六，则直接返回
      if (dayOfWeek == DateTime.saturday) {
        return currentDate;
      }

      if (dayOfWeek == DateTime.sunday) {
        return currentDate.add(const Duration(days: 6));
      }

      return currentDate.add(Duration(days: DateTime.saturday - dayOfWeek));
    }
  }

  /// 获取指定日期所在周的日期列表
  static List<DateTime> getWeekDays({DateTime? date, bool firstDayOfWeekIsMonday = true}) {
    DateTime firstDate = getWeekFirstDay(currentDate: date, firstDayOfWeekIsMonday: firstDayOfWeekIsMonday);

    List<DateTime> weeks = [];

    for (int i = 0; i < 7; i++) {
      weeks.add(getDateTimeByMs(firstDate.millisecondsSinceEpoch + i * 24 * 3600 * 1000));
    }

    return weeks;
  }

  /// 获取指定日期所在周的日期列表
  static List<String?> getStrWeekDays({DateTime? date, DateFormat? format, bool firstDayOfWeekIsMonday = true}) {
    DateTime firstDate = getWeekFirstDay(currentDate: date, firstDayOfWeekIsMonday: firstDayOfWeekIsMonday);

    List<String?> weeks = [];

    for (int i = 0; i < 7; i++) {
      weeks.add(getDateStrByMs(firstDate.millisecondsSinceEpoch + i * 24 * 3600 * 1000,
          format: format ?? DateFormat.YEAR_MONTH_DAY));
    }

    return weeks;
  }

  /// 获取给定月份的最后一天
  static DateTime getLastDayOfMouth(DateTime date) {
    int mouth = date.month;
    int lastDay = 30;

    if (mouth == 2 && isLeapYearByDateTime(date)) {
      lastDay = 29;
    } else {
      lastDay = MONTH_DAY[mouth]!;
    }

    return DateTime(date.year, mouth, lastDay, 23, 59, 59);
  }

  static List<int> getRangMsByDay({DateTime? datetime}) {
    DateTime dataTime;

    if (datetime == null) {
      dataTime = DateTime.now();
    } else {
      dataTime = datetime;
    }

    return [
      DateTime(dataTime.year, dataTime.month, dataTime.day, 0, 0, 0, 0).millisecondsSinceEpoch,
      DateTime(dataTime.year, dataTime.month, dataTime.day, 23, 59, 59).millisecondsSinceEpoch
    ];
  }

  static List<DateTime> getRangDateTimeByDay({DateTime? datetime}) {
    DateTime dataTime;

    if (datetime == null) {
      dataTime = DateTime.now();
    } else {
      dataTime = datetime;
    }

    return [
      DateTime(dataTime.year, dataTime.month, dataTime.day, 0, 0, 0, 0),
      DateTime(dataTime.year, dataTime.month, dataTime.day, 23, 59, 59)
    ];
  }

  /// 友好式时间展示
  /// [duration] 待转换的时间戳
  ///
  static String friendlyDateTime(int duration) {
    String friendly = '';

    int now = DateTime.now().millisecondsSinceEpoch;

    int elapsed = (now - duration).abs();

    final int seconds = elapsed ~/ 1000;
    final int minutes = seconds ~/ 60;
    final int hours = minutes ~/ 60;
    final int days = hours ~/ 24;
    final int mounts = days ~/ 30;

    if (seconds < 60) {
      friendly = '刚刚';
    } else if (seconds >= 60 && seconds < 60 * 60) {
      friendly = '$minutes分钟前';
    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {
      friendly = '$hours小时前';
    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 2) {
      friendly = "昨天 ${getDateStrByMs(duration, format: DateFormat.HOUR_MINUTE)}";
    } else if (seconds >= 60 * 60 * 24 * 2 && seconds < 60 * 60 * 24 * 3) {
      friendly = "前天 ${getDateStrByMs(duration, format: DateFormat.HOUR_MINUTE)}";
    } else if (seconds >= 60 * 60 * 24 * 3 && seconds < 60 * 60 * 24 * 30) {
      friendly = '$days天前';
    } else if (seconds >= 60 * 60 * 24 * 30 && seconds < 60 * 60 * 24 * 30 * 12) {
      friendly = '$mounts个月前';
    } else {
      friendly = getDateStrByMs(duration, format: DateFormat.YEAR_MONTH_DAY)!;
    }

    return friendly;
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
}
