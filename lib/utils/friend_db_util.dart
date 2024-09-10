import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/realm/friend.dart';

import 'enum_to_string.dart';
import 'log_utils.dart';

class FriendRealm {
  final Realm _realm;

  FriendRealm({required Realm realm}) : _realm = realm;

  /// 查询所有好友
  Future<List<UserEntity>> queryAllFriends() async {
    Log.d("queryAllFriends=====================${AppConfig.userId}");
    return _realm
        .all<Friend>()
        .query(r"userId == $0 AND isDeleted == $1", ["${AppConfig.userId}", false])
        .map((item) => friendRealmToEntity(item))
        .toList();
  }

  /// 查询好友
  Future<UserEntity?> queryFriendById(String? id) async {
    Log.d("querySessionById=====================$id");
    Friend? user = findOne("${AppConfig.userId}-$id");
    if (user != null) {
      return friendRealmToEntity(user);
    } else {
      return null;
    }
  }

  /// 查询好友昵称
  Future<String?> queryFriendNicknameById(String? id) async {
    Log.d("querySessionById=====================$id");
    Friend? user = findOne("${AppConfig.userId}-$id");
    if (user != null) {
      return user.nickName;
    } else {
      return null;
    }
  }

  /// 更新/插入数据
  Future<Friend> upsert(Friend user) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----friend------------->${user.id}");
      return _realm.add(user, update: true);
    });
  }

  Future deleteFriend(String? id) async {
    Friend? friend = findOne("${AppConfig.userId}-$id");
    if (friend != null) {
      await _realm.writeAsync(() {
        friend.isDeleted = true;
        friend.friendship = YorNType.N.name;
      });
      Log.d("deleteChannel===${friend.id}================>${friend.toEJson()}");
      if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
    }
  }

  Friend? findOne(String? id) {
    return _realm.find<Friend>(id);
  }
}

UserEntity friendRealmToEntity(Friend user) {
  return UserEntity(
      id: user.id,
      userName: user.userName,
      sex: user.sex,
      nickName: user.nickName,
      headImage: user.headImage,
      headImageThumb: user.headImageThumb,
      signature: user.signature,
      no: user.userNo,
      friendship: EnumToString.fromString(YorNType.values, user.friendship, defaultValue: YorNType.Y)!,
      tagIndex: user.indexTag);
}

Friend friendEntityToRealm(UserEntity user) {
  return Friend("${AppConfig.userId}-${user.id}",
      id: user.id,
      userName: user.userName,
      sex: user.sex,
      userId: AppConfig.userId,
      nickName: user.nickName,
      headImage: user.headImage,
      headImageThumb: user.headImageThumb,
      signature: user.signature,
      friendship: user.friendship.name,
      indexTag: user.tagIndex,
      userNo: user.no,
      isDeleted: false);
}
