import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/red_package_result.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';

class TransferResultLogic extends BaseObjectLogic<RedPackageResultEntity?> {
  String? id;

  bool myRedPackage = false;

  TransferResultLogic() {
    id = Get.arguments[Keys.ID];
    myRedPackage = Get.arguments?["myRedPackage"] ?? false;
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<RedPackageResultEntity?> loadData() async {
    return await SessionRepository.getRedPackageResult(id);
  }
}
