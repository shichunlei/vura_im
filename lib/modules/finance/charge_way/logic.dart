import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/receiving_payment_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/string_util.dart';

class ChargeWayLogic extends BaseListLogic<ReceivingPaymentEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<ReceivingPaymentEntity>> loadData() async {
    UserEntity? user = await UserRepository.getUserInfo();
    if (user != null) {
      if (StringUtil.isEmpty(user.walletCard) || StringUtil.isEmpty(user.walletRemark)) {
        return [];
      }
      return [ReceivingPaymentEntity(walletCard: user.walletCard, walletRemark: user.walletRemark)];
    } else {
      return [];
    }
  }

  void updateWay(ReceivingPaymentEntity way) {
    list.clear();
    list.add(way);
    list.refresh();
  }
}
