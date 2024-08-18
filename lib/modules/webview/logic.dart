import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/utils/log_utils.dart';

class WebViewLogic extends BaseLogic {
  String? url;
  String? title;

  final loading = true.obs;

  WebViewLogic() {
    url = Get.arguments["url"];
    Log.d("$url");
    title = Get.arguments["title"];
  }
}
