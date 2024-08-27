import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/file_util.dart';

class SettingLogic extends BaseLogic {
  var cacheSize = "0 B".obs;

  @override
  void onInit() {
    getCSize();
    super.onInit();
  }

  void getCSize() async {
    double size = await FileUtil.loadCache();
    cacheSize.value = FileUtil.renderSize(size);
  }

  void clearCache() async {
    await FileUtil.clearCache().then((value) {
      getCSize();
    });
  }
}
