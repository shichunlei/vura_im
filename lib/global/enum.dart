import 'package:flutter/material.dart';

/// 页面状态类型
enum ViewState {
  success,
  loading, //加载中
  empty, // 加载成功，但数据为空
  error, //加载失败
  noNetwork, // 没网
}

enum LoginFrom { h5, web, app }

enum RefreshState { none, refresh, load, error }

enum MessageType {
  TEXT(0, "文字消息"),
  IMAGE(1, "图片消息"),
  FILE(2, "文件消息"),
  AUDIO(3, "语音消息"),
  VIDEO(4, "视频消息"),
  RECALL(10, "撤回"),
  READ_ED(11, "已读"),
  RECEIPT(12, "消息已读回执"),
  TIP_TIME(20, "时间提示"),
  TIP_TEXT(21, "文字提示"),
  LOADING(30, "加载中标记"),
  ACT_RT_VOICE(40, "语音通话"),
  ACT_RT_VIDEO(41, "视频通话"),
  USER_BANNED(50, "用户封禁"),
  GROUP_BANNED(51, "群聊封禁"),
  GROUP_UNBAN(52, "群聊解封"),
  RTC_CALL_VOICE(100, "语音呼叫"),
  RTC_CALL_VIDEO(101, "视频呼叫"),
  RTC_ACCEPT(102, "接受"),
  RTC_REJECT(103, "拒绝"),
  RTC_CANCEL(104, "取消呼叫"),
  RTC_FAILED(105, "呼叫失败"),
  RTC_HAND_UP(106, "挂断"),
  RTC_CANDIDATE(107, "同步candidate"),
  RTC_GROUP_SETUP(200, "发起群视频通话"),
  RTC_GROUP_ACCEPT(201, "接受通话呼叫"),
  RTC_GROUP_REJECT(202, "拒绝通话呼叫"),
  RTC_GROUP_FAILED(203, "拒绝通话呼叫"),
  RTC_GROUP_CANCEL(204, "取消通话呼叫"),
  RTC_GROUP_QUIT(205, "退出通话"),
  RTC_GROUP_INVITE(206, "邀请进入通话"),
  RTC_GROUP_JOIN(207, "主动进入通话"),
  RTC_GROUP_OFFER(208, "推送offer信息"),
  RTC_GROUP_ANSWER(209, "推送answer信息"),
  RTC_GROUP_CANDIDATE(210, "同步candidate"),
  RTC_GROUP_DEVICE(211, "设备操作"),
  APPLY_ADD_FRIEND(900, "申请添加好友通知"),
  APPLY_ADD_GROUP(901, "申请添加群聊通知"),
  APPLY_ADD_FRIEND_SUCCESS(902, "申请添加好友成功通知"),
  RED_PACKAGE(904, "单人红包"),
  ID_CARD(905, "个人名片"),
  GROUP_RED_PACKAGE(906, "群红包"),
  EMOJI(1000, "表情");

  final int code;
  final String label;

  const MessageType(this.code, this.label);
}

enum MessageStatus {
  UN_SEND(0, "未发送"),
  SEND_ED(1, "已发送"),
  RECALL(2, "撤回"),
  READ_ED(3, "已读");

  final int code;
  final String label;

  const MessageStatus(this.code, this.label);
}

enum WebSocketCode {
  LOGIN(0, "连接成功"),
  HEARTBEAT(1, "心跳"),
  LOGOFF(2, "异地登录，强制下线"),
  PRIVATE_MESSAGE(3, "私聊消息"),
  GROUP_MESSAGE(4, "群聊消息"),
  SYSTEM_MESSAGE(5, "系统消息"),
  FRIEND_APPLY(6, "好友申请"),
  GROUP_CONFIG_UPDATE(7, "群聊配置修改");

  final int code;
  final String label;

  const WebSocketCode(this.code, this.label);
}

enum SessionType { group, private }

enum YorNType { Y, N, B, M, F, EXPIRE }

enum FriendSourceType { SCAN, CARD, CHAT_NO, PHONE, SHAKE, SYS, GROUP, NEAR }

enum SelectType { checkbox, radio, none }

enum LocalType {
  zh_CN("zh_CN", Locale("zh", "CN")),
  zh_HK("zh_HK", Locale("zh", "HK")),
  en_US("en_US", Locale("en", "US"));

  final String code;
  final Locale locale;

  const LocalType(this.code, this.locale);
}

enum FeeType {
  PAY("支出"),
  INCOME("收入"),
  ALL("全部");

  final String label;

  const FeeType(this.label);
}

enum RedPackageCoverType {
  cover_0(label: "默认", coverPath: "assets/images/default_cover.webp", itemPath: "assets/images/item_cover_default.png"),
  cover_1(label: "年年有余", coverPath: "assets/images/cover-1.webp", itemPath: "assets/images/item_cover-1.png"),
  cover_2(label: "红包拿来", coverPath: "assets/images/cover-2.webp", itemPath: "assets/images/item_cover-2.png"),
  cover_3(label: "招财进宝", coverPath: "assets/images/cover-3.webp", itemPath: "assets/images/item_cover-3.png");

  final String label;
  final String coverPath;
  final String itemPath;

  const RedPackageCoverType({required this.label, required this.coverPath, required this.itemPath});
}

enum CheckPasswordType {
  gesturePassword(label: "图案密码"),
  numberPassword(label: "数字密码");

  final String label;

  const CheckPasswordType({required this.label});
}

enum TextSizeType {
  zero(label: "A", fontSize: 13, stepValue: .0),
  one(label: "标准", fontSize: 15, stepValue: 1.0),
  two(label: "", fontSize: 17, stepValue: 2.0),
  three(label: "", fontSize: 19, stepValue: 3.0),
  four(label: "", fontSize: 21, stepValue: 4.0),
  five(label: "", fontSize: 23, stepValue: 5.0),
  six(label: "", fontSize: 25, stepValue: 6.0),
  seven(label: "A", fontSize: 27, stepValue: 7.0);

  final String label;
  final double fontSize;
  final double stepValue;

  const TextSizeType({required this.label, required this.fontSize, required this.stepValue});
}

enum BookType {
  RED(label: "红包"),
  RED_TRANSFER(label: "红包转账"),
  WIDTH_DRAW(label: "提现"),
  RECHARGE(label: "充值"),
  TRANSFER(label: "转账"),
  INCOME(label: "到账"),
  RED_REFUND(label: "红包退款");

  final String label;

  const BookType({required this.label});
}

enum RedPackageType {
  ONE(code: 1, label: "单人红包"),
  ORDINARY(code: 2, label: "普通群红包"),
  LUCKY(code: 3, label: "拼手气红包"),
  SPECIAL(code: 4, label: "专属红包");

  final int code;
  final String label;

  const RedPackageType({required this.code, required this.label});
}
