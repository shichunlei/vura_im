import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/red_package_result.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';

class PackageResultLogic extends BaseObjectLogic<RedPackageResultEntity?> {
  String? id;

  var balance = .0.obs;

  bool myRedPackage = false;

  PackageResultLogic() {
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

  @override
  void onCompleted(RedPackageResultEntity? data) {
    if (data != null) {
      if (data.detailList.isEmpty) {
        balance.value = data.totalAmount;
      } else {
        double _ = .0;
        for (var item in data.detailList) {
          _ += item.amount;
        }
        balance.value = data.totalAmount - _;
      }
    }
  }
}
