import 'package:get/get.dart';
import 'package:im/entities/login_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/realm/channel.dart';
import 'package:im/realm/friend.dart';
import 'package:im/realm/message.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/sp_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:realm/realm.dart' hide Session;

class RootLogic extends GetxController {
  late Realm realm;

  RootLogic() {
    var config = Configuration.local([Channel.schema, Message.schema, Friend.schema],
        schemaVersion: 1, shouldDeleteIfMigrationNeeded: true);
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
}
