import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/repository/session_repository.dart';

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
    if (result.code == 200) noMute(userId);
  }

  /// 禁言某人
  Future setMute(String? id, String? userId) async {
    showLoading();
    BaseBean result = await SessionRepository.setMute(id, [userId]);
    hiddenLoading();
    if (result.code == 200) {
      members.firstWhere((item) => item.userId == userId).isMute = YorNType.Y;
      members.refresh();
    }
  }

  /// 将某用户踢出群聊
  Future removeMemberFromGroup(String? id, String? userId) async {
    showLoading();
    BaseBean result = await SessionRepository.kickMemberFromSession(id, [userId]);
    hiddenLoading();
    if (result.code == 200) removeMember(userId);
  }

  void removeMember(String? userId) {
    members.removeWhere((item) => item.userId == userId);
    members.refresh();
  }

  void removeMembers(List<String?> userIds) {
    for (var userId in userIds) {
      members.removeWhere((item) => item.userId == userId);
    }
    members.refresh();
  }

  void noMute(String? userId) {
    members.firstWhere((item) => item.userId == userId).isMute = YorNType.N;
    members.refresh();
  }
}
