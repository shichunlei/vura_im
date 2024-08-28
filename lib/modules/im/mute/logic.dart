import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';

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
