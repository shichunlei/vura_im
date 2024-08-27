import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/user_repository.dart';

class PrivacyLogic extends BaseLogic {
  String? id;

  PrivacyLogic() {
    id = Get.find<RootLogic>().user.value?.id;
  }

  Future setVura(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, vura: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateVura(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setSearch(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, search: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateSearch(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setSetGroup(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, setGroup: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateSetGroup(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setProtect(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, protect: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateProtect(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setAddFriend(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, addFriend: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateAddFriend(value ? YorNType.Y : YorNType.N);
    }
  }
}
