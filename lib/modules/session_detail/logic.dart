import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/session_repository.dart';

class SessionDetailLogic extends BaseObjectLogic<SessionEntity?> {
  int? id;
  late bool isGroup;

  SessionDetailLogic() {
    id = Get.arguments[Keys.ID];
    isGroup = Get.arguments?["isGroup"] ?? true;
  }

  @override
  void onInit() {
    initData();
    super.onInit();
    if (isGroup) getMembers();
  }

  @override
  Future<SessionEntity?> loadData() async {
    return await SessionRepository.getSessionInfo(id);
  }

  /// 踢人
  Future deleteMembers() async {
    showLoading();
    BaseBean result = await SessionRepository.kickMemberFromSession(id,0);
    hiddenLoading();
  }

  /// 邀请人
  Future inviteMembers(List<UserEntity> users) async {
    showLoading();
    BaseBean result = await SessionRepository.inviteMembers(id, users.map((item) => item.id).toList());
    hiddenLoading();
    if (result.code == 200) getMembers();
  }

  /// 退出群聊
  Future quitSession() async {
    showLoading();
    BaseBean result = await SessionRepository.quitSession(id);
    hiddenLoading();
  }

  RxList<MemberEntity> members = RxList<MemberEntity>([]);

  Future getMembers() async {
    members.value = await SessionRepository.getSessionMembers(id);
  }
}
