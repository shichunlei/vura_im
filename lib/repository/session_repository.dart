import 'package:im/entities/base_bean.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/utils/http_utils.dart';

class SessionRepository {
  /// 创建会话
  ///
  static Future<SessionEntity?> createSession(Map<String, dynamic> params) async {
    var data = await HttpUtils.getInstance().request('group/create', params: params, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return SessionEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 修改会话 TODO
  ///
  /// [id] 群ID
  /// [ownerId] 群主ID
  /// [headImage] 群头像
  /// [headImageThumb] 群头像缩略图
  /// [notice] 公告
  /// [remarkNickName] 用户在群显示昵称
  /// [showNickName] 群内显示名称
  /// [showGroupName] 群名显示名称
  /// [remarkGroupName] 群名备注
  ///
  static Future<BaseBean> updateSession(int? id,
      {String? name,
      int? ownerId,
      String? headImage,
      String? headImageThumb,
      String? notice,
      String? remarkNickName,
      String? showNickName,
      String? showGroupName,
      String? remarkGroupName}) async {
    var data = await HttpUtils.getInstance().request('group/modify',
        params: {
          Keys.ID: id,
          if (ownerId != null) "ownerId": ownerId,
          if (headImage != null) "headImage": headImage,
          if (headImageThumb != null) "headImageThumb": headImageThumb,
          if (notice != null) "notice": notice,
          if (remarkNickName != null) "remarkNickName": remarkNickName,
          if (showNickName != null) "showNickName": showNickName,
          if (showGroupName != null) "showGroupName": showGroupName,
          if (remarkGroupName != null) "remarkGroupName": remarkGroupName
        },
        method: HttpUtils.PUT);
    return BaseBean.fromJson(data);
  }

  /// 群列表
  ///
  static Future<List<SessionEntity>> getSessionList() async {
    var data = await HttpUtils.getInstance().request('group/list', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => SessionEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 我创建的列表
  ///
  static Future<List<SessionEntity>> getMyCreateSessionList() async {
    var data = await HttpUtils.getInstance().request('group/my/create/list', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => SessionEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 我加入的群列表
  ///
  static Future<List<SessionEntity>> getMyJoinSessionList() async {
    var data = await HttpUtils.getInstance().request('group/my/join/list', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => SessionEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 会话详情
  ///
  /// [id] 会话ID
  ///
  static Future<SessionEntity?> getSessionInfo(int? id) async {
    var data = await HttpUtils.getInstance().request('group/find/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return SessionEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 邀请成员
  ///
  /// [id] 群ID
  /// [userIds] 被邀请的成员IDs
  ///
  static Future<BaseBean> inviteMembers(int? id, List<int?> userIds) async {
    var data = await HttpUtils.getInstance()
        .request('group/invite', params: {"groupId": id, "friendIds": userIds}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 群成员列表
  ///
  /// [id] 群ID
  ///
  static Future<List<MemberEntity>> getSessionMembers(int? id) async {
    var data = await HttpUtils.getInstance().request('group/members/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MemberEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 群管理员列表 TODO
  ///
  /// [id] 群ID
  ///
  static Future<List<MemberEntity>> getSessionSupAdmin(int? id) async {
    var data = await HttpUtils.getInstance().request('group/members/supadmin/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MemberEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 退出群聊 TODO
  ///
  /// [id] 群ID
  ///
  static Future<BaseBean> quitSession(int? id) async {
    var data = await HttpUtils.getInstance().request('group/quit/$id', method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 踢出群聊 TODO
  ///
  /// [id] 群ID
  /// [userIds] 被踢出群聊的成员列表
  ///
  static Future<BaseBean> kickMemberFromSession(int? id, List<int?> userIds) async {
    var data = await HttpUtils.getInstance().request('group/kickList',
        params: {"friendIds": userIds, "groupId": id}, method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 解散群聊 TODO
  ///
  /// [id] 群ID
  ///
  static Future<BaseBean> deleteSession(int? id) async {
    var data =
        await HttpUtils.getInstance().request('group/delete/$id', method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 发送消息
  ///
  /// [id] 群ID
  /// [sessionType] 会话类型
  /// [content] 发送内容
  /// [type] 消息类型 0:文字 1:图片 2:文件 3:语音 4:视频
  /// [atUserIds] 被@用户列表
  ///
  static Future<MessageEntity?> sendMessage(int? id, SessionType sessionType,
      {String? content,
      MessageType type = MessageType.TEXT,
      List<int?> atUserIds = const [],
      String? receiveNickName,
      String? receiveHeadImage}) async {
    var data = await HttpUtils.getInstance()
        .request(sessionType == SessionType.private ? "message/private/send" : 'message/group/send', params: {
      if (sessionType == SessionType.group) "groupId": id,
      if (sessionType == SessionType.private) "recvId": id,
      if (sessionType == SessionType.private) "recvNickName": receiveNickName,
      if (sessionType == SessionType.private) "recvHeadImage": receiveHeadImage,
      Keys.CONTENT: content,
      Keys.TYPE: type.code,
      "receipt": true,
      if (sessionType == SessionType.group) "atUserIds": atUserIds
    });
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return MessageEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 获取群历史消息
  ///
  /// [id] 群ID
  /// [type] 会话类型
  /// [page]
  /// [size]
  ///
  static Future<List<MessageEntity>> getMessages(int? id, SessionType type, {int page = 0, int size = 200}) async {
    var data = await HttpUtils.getInstance()
        .request(type == SessionType.private ? "message/private/history" : 'message/group/history',
            params: {
              if (type == SessionType.private) "friendId": id,
              if (type == SessionType.group) "groupId": id,
              "page": page,
              "size": size
            },
            method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MessageEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 获取离线消息
  ///
  /// [type]
  /// [groupMinId]
  /// [privateMinId]
  ///
  static Future getOfflineMessages(String type, {int groupMinId = 0, int privateMinId = 0}) async {
    if (type == "group" || type == "all") {
      HttpUtils.getInstance()
          .request('message/group/pullOfflineMessage', params: {"minId": groupMinId}, method: HttpUtils.GET);
    }
    if (type == "private" || type == "all") {
      HttpUtils.getInstance()
          .request('message/private/pullOfflineMessage', params: {"minId": privateMinId}, method: HttpUtils.GET);
    }
  }

  /// 已读群聊消息 TODO
  ///
  /// [groupId] 群ID
  ///
  static Future<BaseBean> readMessage(int? groupId) async {
    var data = await HttpUtils.getInstance()
        .request('message/group/readed', params: {"groupId": groupId}, method: HttpUtils.PUT);
    return BaseBean.fromJson(data);
  }

  /// 获取已读用户id TODO
  ///
  /// [id] 群ID
  /// [messageId]
  ///
  static Future<List<MessageEntity>> getReadUsers(int? id, int? messageId) async {
    var data = await HttpUtils.getInstance().request('message/group/findReadedUsers',
        params: {"groupId": id, "messageId": messageId}, method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MessageEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 撤回消息 TODO
  ///
  /// [id] 消息ID
  ///
  static Future<BaseBean> recallMessage(int? id) async {
    var data = await HttpUtils.getInstance()
        .request('message/group/recall/$id', method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 设置管理员 TODO
  ///
  /// [id] 群ID
  /// [ids] 被设置管理员的用户IDS
  ///
  static Future<BaseBean> setSupAdmin(int? id, List<int?> ids) async {
    var data = await HttpUtils.getInstance().request('group/setSupAdmin',
        params: {"adminIdList": ids, "groupId": id}, method: HttpUtils.PUT, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 群主转让 TODO
  ///
  /// [id] 群ID
  /// [userId] 被设置群主的用户ID
  ///
  static Future<BaseBean> setAdmin(int? id, int? userId) async {
    var data = await HttpUtils.getInstance().request('group/setAdmin',
        params: {
          "groupId": id,
          "adminIdList": [id]
        },
        method: HttpUtils.PUT,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 设置禁言 TODO
  ///
  /// [id] 群ID
  /// [ids] 被设置禁言的用户IDS
  ///
  static Future<BaseBean> setMute(int? id, List<int?> ids) async {
    var data = await HttpUtils.getInstance()
        .request('group/mute', params: {"friendIds": ids, "groupId": id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 被禁言列表 TODO
  ///
  /// [id] 群ID
  /// [ids] 被设置禁言的用户IDS
  ///
  static Future<List<MemberEntity>> muteList(int? id, List<int?> ids) async {
    var data = await HttpUtils.getInstance().request('group/members/mute/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MemberEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
