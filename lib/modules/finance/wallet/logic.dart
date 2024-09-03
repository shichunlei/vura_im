import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/bill_record_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/repository/common_repository.dart';

class WalletLogic extends BaseListLogic<BillRecordEntity> {
  var type = FeeType.ALL.obs;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<BillRecordEntity>> loadData() async {
    return await CommonRepository.bookMoneyList(page: pageNumber.value, size: pageSize.value, type: type.value);
  }
}
