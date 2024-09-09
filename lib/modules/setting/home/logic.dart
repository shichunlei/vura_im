import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/file_util.dart';
import 'package:vura/widgets/dialog/tip_dialog.dart';

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

  Future checkVersion() async {
    showLoading();
    // todo
    Future.delayed(const Duration(seconds: 1), () {
      hiddenLoading();
      show(builder: (_) {
        return CustomTipDialog(title: "版本更新", content: "已是最新版本", btnText: "我知道了", onConfirm: () {});
      });
    });
  }
}
