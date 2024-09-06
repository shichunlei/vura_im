import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class PersonalLogic extends BaseObjectLogic<UserEntity?> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<UserEntity?> loadData() async {
    return await UserRepository.getUserInfo();
  }

  /// 修改昵称
  Future updateNickname(String nickname) async {
    showLoading();
    BaseBean result =
        await UserRepository.updateUser(bean.value?.id, userName: bean.value?.userName, nickName: nickname);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "修改成功");
      bean.value?.nickName = nickname;
      bean.refresh();
      try {
        Get.find<RootLogic>().updateNickName(nickname);
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  /// 修改头像
  Future updateAvatar(String path) async {
    showLoading();
    ImageEntity? file = await CommonRepository.uploadImage(path);
    if (file != null) {
      BaseBean result = await UserRepository.updateUser(bean.value?.id,
          userName: bean.value?.userName,
          nickName: bean.value?.nickName,
          headImage: file.originUrl,
          headImageThumb: file.thumbUrl);
      hiddenLoading();
      if (result.code == 200) {
        showToast(text: "修改成功");
        bean.value?.headImage = file.originUrl;
        bean.value?.headImageThumb = file.thumbUrl;
        bean.refresh();
        try {
          Get.find<RootLogic>().updateUserAvatar(headImage: file.originUrl, headImageThumb: file.thumbUrl);
        } catch (e) {
          Log.e(e.toString());
        }
      }
    } else {
      hiddenLoading();
    }
  }

  /// 修改用户NO
  Future updateNo(String no) async {
    showLoading();
    BaseBean result = await UserRepository.updateUser(bean.value?.id,
        userName: bean.value?.userName, no: no, nickName: bean.value?.nickName);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "修改成功");
      bean.value?.cardId = no;
      bean.refresh();
      try {
        Get.find<RootLogic>().updateCardId(no);
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }
}
