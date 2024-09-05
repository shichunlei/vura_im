import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/mixin/friend_mixin.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/im/chat/logic.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/log_utils.dart';

class SessionMemberLogic extends BaseObjectLogic<MemberEntity?> with FriendMixin {
  String? userId;
  String? groupId;
  late bool isAdmin; // 是否为群主

  SessionMemberLogic() {
    userId = Get.arguments[Keys.ID];
    groupId = Get.arguments[Keys.GROUP_ID];
    isAdmin = Get.arguments?["isAdmin"] ?? false;
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<MemberEntity?> loadData() async {
    return await SessionRepository.getSessionMember(groupId, userId);
  }

  Future removeFromBlacklist() async {
    showLoading();
    BaseBean result = await ContactsRepository.removeFriendFromBlack(userId);
    hiddenLoading();
    if (result.code == 200) {
      bean.value?.friendship == YorNType.N;
      bean.refresh();
      try {
        Get.find<ContactsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 禁止抢红包 TODO
  Future setProhibitVure(bool value) async {
    showLoading();
    BaseBean result = await SessionRepository.setSessionMemberVura(groupId, userId, value);
    hiddenLoading();
    if (result.code == 200) {
      bean.value?.isVure = value ? YorNType.N : YorNType.Y;
      try {
        Get.find<ChatLogic>(tag: groupId).getMembers(groupId);
      } catch (e) {
        Log.e(e.toString());
      }
    } else {}
  }
}
