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
  APPLY_ADD_GROUP(901, "申请添加群聊通知");

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
  SYSTEM_MESSAGE(5, "系统消息");

  final int code;
  final String label;

  const WebSocketCode(this.code, this.label);
}

enum SessionType { group, private }

enum YorNType { Y, N, B }

enum FriendSourceType { SCAN, CARD, CHAT_NO, PHONE, SHAKE, SYS, GROUP, NEAR }
