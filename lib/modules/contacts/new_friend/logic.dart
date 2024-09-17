import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/apply_user.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/utils/toast_util.dart';

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
      if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
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
}
