import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/session_repository.dart';

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
    return await SessionRepository.getSessionInfo(id);
  }
}
