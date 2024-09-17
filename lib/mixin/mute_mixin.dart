import 'dart:convert';

import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/session_db_util.dart';

mixin SessionMembersMixin on BaseLogic {
  RxList<MemberEntity> members = RxList<MemberEntity>([]);

  Future getMembers(String? id) async {
    members.value = await SessionRepository.getSessionMembers(id);
  }

  /// 解除禁言
  Future resetMute(String? id, String? userId) async {
    showLoading();
    BaseBean result = await SessionRepository.resetMute(id, [userId]);
    hiddenLoading();
    if (result.code == 200) {
      noMute(userId);
      SessionRepository.sendMessage(id, SessionType.group,
          content: json.encode({"userId": userId}), type: MessageType.UPDATE_MEMBER_UN_MUTE);
    }
  }

  /// 禁言某人
  Future setMute(String? id, String? userId) async {
    showLoading();
    BaseBean result = await SessionRepository.setMute(id, [userId]);
    hiddenLoading();
    if (result.code == 200) {
      members.firstWhere((item) => item.userId == userId).isMute = YorNType.Y;
      members.refresh();

      SessionRepository.sendMessage(id, SessionType.group,
          content: json.encode({"userId": userId}), type: MessageType.UPDATE_MEMBER_MUTE);
    }
  }

  /// 将某用户踢出群聊
  Future removeMemberFromGroup(String? id, String? userId) async {
    showLoading();
    BaseBean result = await SessionRepository.kickMemberFromSession(id, [userId]);
    hiddenLoading();
    if (result.code == 200) removeMember(id, userId);
  }

  void removeMember(String? id, String? userId) {
    members.removeWhere((item) => item.userId == userId);
    members.refresh();
    if (userId == Get.find<RootLogic>().user.value?.id) {
      SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.group);
      // 退群的人有当前用户
      Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  void removeMembers(String? id, List<String?> userIds) {
    for (var userId in userIds) {
      members.removeWhere((item) => item.userId == userId);
    }
    members.refresh();
    if (userIds.any((userId) => userId == Get.find<RootLogic>().user.value?.id)) {
      SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.group);
      // 被踢的人有当前用户
      Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  void noMute(String? userId) {
    members.firstWhere((item) => item.userId == userId).isMute = YorNType.N;
    members.refresh();
  }

  void mute(String? userId) {
    members.firstWhere((item) => item.userId == userId).isMute = YorNType.Y;
    members.refresh();
  }

  void setSupAdmin(List<String?> userIds) {
    for (var userId in userIds) {
      members.firstWhere((item) => item.userId == userId).isSupAdmin = YorNType.Y;
    }
    members.refresh();
  }

  void resetSupAdmin(List<String?> userIds) {
    for (var userId in userIds) {
      members.firstWhere((item) => item.userId == userId).isSupAdmin = YorNType.N;
    }
    members.refresh();
  }
}
