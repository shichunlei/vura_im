import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/receiving_payment_entity.dart';

class ChargeWayLogic extends BaseListLogic<ReceivingPaymentEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<ReceivingPaymentEntity>> loadData() async {
    return [
      ReceivingPaymentEntity(id: "12143423", address: "234234243rr43f323ed34444434", remark: "张三"),
      ReceivingPaymentEntity(id: "34534535", address: "234234243rr43f323ed44434", remark: "李四")
    ];
  }

  void updateWay(ReceivingPaymentEntity way) {
    if (list.any((e) => e.id == way.id)) list.removeWhere((e) => e.id == way.id);
    list.add(way);
    list.refresh();
  }
}
