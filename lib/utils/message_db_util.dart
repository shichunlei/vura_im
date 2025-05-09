import 'package:realm/realm.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/realm/message.dart';

import 'log_utils.dart';

class MessageRealm {
  final Realm _realm;

  MessageRealm({required Realm realm}) : _realm = realm;

  /// 查询所有消息
  Future<List<MessageEntity>> queryAllMessageBySessionId(String? sessionId) async {
    Log.d("queryAllMessageBySessionId=====================$sessionId");
    return _realm
        .all<Message>()
        .query(r"sessionId == $0 AND userId == $1 AND deleted == false AND TRUEPREDICATE SORT(sendTime DESC)",
            ["$sessionId", "${AppConfig.userId}"])
        .map((item) => messageRealmToEntity(item))
        .toList();
  }

  /// 获取群聊消息最后一条消息的ID
  Future<String?> queryGroupLastMessageTime() async {
    RealmResults<Message> list = _realm.all<Message>().query(
        r"sessionType == $0 AND userId == $1 AND deleted == false AND TRUEPREDICATE SORT(sendTime DESC)",
        [SessionType.group.name, "${AppConfig.userId}"]);

    Log.d("queryGroupLastMessageTime=========================>${list.length}");

    if (list.isEmpty) {
      return null;
    } else {
      return list.first.messageId;
    }
  }

  /// 获取单聊消息最后一条消息的ID
  Future<String?> queryPrivateLastMessageTime() async {
    RealmResults<Message> list = _realm.all<Message>().query(
        r"sessionType == $0 AND userId == $1 AND deleted == false AND TRUEPREDICATE SORT(sendTime DESC)",
        [SessionType.private.name, "${AppConfig.userId}"]);

    Log.d("queryPrivateLastMessageTime=========================>${list.length}");

    if (list.isEmpty) {
      return null;
    } else {
      return list.first.messageId;
    }
  }

  /// 打开红包
  Future updateRedPackageState(String? id, String? sessionId) async {
    Message? message = findOneById(id, sessionId);
    if (message != null) {
      await _realm.writeAsync(() {
        message.openRedPackage = true;
      });
      Log.d("updateRedPackageState===${message.id}================>${message.toEJson()}");
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
  Future upsert(Message message) async {
    Message? _message = findOneById(message.messageId, message.sessionId);
    Log.d("upsert----message------------->${message.id}");
    if (_message == null) {
      await _realm.writeAsync(() {
        Log.d("upsert----message------------->${message.id}");
        return _realm.add(message);
      });
    }
  }

  Message? findOne(String? id) {
    return _realm.find<Message>("$id");
  }

  Message? findOneById(String? id, String? sessionId) {
    RealmResults<Message> list = _realm.all<Message>().query(
        r"sessionId == $0 AND userId == $1 AND messageId == $2 AND deleted == false AND TRUEPREDICATE SORT(sendTime DESC)",
        ["$sessionId", "${AppConfig.userId}", "$id"]);

    if (list.isEmpty) {
      Log.d("无---findOneById----$sessionId------------->$id");
      return null;
    } else {
      Log.d("有---findOneById----$sessionId------------->$id");
      return list.first;
    }
  }
}

MessageEntity messageRealmToEntity(Message message) {
  return MessageEntity(
      id: message.messageId,
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
      atUserIds: message.atUserIds.toList(),
      readTime: message.readTime,
      openRedPackage: message.openRedPackage);
}

Message messageEntityToRealm(MessageEntity message) {
  return Message(ObjectId(),
      messageId: message.id,
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
      atUserIds: message.atUserIds.toList(),
      readTime: message.readTime,
      openRedPackage: message.openRedPackage);
}
