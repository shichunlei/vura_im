import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/user_repository.dart';

class MyQrCodeLogic extends BaseObjectLogic<UserEntity?> {
  var qrCodeStr = ''.obs;

  String? id;

  MyQrCodeLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<UserEntity?> loadData() async {
    String? qrCode = await UserRepository.getUserQrCode();
    if (qrCode != null) {
      qrCodeStr.value = qrCode;
      return await UserRepository.getUserInfoById(id);
    } else {
      return null;
    }
  }
}
