import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';

class LineLogic extends BaseListLogic<Map> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<Map>> loadData() async {
    return [{}, {}, {}, {}];
  }

  var selectIndex = 0.obs;
}
