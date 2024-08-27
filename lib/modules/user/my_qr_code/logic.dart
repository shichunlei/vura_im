import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/file_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:screenshot/screenshot.dart';

class MyQrCodeLogic extends BaseObjectLogic<UserEntity?> {
  ScreenshotController screenshotController = ScreenshotController();

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

  Future save() async {
    screenshotController.capture().then((Uint8List? image) async {
      if (image == null) return;
      await FileUtil.saveScreen(image);
    }).catchError((e) {
      Log.e(e.toString());
    });
  }
}
