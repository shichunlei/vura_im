import 'package:vura/base/base_logic.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/enum_to_string.dart';
import 'package:vura/utils/sp_util.dart';

class LanguageLogic extends BaseLogic {
  late LocalType localType;

  LanguageLogic() {
    localType = EnumToString.fromString(LocalType.values, SpUtil.getString("language", defValue: LocalType.zh_CN.name));
  }
}
