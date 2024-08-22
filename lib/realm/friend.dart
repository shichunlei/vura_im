import 'package:get/get.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/modules/home/contacts/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/utils/log_utils.dart';
import 'package:realm/realm.dart';

part 'friend.realm.dart';

@RealmModel()
class _Friend {
  @PrimaryKey()
  String? _id;
  String? id;
  String? userId;
  String? nickName;
  String? userName;
  int sex = -1;
  String? signature;
  String? headImage;
  String? headImageThumb;
  String? indexTag;
  bool isDeleted = false;
  String? friendship;
}

class FriendRealm {
  final Realm _realm;

  FriendRealm({required Realm realm}) : _realm = realm;

  /// 查询所有好友
  Future<List<UserEntity>> queryAllFriends() async {
    Log.d("queryAllByCompanyId=====================${Get.find<RootLogic>().user.value?.id}");
    return _realm
        .all<Friend>()
        .query(r"userId == $0 AND isDeleted == $1", ["${Get.find<RootLogic>().user.value?.id}", true])
        .map((item) => friendRealmToEntity(item))
        .toList();
  }

  /// 查询好友
  Future<UserEntity?> querySessionById(int? id) async {
    Log.d("querySessionById=====================$id");
    Friend? user = findOne("${Get.find<RootLogic>().user.value?.id}-$id");
    if (user != null) {
      return friendRealmToEntity(user);
    } else {
      return null;
    }
  }

  /// 更新/插入数据
  Future<Friend> upsert(Friend user) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----------------->${user.id}");
      return _realm.add(user, update: true);
    });
  }

  Future deleteFriend(String? id) async {
    Friend? friend = findOne("${Get.find<RootLogic>().user.value?.id}-$id");
    if (friend != null) {
      await _realm.writeAsync(() {
        friend.isDeleted = true;
      });
      Log.d("deleteChannel===${friend.id}================>${friend.toEJson()}");
      try {
        Get.find<ContactsLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
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
      friendship: user.friendship,
      tagIndex: user.indexTag);
}

Friend friendEntityToRealm(UserEntity user) {
  return Friend("${Get.find<RootLogic>().user.value?.id}-${user.id}",
      id: user.id,
      userName: user.userName,
      sex: user.sex,
      userId: Get.find<RootLogic>().user.value?.id,
      nickName: user.nickName,
      headImage: user.headImage,
      headImageThumb: user.headImageThumb,
      signature: user.signature,
      friendship: user.friendship,
      indexTag: user.tagIndex);
}
