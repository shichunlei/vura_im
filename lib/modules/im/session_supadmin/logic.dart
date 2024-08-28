import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/session_detail/group/logic.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/log_utils.dart';

class SessionSupAdminLogic extends BaseListLogic<MemberEntity> {
  String? id;

  SessionSupAdminLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<MemberEntity>> loadData() async {
    return await SessionRepository.sessionSupAdmin(id);
  }

  Future addSupAdmin(List<MemberEntity> users) async {
    showLoading();
    BaseBean result = await SessionRepository.setSupAdmin(id, users.map((item) => item.userId).toList());
    hiddenLoading();
    if (result.code == 200) {
      list.addAll(users);
      list.refresh();
      try {
        Get.find<GroupSessionDetailLogic>(tag: id).getMembers();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  Future removeSupAdmin() async {}
}
