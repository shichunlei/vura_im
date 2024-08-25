import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/session_repository.dart';

class MuteLogic extends BaseListLogic<MemberEntity> {
  String? id;

  MuteLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<MemberEntity>> loadData() async {
    return SessionRepository.muteList(id);
  }

  Future resetMute(int index) async {
    showLoading();
    BaseBean result = await SessionRepository.resetMute(id, [list[index].userId]);
    hiddenLoading();
    if (result.code == 200) {}
  }
}
