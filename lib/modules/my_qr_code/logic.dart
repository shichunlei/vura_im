import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/file_util.dart';
import 'package:im/utils/log_utils.dart';
import 'package:screenshot/screenshot.dart';

class MyQrCodeLogic extends BaseObjectLogic<UserEntity?> {
  ScreenshotController screenshotController = ScreenshotController();

  var qrCodeStr = 'ergmelkmweorgew'.obs;

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
    return await UserRepository.getUserInfoById(id);
  }

  Future save() async {
    screenshotController.capture().then((Uint8List? image) async {
      if (image == null) return;
      await FileUtil.saveScreen(image);
    }).catchError((e) {
      Log.e(e.toString());
    });
  }
}
