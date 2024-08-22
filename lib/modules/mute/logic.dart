import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/global/keys.dart';

class MuteLogic extends BaseListLogic<MemberEntity> {
  int? id;

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
    return [];
  }
}
