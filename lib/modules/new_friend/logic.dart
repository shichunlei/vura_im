import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/apply_user.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/modules/home/contacts/logic.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class NewFriendLogic extends BaseListLogic<ApplyUserEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<ApplyUserEntity>> loadData() async {
    return await ContactsRepository.applyList(size: pageSize.value, page: pageNumber.value);
  }

  Future agree(int index) async {
    showLoading();
    BaseBean result = await ContactsRepository.agree(list[index].applyId);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "已同意");
      list[index].applyStatus = "1";
      list.refresh();
      try {
        Get.find<ContactsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  Future refused(int index) async {
    showLoading();
    BaseBean result = await ContactsRepository.refused(list[index].applyId);
    hiddenLoading();
    if (result.code == 200) {
      list[index].applyStatus = "2";
      list.refresh();
      showToast(text: "已拒绝");
    }
  }

  Future ignore(int index) async {
    showLoading();
    BaseBean result = await ContactsRepository.ignore(list[index].applyId);
    hiddenLoading();
    if (result.code == 200) {}
  }
}
