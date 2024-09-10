import 'package:realm/realm.dart';

part 'message.realm.dart';

@RealmModel()
class _Message {
  @PrimaryKey()
  String? _id;
  String? id;
  String? userId;
  String? sendNickName; // 发送者昵称
  String? sendId; // 发送者ID
  String? sendHeadImage; // 发送者昵称
  String? receiveId; // 接收消息的用户ID（单聊）
  String? receiveNickName; // 接收消息的用户ID（单聊）
  String? receiveHeadImage; // 接收消息的用户ID（单聊）
  String? sessionId; // 会话ID
  String sessionType = "group"; // 会话类型
  int readCount = 0; //
  bool receipt = false;
  bool receiptOk = false;
  int type = 0; // 消息类型
  String? content; // 消息内容
  int sendTime = 0; // 发送时间
  int status = 0; // 消息状态
  List<String?> atUserIds = [];
  int readTime = 0; // 阅读时间
  bool openRedPackage = false; // 红包是否打开
  bool deleted = false; // 是否删除
}
