import 'package:im/entities/base_bean.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/utils/http_utils.dart';

class ContactsRepository {
  /// 好友列表
  ///
  static Future<List<UserEntity>> getFriendList() async {
    var data = await HttpUtils.getInstance().request('/friend/list', method: HttpUtils.GET);
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
  static Future<UserEntity?> getFriendInfo(int id) async {
    var data = await HttpUtils.getInstance().request('/friend/find/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return UserEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 添加好友
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> addFriend(int id) async {
    var data = await HttpUtils.getInstance().request('/friend/find/$id', params: {"friendId": id});
    return BaseBean.fromJson(data);
  }

  /// 删除好友
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> deleteFriend(int id) async {
    var data =
        await HttpUtils.getInstance().request('/friend/delete/$id', params: {"friendId": id}, method: HttpUtils.DELETE);
    return BaseBean.fromJson(data);
  }

  /// 更新好友信息
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> updateFriend(int id, {String? nickName, String? headImage}) async {
    var data = await HttpUtils.getInstance().request('/friend/update',
        params: {"id": id, if (nickName != null) "nickName": nickName, if (headImage != null) "headImage": headImage},
        method: HttpUtils.PUT);
    return BaseBean.fromJson(data);
  }

  /// 添加黑名单
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> addFriendToBlack(int id) async {
    var data = await HttpUtils.getInstance().request('friend/black/$id');
    return BaseBean.fromJson(data);
  }

  /// 移除黑名单
  ///
  /// [id] 用户ID
  ///
  static Future<BaseBean> removeFriendFromBlack(int id) async {
    var data = await HttpUtils.getInstance().request('friend/black/reset/$id');
    return BaseBean.fromJson(data);
  }

  /// 黑名单列表
  ///
  static Future<List<UserEntity>> getBlackList() async {
    var data = await HttpUtils.getInstance().request('/friend/black/list', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => UserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
