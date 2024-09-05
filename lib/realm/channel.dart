import 'dart:convert';

import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/utils/enum_to_string.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';

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
  String isAdmin = "N";
  String isSupAdmin = "N";
  String? config;
  String friendship = "Y";
  int unReadCount = 0;
}

class SessionRealm {
  final Realm _realm;

  SessionRealm({required Realm realm}) : _realm = realm;

  /// 查询所有会话
  Future<List<SessionEntity>> queryAllSessions() async {
    Log.d("queryAllSessions=====================${AppConfig.userId}");
    return _realm
        .all<Channel>()
        .query(
            r"userId == $0 AND deleted == $1 AND id <> null AND friendship == $2 AND TRUEPREDICATE SORT(moveTop DESC ,lastMessageTime DESC)",
            ["${AppConfig.userId}", false, "Y"])
        .map((item) => sessionRealmToEntity(item))
        .toList();
  }

  /// 查询会话
  Future<SessionEntity?> querySessionById(String? id, SessionType sessionType) async {
    Log.d("querySessionById=====================$id");
    Channel? session = findOne("${AppConfig.userId}-$id-${sessionType.name}");
    if (session != null) {
      Log.d("querySessionById=====================${session.toEJson()}");
      return sessionRealmToEntity(session);
    } else {
      return null;
    }
  }

