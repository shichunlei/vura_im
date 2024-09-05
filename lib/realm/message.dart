import 'package:realm/realm.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/log_utils.dart';

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
}

class MessageRealm {
  final Realm _realm;

  MessageRealm({required Realm realm}) : _realm = realm;

  /// 查询所有消息
  Future<List<MessageEntity>> queryAllMessageBySessionId(String? sessionId) async {
    Log.d("queryAllMessageBySessionId=====================$sessionId");
    return _realm
        .all<Message>()
        .query(r"sessionId == $0 AND userId == $1 AND TRUEPREDICATE SORT(sendTime DESC)",
            ["$sessionId", "${AppConfig.userId}"])
        .map((item) => messageRealmToEntity(item))
        .toList();
  }

  /// 获取群聊消息最后一条消息的ID
  Future<String?> queryGroupLastMessageTime() async {
    RealmResults<Message> list = _realm.all<Message>().query(
        r"sessionType == $0 AND userId == $1 AND TRUEPREDICATE SORT(sendTime DESC)",
        [SessionType.group.name, "${AppConfig.userId}"]);

    Log.d("queryGroupLastMessageTime=========================>${list.length}");

    if (list.isEmpty) {
      return null;
    } else {
      return list.first.id;
    }
  }

  /// 获取单聊消息最后一条消息的ID
  Future<String?> queryPrivateLastMessageTime() async {
    RealmResults<Message> list = _realm.all<Message>().query(
        r"sessionType == $0 AND userId == $1 AND TRUEPREDICATE SORT(sendTime DESC)",
        [SessionType.private.name, "${AppConfig.userId}"]);

    Log.d("queryPrivateLastMessageTime=========================>${list.length}");

    if (list.isEmpty) {
      return null;
    } else {
      return list.first.id;
    }
  }

  /// 更新/插入数据
  Future deleteBySessionId(String? sessionId) async {
    RealmResults<Message> list =
        _realm.all<Message>().query(r"sessionId == $0 AND userId == $1", ["$sessionId", "${AppConfig.userId}"]);

    await _realm.writeAsync(() {
      for (var item in list) {
        _realm.delete(item);
      }
    });
  }

  /// 更新/插入数据
  Future<Message> upsert(Message message) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----message------------->${message.id}");
      return _realm.add(message, update: true);
    });
  }

  Message? findOne(String? id) {
    return _realm.find<Message>("${AppConfig.userId}-$id");
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
  return Message("${AppConfig.userId}-${message.id}",
      id: message.id,
      userId: AppConfig.userId,
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
      sessionType: message.sessionType.name,
      receipt: message.receipt,
      receiptOk: message.receiptOk,
      atUserIds: message.atUserIds.toList());
}
