import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';

class PackageResultLogic extends BaseObjectLogic<Map> {
  String? id;

  PackageResultLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<Map> loadData() async {
    return await SessionRepository.getRedPackageResult(id);
  }
}
