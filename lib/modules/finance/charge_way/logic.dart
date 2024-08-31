import 'package:vura/base/base_list_logic.dart';

class ChargeWayLogic extends BaseListLogic<Map> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<Map>> loadData() async {
    return [];
  }
}
