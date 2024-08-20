import 'package:get/get.dart';
import 'package:im/entities/login_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/realm/channel.dart';
import 'package:im/realm/message.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/sp_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:realm/realm.dart' hide Session;

class RootLogic extends GetxController {
  late Realm realm;

  RootLogic() {
    var config =
        Configuration.local([Channel.schema, Message.schema], schemaVersion: 1, shouldDeleteIfMigrationNeeded: true);
    realm = Realm(config);
  }

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
  }

  var token = Rx<LoginEntity?>(null);

  var user = Rx<UserEntity?>(null);

  void setUserInfo(UserEntity? user) {
    this.user.value = user;
  }

  void updateUserAvatar({String? headImage, String? headImageThumb}) {
    user.value?.headImage = headImage;
    user.value?.headImageThumb = headImageThumb;
    user.refresh();
  }

  void updateNickName(String? nickName) {
    user.value?.nickName = nickName;
    user.refresh();
  }

  bool get isLogin => StringUtil.isNotEmpty(SpUtil.getString(Keys.ACCESS_TOKEN));

  void getUserInfo() async {
    if (isLogin && null == user.value) user.value = await UserRepository.getUserInfo();
  }
}
