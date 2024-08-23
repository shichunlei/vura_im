import 'package:im/entities/apply_user.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/utils/http_utils.dart';

class ContactsRepository {
  /// 好友列表
  ///
  static Future<List<UserEntity>> getFriendList() async {
    var data = await HttpUtils.getInstance().request('friend/list', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => UserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 获取好友信息
  ///
  /// [id] 用户ID
  ///
  static Future<UserEntity?> getFriendInfo(String? id) async {
    var data = await HttpUtils.getInstance().request('friend/find/$id', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return UserEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 删除好友
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> deleteFriend(String? id) async {
    var data = await HttpUtils.getInstance()
        .request('friend/delete/$id', params: {"friendId": id}, method: HttpUtils.DELETE, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 更新好友信息 TODO
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> updateFriend(String? id, {String? nickName, String? headImage}) async {
    var data = await HttpUtils.getInstance().request('friend/update',
        params: {
          Keys.ID: id,
          if (nickName != null) "nickName": nickName,
          if (headImage != null) "headImage": headImage
        },
        method: HttpUtils.PUT,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 添加黑名单
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> addFriendToBlack(String? id) async {
    var data = await HttpUtils.getInstance().request('friend/black/$id', showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 移除黑名单 TODO
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> removeFriendFromBlack(String? id) async {
    var data = await HttpUtils.getInstance().request('friend/black/reset/$id', showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 黑名单列表
  ///
  static Future<List<UserEntity>> getBlackList() async {
    var data = await HttpUtils.getInstance().request('friend/black/list', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => UserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 好友申请列表 TODO
  ///
  static Future<List<ApplyUserEntity>> applyList({int page = 1, int size = 20}) async {
    var data =
        await HttpUtils.getInstance().request('apply/listByPage', params: {"currentPage": page, "pageSize": size});
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return (result.data["records"] as List).map((item) => ApplyUserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 同意申请 TODO
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> agree(String? id) async {
    var data = await HttpUtils.getInstance().request('apply/agree', params: {"applyId": id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 拒绝申请 TODO
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> refused(String? id) async {
    var data = await HttpUtils.getInstance().request('apply/refused', params: {"applyId": id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 忽略申请 TODO
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> ignore(String? id) async {
    var data = await HttpUtils.getInstance().request('apply/ignore', params: {"applyId": id}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 申请添加好友
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> apply(String? id, {FriendSourceType source = FriendSourceType.NEAR, String? reason}) async {
    var data = await HttpUtils.getInstance().request('apply/applyFriend',
        params: {Keys.USER_ID: id, "reason": reason ?? "申请添加您为好友", "source": source.name}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }
}
