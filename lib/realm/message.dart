import 'package:realm/realm.dart';

part 'message.realm.dart';

@RealmModel()
class _Message {
  @PrimaryKey()
  int? id;
  String? sendNickName; // 发送者昵称
  late int sendId; // 发送者ID
  int? receiveId; // 接收消息的用户ID（单聊）
  int? sessionId; // 会话ID
  String sessionType = "group"; // 会话类型
  int readCount = 0; //
  bool receipt = false;
  bool receiptOk = false;
  int type = 0; // 消息类型
  String? content; // 消息内容
  int sendTime = 0; // 发送时间
  int status = 0; // 消息状态
  List<int?> atUserIds = [];
}
