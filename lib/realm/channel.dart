import 'dart:convert';

import 'package:get/get.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/utils/enum_to_string.dart';
import 'package:im/utils/log_utils.dart';
import 'package:realm/realm.dart';

part 'channel.realm.dart';

@RealmModel()
class _Channel {
  @PrimaryKey()
  late String _id;
  int? userId;
  String type = "group";
  int? id;
  String? name;
  int? ownerId;
  String? headImage;
  String? headImageThumb;
  String? notice;
  String? remarkNickName;
  String? showNickName;
  String? showGroupName;
  String? remarkGroupName;
  bool deleted = false;
  bool quit = false;
  String? lastMessage;
  int lastMessageTime = 0;
  bool moveTop = false;
}

class SessionRealm {
  final Realm _realm;

  SessionRealm({required Realm realm}) : _realm = realm;

  /// 查询所有会话
  Future<List<SessionEntity>> queryAllSessions() async {
    Log.d("queryAllByCompanyId=====================${Get.find<RootLogic>().user.value?.id}");
    return _realm
        .all<Channel>()
        .query(
            r"userId == $0 AND TRUEPREDICATE SORT(lastMessageTime DESC)", [Get.find<RootLogic>().user.value?.id ?? 0])
        .map((item) => sessionRealmToEntity(item))
        .toList();
  }

  /// 查询会话
  Future<SessionEntity?> querySessionById(int? id) async {
    Log.d("querySessionById=====================$id");
    Channel? session = findOne("${Get.find<RootLogic>().user.value?.id}-$id");
    if (session != null) {
      return sessionRealmToEntity(session);
    } else {
      return null;
    }
  }

  /// 更新/插入数据
  Future<Channel> upsert(Channel session) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----------------->${session.id}");
      return _realm.add(session, update: true);
    });
  }

  /// 更新会话最后一条消息
  Future updateLastMessage(SessionEntity session, MessageEntity message) async {
    Channel? _session = findOne("${Get.find<RootLogic>().user.value?.id}-${session.id}");
    if (_session != null) {
      Log.d("----------------->${session.id}");

      if (_session.lastMessage != null && _session.lastMessageTime > message.sendTime) return;

      await _realm.writeAsync(() {
        _session.lastMessage = json.encode(message.toJson());
        _session.lastMessageTime = message.sendTime;
      });
      Log.d("updateLastMessage===${_session.id}================>${_session.toEJson()}");
    } else {
      Log.d("====================================${session.toJson()}");
      upsert(sessionEntityToRealm(session));
    }
  }

  Channel? findOne(String? id) {
    return _realm.find<Channel>(id);
  }
}

SessionEntity sessionRealmToEntity(Channel session) {
  return SessionEntity(
      id: session.id,
      name: session.name,
      type: EnumToString.fromString(SessionType.values, session.type),
      ownerId: session.ownerId,
      headImage: session.headImage,
      headImageThumb: session.headImageThumb,
      notice: session.notice,
      remarkNickName: session.remarkNickName,
      showNickName: session.showNickName,
      showGroupName: session.showGroupName,
      remarkGroupName: session.remarkGroupName,
      deleted: session.deleted,
      quit: session.quit,
      lastMessage: session.lastMessage == null ? null : MessageEntity.fromJson(json.decode(session.lastMessage!)),
      lastMessageTime: session.lastMessageTime,
      moveTop: session.moveTop);
}

Channel sessionEntityToRealm(SessionEntity session) {
  return Channel("${Get.find<RootLogic>().user.value?.id}-${session.id}",
      name: session.name,
      id: session.id,
      userId: Get.find<RootLogic>().user.value?.id,
      type: EnumToString.parse(session.type) ?? SessionType.group.name,
      ownerId: session.ownerId,
      headImage: session.headImage,
      headImageThumb: session.headImageThumb,
      notice: session.notice,
      remarkNickName: session.remarkNickName,
      showNickName: session.showNickName,
      showGroupName: session.showGroupName,
      remarkGroupName: session.remarkGroupName,
      deleted: session.deleted,
      quit: session.quit,
      lastMessageTime: session.lastMessageTime,
      moveTop: session.moveTop,
      lastMessage: session.lastMessage == null ? null : json.encode(session.lastMessage!.toJson()));
}
