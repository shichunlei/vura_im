import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/home/session/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/utils/log_utils.dart';

class PrivateSessionDetailLogic extends BaseObjectLogic<SessionEntity?> {
  int? id;

  PrivateSessionDetailLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<SessionEntity?> loadData() async {
    return await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id);
  }

  Future setTop(bool value) async {
    bean.value!.moveTop = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelTop(id, value).then((item) {
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    });
  }

  Future setDisturb(bool value) async {
    bean.value!.isDisturb = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelDisturb(id, value).then((item) {
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    });
  }
}
