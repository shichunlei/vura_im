import 'dart:convert';

import 'package:get/get.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/modules/home/session/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/utils/enum_to_string.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/string_util.dart';
import 'package:realm/realm.dart';

part 'channel.realm.dart';

@RealmModel()
class _Channel {
  @PrimaryKey()
  late String _id;
  String? userId;
  String type = "group";
  String? id;
  String? name;
  String? ownerId;
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
  bool isDisturb = false;
  bool isAdmin = false;
  String isSupAdmin = "N";
}

class SessionRealm {
  final Realm _realm;

  SessionRealm({required Realm realm}) : _realm = realm;

  /// 查询所有会话
  Future<List<SessionEntity>> queryAllSessions() async {
    Log.d("queryAllSessions=====================${Get.find<RootLogic>().user.value?.id}");
    return _realm
        .all<Channel>()
        .query(r"userId == $0 AND deleted == $1 AND TRUEPREDICATE SORT(moveTop ASC ,lastMessageTime DESC)",
            ["${Get.find<RootLogic>().user.value?.id}", false])
        .map((item) => sessionRealmToEntity(item))
        .toList();
  }

  /// 查询会话
  Future<SessionEntity?> querySessionById(String? id, SessionType sessionType) async {
    Log.d("querySessionById=====================$id");
    Channel? session = findOne("${Get.find<RootLogic>().user.value?.id}-$id-${sessionType.name}");
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

  /// 更新会话基本信息
  Future updateSessionInfo(SessionEntity session) async {
    Channel? _session = findOne("${Get.find<RootLogic>().user.value?.id}-${session.id}-${session.type.name}");
    if (_session != null) {
      Log.d("----------------->${session.id}");

      await _realm.writeAsync(() {
        _session.name = session.name;
        _session.headImage = session.headImage;
        _session.headImageThumb = session.headImageThumb;
        _session.notice = session.notice;
      });
      Log.d("updateSessionInfo===${_session.id}================>${_session.toEJson()}");

      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    } else {
      Log.d("====================================${session.toJson()}");
      upsert(sessionEntityToRealm(session));
    }
  }

  /// 更新会话最后一条消息
  Future updateLastMessage(SessionEntity session, MessageEntity message) async {
    Channel? _session = findOne("${Get.find<RootLogic>().user.value?.id}-${session.id}-${session.type.name}");
    if (_session != null) {
      Log.d("----------------->${session.id}");

      if (_session.lastMessage != null && _session.lastMessageTime > message.sendTime) return;

      await _realm.writeAsync(() {
        _session.lastMessage = json.encode(message.toJson());
        _session.lastMessageTime = message.sendTime;
        if (StringUtil.isNotEmpty(session.name)) _session.name = session.name;
        if (StringUtil.isNotEmpty(session.headImage)) _session.headImage = session.headImage;
      });
      Log.d("updateLastMessage===${_session.id}================>${_session.toEJson()}");
    } else {
      Log.d("====================================${session.toJson()}");
      upsert(sessionEntityToRealm(session));
    }
  }

  /// 更新会话置顶状态
  Future setChannelTop(String? id, bool isTop, SessionType sessionType) async {
    Channel? _session = findOne("${Get.find<RootLogic>().user.value?.id}-$id-${sessionType.name}");
    if (_session != null) {
      await _realm.writeAsync(() {
        _session.moveTop = isTop;
      });
      Log.d("setChannelTop===${_session.id}================>${_session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 更新会话免打扰状态
  Future setChannelDisturb(String? id, bool isDisturb, SessionType sessionType) async {
    Channel? _session = findOne("${Get.find<RootLogic>().user.value?.id}-$id-${sessionType.name}");
    if (_session != null) {
      await _realm.writeAsync(() {
        _session.isDisturb = isDisturb;
      });
      Log.d("setChannelTop===${_session.id}================>${_session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 删除会话
  Future deleteChannel(String? id, SessionType sessionType) async {
    Channel? _session = findOne("${Get.find<RootLogic>().user.value?.id}-$id-${sessionType.name}");
    if (_session != null) {
      await _realm.writeAsync(() {
        _session.deleted = true;
      });
      Log.d("deleteChannel===${_session.id}================>${_session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
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
      isDisturb: session.isDisturb,
      isAdmin: session.isAdmin,
      isSupAdmin: EnumToString.fromString(YorNType.values, session.isSupAdmin),
      moveTop: session.moveTop);
}

Channel sessionEntityToRealm(SessionEntity session) {
  return Channel("${Get.find<RootLogic>().user.value?.id}-${session.id}-${session.type.name}",
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
      isDisturb: session.isDisturb,
      isAdmin: session.isAdmin,
      isSupAdmin: session.isSupAdmin.name,
      lastMessage: session.lastMessage == null ? null : json.encode(session.lastMessage!.toJson()));
}
