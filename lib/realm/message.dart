import 'package:realm/realm.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/utils/log_utils.dart';

part 'message.realm.dart';

@RealmModel()
class _Message {
  @PrimaryKey()
  String? id;
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
}

class MessageRealm {
  final Realm _realm;

  MessageRealm({required Realm realm}) : _realm = realm;

  /// 查询所有消息
  Future<List<MessageEntity>> queryAllMessageBySessionId(String? id) async {
    Log.d("queryAllMessageBySessionId=====================$id");
    return _realm.all<Message>().query(r"sessionId == $0", ["$id"]).map((item) => messageRealmToEntity(item)).toList();
  }

  /// 更新/插入数据
  Future<Message> upsert(Message user) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----message------------->${user.id}");
      return _realm.add(user, update: true);
    });
  }

  Message? findOne(String? id) {
    return _realm.find<Message>(id);
  }
}

MessageEntity messageRealmToEntity(Message message) {
  return MessageEntity(
      id: message.id,
      sendNickName: message.sendNickName,
      sendId: message.sendId,
      sendHeadImage: message.sendHeadImage,
      receiveNickName: message.receiveNickName,
      receiveId: message.receiveId,
      readCount: message.readCount,
      receiveHeadImage: message.sendHeadImage,
      sendTime: message.sendTime,
      status: message.status,
      content: message.content,
      type: message.type,
      receipt: message.receipt,
      receiptOk: message.receiptOk,
      atUserIds: message.atUserIds.toList());
}

Message messageEntityToRealm(MessageEntity message) {
  return Message(message.id,
      sessionId: message.sessionId,
      sendNickName: message.sendNickName,
      sendId: message.sendId,
      sendHeadImage: message.sendHeadImage,
      receiveNickName: message.receiveNickName,
      receiveId: message.receiveId,
      readCount: message.readCount,
      receiveHeadImage: message.sendHeadImage,
      sendTime: message.sendTime,
      status: message.status,
      content: message.content,
      type: message.type,
      receipt: message.receipt,
      receiptOk: message.receiptOk,
      atUserIds: message.atUserIds.toList());
}
