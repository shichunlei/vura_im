import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/bill_record_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/repository/common_repository.dart';

class WalletLogic extends BaseListLogic<BillRecordEntity> {
  var type = FeeType.ALL.obs;
  var startTime = Rx<DateTime?>(null);
  var endTime = Rx<DateTime?>(null);

  var showHeader = false.obs;

  final ScrollController scrollController = ScrollController();

  WalletLogic() {
    scrollController.addListener(_onScroll);
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<BillRecordEntity>> loadData() async {
    return await CommonRepository.bookMoneyList(
        page: pageNumber.value,
        size: pageSize.value,
        type: type.value,
        startDate: startTime.value,
        endDate: endTime.value);
  }

  @override
  void onCompleted(List<BillRecordEntity> data) {
    hasMoreData.value = data.length >= pageSize.value;
  }

  var hasMoreData = false.obs;

  void _onScroll() {
    if (hasMoreData.value && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
