import 'dart:io';
import 'dart:math';

import 'package:app_installer/app_installer.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/account_entity.dart';
import 'package:vura/entities/login_entity.dart';
import 'package:vura/entities/rate_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/entities/version_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/realm/account.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/realm/friend.dart';
import 'package:vura/realm/message.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/account_db_util.dart';
import 'package:vura/utils/enum_to_string.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/dialog/version_upgrade_dialog.dart';

class RootLogic extends BaseLogic {
  late Realm realm;

  var exchangeRate = 7.15.obs;

  var textSizeType = TextSizeType.one.obs;

  RootLogic() {
    var config = Configuration.local([Channel.schema, Message.schema, Friend.schema, Account.schema],
        schemaVersion: 4, shouldDeleteIfMigrationNeeded: false);
    realm = Realm(config);

    textSizeType.value = EnumToString.fromString(
        TextSizeType.values, SpUtil.getString(Keys.TEXT_SIZE, defValue: TextSizeType.one.name),
        defaultValue: TextSizeType.one)!;
  }

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
    getRate();
  }

  var token = Rx<LoginEntity?>(null);

  var user = Rx<UserEntity?>(null);

  void setUserInfo(UserEntity? user) {
    this.user.value = user;
    AccountRealm(realm: Get.find<RootLogic>().realm).update(AccountEntity(
        userName: user?.userName,
        nickName: user?.nickName,
        headImageThumb: user?.headImageThumb,
        headImage: user?.headImage,
        userNo: user?.no));
  }

  void updateUserAvatar({String? headImage, String? headImageThumb}) {
    user.value?.headImage = headImage;
    user.value?.headImageThumb = headImageThumb;
    user.refresh();
    AccountRealm(realm: Get.find<RootLogic>().realm).update(AccountEntity(
        userName: user.value?.userName,
        nickName: user.value?.nickName,
        headImageThumb: user.value?.headImageThumb,
        headImage: user.value?.headImage,
        userNo: user.value?.no));
  }

  void updateNickName(String? nickName) {
    user.value?.nickName = nickName;
    user.refresh();
    AccountRealm(realm: Get.find<RootLogic>().realm).update(AccountEntity(
        userName: user.value?.userName,
        nickName: user.value?.nickName,
        headImageThumb: user.value?.headImageThumb,
        headImage: user.value?.headImage,
        userNo: user.value?.no));
  }

  void updateCardId(String? cardId) {
    user.value?.no = cardId;
    user.refresh();
    AccountRealm(realm: Get.find<RootLogic>().realm).update(AccountEntity(
        userName: user.value?.userName,
        nickName: user.value?.nickName,
        headImageThumb: user.value?.headImageThumb,
        headImage: user.value?.headImage,
        userNo: cardId));
  }

  void updatePayPassword(String? password) {
    user.value?.payPassword = password;
    user.refresh();
  }

  void updateWallet(String? walletCard, String? walletRemark) {
    user.value?.walletCard = walletCard;
    user.value?.walletRemark = walletRemark;
    user.refresh();
  }

  void updateVura(YorNType value) {
    user.value?.vura = value;
    user.refresh();
  }

  void updateSetGroup(YorNType value) {
    user.value?.setGroup = value;
    user.refresh();
  }

  void updateAddFriend(YorNType value) {
    user.value?.addFriend = value;
    user.refresh();
  }

  void updateProtect(YorNType value) {
    user.value?.protect = value;
    user.refresh();
  }

  void updateSearch(YorNType value) {
    user.value?.search = value;
    user.refresh();
  }

  bool get isLogin => StringUtil.isNotEmpty(SpUtil.getString(Keys.ACCESS_TOKEN));

  void getUserInfo() async {
    if (isLogin && null == user.value) user.value = await UserRepository.getUserInfo();
  }

  void refreshUserInfo() async {
    user.value = await UserRepository.getUserInfo();
  }

  void updateFontSize(TextSizeType value) {
    textSizeType.value = value;
  }

  /// 获取汇率
  void getRate() async {
    RateEntity? result = await CommonRepository.getRate();
    if (result != null) {
      exchangeRate.value = result.value ?? 7.15;
    } else {
      exchangeRate.value = 7.15;
    }
  }

  VersionEntity? version;

  Future checkVersion({bool isAuto = true}) async {
    if (!isAuto) showLoading();
    version = await CommonRepository.checkVersion();
    hiddenLoading();
    if (version != null && version!.versionCode > int.parse(AppConfig.version!.buildNumber)) {
      Get.dialog(const VersionUpgradeDialog(), barrierDismissible: false);
    } else {
      if (!isAuto) showToast(text: "No Updates".tr);
    }
  }

  var progress = .0.obs;

  void goStore() {
    AppInstaller.goStore("", "", review: false);
  }

  var isDownloading = false.obs;
  late File file;

  /// 安装apk
  Future downloadAndroid() async {
    isDownloading.value = true;
    progress.value = .0;
    Directory? storageDir = await getExternalStorageDirectory();
    String saveName = '${storageDir?.path}/VURA v${version!.version}.apk';
    file = File(saveName);
    if (file.existsSync()) file.deleteSync();
    file.createSync();
    try {
      await Dio().download("${version!.download}", saveName, onReceiveProgress: (num received, num total) {
        if (total > 0) {
          progress.value = min(double.parse((received / total).toStringAsFixed(2)), 1);
          if (received >= total) installApk();
        }
      });
    } catch (e) {
      Log.d('download failed:$e');
      showToast(text: "APP下载失败");
      isDownloading.value = false;
      progress.value = .0;
    }
  }

  /// 安装APK
  void installApk() async {
    await AppInstaller.installApk(file.path);
  }
}
