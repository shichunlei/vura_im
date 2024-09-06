import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/utils/enum_to_string.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';

class LanguageLogic extends BaseLogic {
  var localType = LocalType.zh_CN.obs;

  LanguageLogic() {
    Log.d("ddddddddddddddddddddd=============${Get.locale!.countryCode}------${Get.locale!.languageCode}");

    localType.value = EnumToString.fromString(LocalType.values, Get.locale.toString(), defaultValue: LocalType.zh_CN)!;
  }

  void setLanguage(LocalType type) {
    localType.value = type;
    Get.updateLocale(type.locale);
    SpUtil.setString(Keys.LANGUAGE, type.name);
  }
}