  /// 更新/插入数据
  Future<Channel> upsert(Channel session) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----channel------------->${session.id}");
      return _realm.add(session, update: true);
    });
  }

  Future saveChannel(SessionEntity session) async {
    Channel? _session = findOne("${AppConfig.userId}-${session.id}-${session.type.name}");
    if (_session != null) {
      await _realm.writeAsync(() {
        if (StringUtil.isNotEmpty(session.name)) _session.name = session.name;
        _session.headImage = session.headImage;
        _session.headImageThumb = session.headImageThumb;
        _session.notice = session.notice;
        _session.config = session.configObj != null ? json.encode(session.configObj!.toJson()) : null;
        _session.isAdmin = session.isAdmin.name;
        _session.isSupAdmin = session.isSupAdmin.name;
        _session.deleted = session.deleted;
        _session.ownerId = session.ownerId;
        _session.quit = session.quit;
        _session.remarkGroupName = session.remarkGroupName;
        _session.remarkNickName = session.remarkNickName;
        _session.showGroupName = session.showGroupName;
        _session.showNickName = session.showNickName;
      });
      Log.d("saveChannel===${_session.id}================>${_session.toEJson()}");

      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    } else {
      await upsert(sessionEntityToRealm(session));
    }
  }

  /// 更新会话基本信息
  Future updateSessionInfo(SessionEntity session) async {
    Channel? _session = findOne("${AppConfig.userId}-${session.id}-${session.type.name}");
    if (_session != null) {
      Log.d("----------------->${session.id}");

      await _realm.writeAsync(() {
        _session.name = session.name;
        _session.headImage = session.headImage;
        _session.headImageThumb = session.headImageThumb;
        _session.deleted = session.deleted;
        if (session.type == SessionType.group) {
          if (session.notice != null) _session.notice = session.notice;
          _session.isAdmin = session.isAdmin.name;
          _session.isSupAdmin = session.isSupAdmin.name;
        }
      });

      Log.d("updateSessionInfo===${_session.id}================>${_session.toEJson()}");

      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    } else {
      await upsert(sessionEntityToRealm(session));
    }
  }

  /// 更新会话最后一条消息
  Future updateLastMessage(SessionEntity session, MessageEntity message) async {
    Channel? _session = findOne("${AppConfig.userId}-${session.id}-${session.type.name}");
    if (_session != null) {
      Log.d("----------------->${session.id}");

      if (_session.lastMessage != null && _session.lastMessageTime > message.sendTime) return;

      await _realm.writeAsync(() {
        _session.lastMessage = json.encode(message.toJson());
        _session.lastMessageTime = message.sendTime;
        if (StringUtil.isNotEmpty(session.name)) _session.name = session.name;
        if (StringUtil.isNotEmpty(session.headImage)) _session.headImage = session.headImage;
        if (message.sendId == AppConfig.userId) {
          _session.unReadCount = 0;
        } else {
          _session.unReadCount = _session.unReadCount + 1;
        }
      });
      Log.d("updateLastMessage===${_session.id}================>${_session.toEJson()}");
    } else {
      Channel channel = sessionEntityToRealm(session);
      channel.unReadCount = 1;
      await upsert(channel);
    }
  }

  /// 更新会话配置
  Future setChannelConfig(String? id, SessionConfigEntity config) async {
    Channel? session = findOne("${AppConfig.userId}-$id-${SessionType.group.name}");
    if (session != null) {
      await _realm.writeAsync(() {
        session.config = json.encode(config.toJson());
      });
      Log.d("setChannelConfig===${session.id}================>${session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 更新会话置顶状态
  Future setChannelTop(String? id, bool isTop, SessionType sessionType) async {
    Channel? session = findOne("${AppConfig.userId}-$id-${sessionType.name}");
    if (session != null) {
      await _realm.writeAsync(() {
        session.moveTop = isTop;
      });
      Log.d("setChannelTop===${session.id}================>${session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 更新会话免打扰状态
  Future setChannelDisturb(String? id, bool isDisturb, SessionType sessionType) async {
    Channel? session = findOne("${AppConfig.userId}-$id-${sessionType.name}");
    if (session != null) {
      await _realm.writeAsync(() {
        session.isDisturb = isDisturb;
      });
      Log.d("setChannelTop===${session.id}================>${session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 删除会话
  Future deleteChannel(String? id, SessionType sessionType) async {
    Channel? session = findOne("${AppConfig.userId}-$id-${sessionType.name}");
    if (session != null) {
      await _realm.writeAsync(() {
        session.deleted = true;
      });
      Log.d("deleteChannel===${session.id}================>${session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 拉黑
  Future blacklistChannel(String? id, YorNType type) async {
    Channel? session = findOne("${AppConfig.userId}-$id-${SessionType.private.name}");
    if (session != null) {
      await _realm.writeAsync(() {
        session.friendship = type.name;
      });
      Log.d("deleteChannel===${session.id}================>${session.toEJson()}");
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 更新会话纬度消息数
  Future updateUnreadCount(String? sessionId, SessionType type) async {
    Channel? _session = findOne("${AppConfig.userId}-$sessionId-${type.name}");
    if (_session != null) {
      Log.d("----------------->$sessionId");
      await _realm.writeAsync(() {
        _session.unReadCount = 0;
      });
      Log.d("updateUnreadCount===${_session.id}================>${_session.toEJson()}");

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
      isAdmin: EnumToString.fromString(YorNType.values, session.isAdmin),
      config: session.config,
      configObj: session.config != null ? SessionConfigEntity.fromJson(json.decode(session.config!)) : null,
      isSupAdmin: EnumToString.fromString(YorNType.values, session.isSupAdmin),
      moveTop: session.moveTop,
      unReadCount: session.unReadCount,
      friendship: EnumToString.fromString(YorNType.values, session.friendship));
}

Channel sessionEntityToRealm(SessionEntity session) {
  return Channel("${AppConfig.userId}-${session.id}-${session.type.name}",
      name: session.name,
      id: session.id,
      userId: AppConfig.userId,
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
      isAdmin: session.isAdmin.name,
      isSupAdmin: session.isSupAdmin.name,
      friendship: session.friendship.name,
      unReadCount: session.unReadCount,
      config: session.configObj == null ? null : json.encode(session.configObj!.toJson()),
      lastMessage: session.lastMessage == null ? null : json.encode(session.lastMessage!.toJson()));
}
