import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/red_package.dart';
import 'package:vura/entities/red_package_result.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/utils/http_utils.dart';

class SessionRepository {
  /// 创建会话
  ///
  static Future<BaseBean> createSession(Map<String, dynamic> params) async {
    var data = await HttpUtils.getInstance().request('group/create', params: params, showErrorToast: true);
    return BaseBean.fromJson(data);
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
  static Future<BaseBean> updateSession(String? id,
      {required String? name,
      String? ownerId,
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
          Keys.NAME: name,
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
  static Future<SessionEntity?> getSessionInfo(String? id) async {
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
  static Future<BaseBean> inviteMembers(String? id, List<String?> userIds) async {
    var data = await HttpUtils.getInstance()
        .request('group/invite', params: {Keys.GROUP_ID: id, Keys.FRIEND_IDS: userIds}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 群成员列表 TODO
  ///
  /// [id] 群ID
  ///
  static Future<List<MemberEntity>> getSessionMembers(String? id) async {
    var data = await HttpUtils.getInstance().request('group/members/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MemberEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 群成员详情 todo
  ///
  /// [groupId] 群ID
  /// [userId] 成员ID
  ///
  static Future<MemberEntity?> getSessionMember(String? groupId, String? userId) async {
    var data = await HttpUtils.getInstance()
        .request('group/members/detail', params: {Keys.USER_ID: userId, Keys.GROUP_ID: groupId});
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return MemberEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 设置群成员是否可以抢红包 todo
  ///
  /// [groupId] 群ID
  /// [userId] 成员ID
  ///
  static Future<BaseBean> setSessionMemberVura(String? groupId, String? userId, bool isReceiveRedPacket) async {
    var data = await HttpUtils.getInstance().request('group/setIsReceiveRedPacket',
        params: {Keys.USER_ID: userId, Keys.GROUP_ID: groupId, "isReceiveRedPacket": isReceiveRedPacket ? 1:0},
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 群管理员列表
  ///
  /// [id] 群ID
  ///
  static Future<List<MemberEntity>> getSessionSupAdmin(String? id) async {
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
  static Future<BaseBean> quitSession(String? id) async {
    var data = await HttpUtils.getInstance().request('group/quit/$id', method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 踢出群聊 TODO
  ///
  /// [id] 群ID
  /// [userIds] 被踢出群聊的成员列表
  ///
  static Future<BaseBean> kickMemberFromSession(String? id, List<String?> userIds) async {
    var data = await HttpUtils.getInstance().request('group/kickList',
        params: {Keys.FRIEND_IDS: userIds, Keys.GROUP_ID: id}, method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 解散群聊 TODO
  ///
  /// [id] 群ID
  ///
  static Future<BaseBean> deleteSession(String? id) async {
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
  static Future<MessageEntity?> sendMessage(String? id, SessionType sessionType,
      {String? content,
      MessageType type = MessageType.TEXT,
      List<String?> atUserIds = const [],
      String? receiveNickName,
      String? receiveHeadImage}) async {
    var data = await HttpUtils.getInstance().request("message/${sessionType.name}/send",
        params: {
          if (sessionType == SessionType.group) Keys.GROUP_ID: id,
          if (sessionType == SessionType.private) "recvId": id,
          if (sessionType == SessionType.private) "recvNickName": receiveNickName,
          if (sessionType == SessionType.private) "recvHeadImage": receiveHeadImage,
          Keys.CONTENT: content,
          Keys.TYPE: type.code,
          "receipt": true,
          if (sessionType == SessionType.group) "atUserIds": atUserIds
        },
        showErrorToast: true);
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
  static Future<List<MessageEntity>> getMessages(String? id, SessionType type, {int page = 1, int size = 200}) async {
    var data = await HttpUtils.getInstance().request("message/${type.name}/history",
        params: {
          if (type == SessionType.private) Keys.FRIEND_ID: id,
          if (type == SessionType.group) Keys.GROUP_ID: id,
          Keys.PAGE: page,
          Keys.SIZE: size
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
  static Future getOfflineMessages(String type, {String? groupMinId, String? privateMinId}) async {
    if (type == "group" || type == "all") {
      HttpUtils.getInstance()
          .request('message/group/pullOfflineMessage', params: {Keys.MIN_ID: groupMinId}, method: HttpUtils.GET);
    }
    if (type == "private" || type == "all") {
      HttpUtils.getInstance()
          .request('message/private/pullOfflineMessage', params: {Keys.MIN_ID: privateMinId}, method: HttpUtils.GET);
    }
  }

  /// 已读群聊消息
  ///
  /// [id] 会话ID
  ///
  static Future<BaseBean> readMessage(String? id, SessionType type) async {
    var data = await HttpUtils.getInstance().request('message/${type.name}/readed',
        params: {if (type == SessionType.group) Keys.GROUP_ID: id, if (type == SessionType.private) Keys.FRIEND_ID: id},
        method: HttpUtils.PUT);
    return BaseBean.fromJson(data);
  }

  /// 获取已读用户id TODO
  ///
  /// [id] 群ID
  /// [messageId]
  ///
  static Future<List<MessageEntity>> getReadUsers(String? id, String? messageId, SessionType type) async {
    var data = await HttpUtils.getInstance().request('message/${type.name}/findReadedUsers',
        params: {
          if (type == SessionType.group) Keys.GROUP_ID: id,
          if (type == SessionType.private) Keys.FRIEND_ID: id,
          Keys.MESSAGE_ID: messageId
        },
        method: HttpUtils.GET);
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
  static Future<BaseBean> recallMessage(String? id, SessionType type) async {
    var data = await HttpUtils.getInstance()
        .request('message/${type.name}/recall/$id', method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 设置管理员
  ///
  /// [id] 群ID
  /// [ids] 被设置管理员的用户IDS
  ///
  static Future<BaseBean> setSupAdmin(String? id, List<String?> ids) async {
    var data = await HttpUtils.getInstance()
        .request('group/setSupAdmin', params: {Keys.ADMIN_IDS: ids, Keys.GROUP_ID: id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 移除管理员
  ///
  /// [id] 群ID
  /// [ids] 被移除管理员的用户IDS
  ///
  static Future<BaseBean> removeSupAdmin(String? id, List<String?> ids) async {
    var data = await HttpUtils.getInstance().request('group/resetSupAdmin',
        params: {Keys.GROUP_ID: id, Keys.ADMIN_IDS: ids.toList()}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 群管理员列表
  ///
  /// [id] 群ID
  ///
  static Future<List<MemberEntity>> sessionSupAdmin(String? id) async {
    var data = await HttpUtils.getInstance().request('group/members/supadmin/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MemberEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 群主转让
  ///
  /// [id] 群ID
  /// [userId] 被设置群主的用户ID
  ///
  static Future<BaseBean> setAdmin(String? id, String? userId) async {
    var data = await HttpUtils.getInstance().request('group/setAdmin',
        params: {
          Keys.GROUP_ID: id,
          Keys.ADMIN_IDS: [userId]
        },
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 设置禁言
  ///
  /// [id] 群ID
  /// [ids] 被设置禁言的用户IDS
  ///
  static Future<BaseBean> setMute(String? id, List<String?> ids) async {
    var data = await HttpUtils.getInstance()
        .request('group/mute', params: {Keys.FRIEND_IDS: ids, Keys.GROUP_ID: id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 解除禁言
  ///
  /// [id] 群ID
  /// [ids] 被解除禁言的用户IDS
  ///
  static Future<BaseBean> resetMute(String? id, List<String?> ids) async {
    var data = await HttpUtils.getInstance()
        .request('group/mute/reset', params: {Keys.FRIEND_IDS: ids, Keys.GROUP_ID: id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 被禁言列表
  ///
  /// [id] 群ID
  ///
  static Future<List<MemberEntity>> muteList(String? id) async {
    var data = await HttpUtils.getInstance().request('group/members/mute/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => MemberEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 群配置详情
  ///
  /// [groupId] 群ID
  ///
  static Future<SessionConfigEntity?> getSessionConfig(String? groupId) async {
    var data = await HttpUtils.getInstance().request('group/getConfig/$groupId');
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return SessionConfigEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 群配置
  ///
  /// [groupId] 群ID
  ///
  static Future<BaseBean> setSessionConfig(SessionConfigEntity config) async {
    var data = await HttpUtils.getInstance().request('group/config', params: config.toJson(), showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 发红包
  ///
  static Future<MessageEntity?> sendRedPackage(Map<String, dynamic> params, SessionType type) async {
    var data = await HttpUtils.getInstance().request(
        type == SessionType.private ? 'redPacket/send' : "redPacket/group/send",
        params: params,
        showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return MessageEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 拆红包
  ///
  static Future<RedPackageBean?> openRedPackage(String? id) async {
    var data = await HttpUtils.getInstance().request('redPacket/apartRedPacket/$id', showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return RedPackageBean.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 红包结果
  ///
  static Future<RedPackageResultEntity?> getRedPackageResult(String? id) async {
    var data = await HttpUtils.getInstance().request('redPacket/getRedPacketRecord/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return RedPackageResultEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 检查红包状态
  ///
  static Future<String?> checkRedPackage(String? id) async {
    var data =
        await HttpUtils.getInstance().request('redPacket/check/$id', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return result.data as String;
    } else {
      return null;
    }
  }
}
