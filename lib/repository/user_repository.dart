import 'package:im/entities/base_bean.dart';
import 'package:im/entities/login_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/utils/http_utils.dart';
import 'package:im/utils/sp_util.dart';

class UserRepository {
  /// 登录
  ///
  /// [userName] 用户名
  /// [password] 密码
  ///
  static Future<UserEntity?> login({String? userName, String? password}) async {
    var data = await HttpUtils.getInstance()
        .request('login', params: {"userName": userName, "password": password, "terminal": 1}, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      LoginEntity? login = LoginEntity.fromJson(result.data);

      SpUtil.setString(Keys.ACCESS_TOKEN, "${login.accessToken}");
      SpUtil.setString(Keys.REFRESH_TOKEN, "${login.refreshToken}");
      SpUtil.setString("accessTokenExpiresIn", "${login.accessTokenExpiresIn}");
      SpUtil.setString("refreshTokenExpiresIn", "${login.refreshTokenExpiresIn}");

      return await getUserInfo();
    } else {
      return null;
    }
  }

  /// 注册
  ///
  /// [userName] 用户名
  /// [password] 密码
  /// [nickName] 昵称
  ///
  static Future<BaseBean> register({String? userName, String? password, String? nickName}) async {
    var data = await HttpUtils.getInstance().request('register',
        params: {"userName": userName, "password": password, "nickName": nickName}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 修改密码 TODO
  ///
  /// [oldPassword] 旧密码
  /// [newPassword] 新密码
  ///
  static Future<BaseBean> updatePassword({String? oldPassword, String? newPassword}) async {
    var data = await HttpUtils.getInstance().request('modifyPwd',
        params: {"oldPassword": oldPassword, "newPassword": newPassword}, method: HttpUtils.PUT, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 刷新token
  ///
  static Future<BaseBean> refreshToken() async {
    var data = await HttpUtils.getInstance().request('refreshToken', method: HttpUtils.PUT, refreshToken: true);

    LoginEntity? login = LoginEntity.fromJson(data[Keys.DATA]);

    SpUtil.setString(Keys.ACCESS_TOKEN, "${login.accessToken}");
    SpUtil.setString(Keys.REFRESH_TOKEN, "${login.refreshToken}");
    SpUtil.setString("accessTokenExpiresIn", "${login.accessTokenExpiresIn}");
    SpUtil.setString("refreshTokenExpiresIn", "${login.refreshTokenExpiresIn}");

    return BaseBean.fromJson(data);
  }

  /// 修改用户信息 TODO
  ///
  /// [id] ID
  /// [userName] 用户名
  /// [nickName] 昵称
  ///
  static Future<BaseBean> updateUser(int id,
      {String? userName,
      String? nickName,
      int? sex,
      String? signature,
      String? headImage,
      String? headImageThumb}) async {
    var data = await HttpUtils.getInstance().request('user/update',
        params: {
          Keys.ID: id,
          "userName": userName,
          "nickName": nickName,
          if (sex != null) "sex": sex,
          if (signature != null) "signature": signature,
          if (headImage != null) "headImage": headImage,
          if (headImageThumb != null) "headImageThumb": headImageThumb
        },
        method: HttpUtils.PUT,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 用户信息
  ///
  static Future<UserEntity?> getUserInfo() async {
    var data = await HttpUtils.getInstance().request('user/self', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return UserEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 搜索用户（名称）
  ///
  /// [keyword] 关键字
  ///
  static Future<List<UserEntity>> searchUserByName(String? keyword) async {
    var data =
        await HttpUtils.getInstance().request('user/findByName', method: HttpUtils.GET, params: {"name": keyword});
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => UserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 根据用户ID查看用户信息
  ///
  /// [id] 用户ID
  ///
  static Future<UserEntity?> getUserInfoById(int id) async {
    var data = await HttpUtils.getInstance().request('user/find/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return UserEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 获取用户设备终端 TODO
  ///
  /// [userIds]
  ///
  static Future<List<UserEntity>> getUserDevices(int userIds) async {
    var data = await HttpUtils.getInstance()
        .request('user/terminal/online', method: HttpUtils.GET, params: {"userIds": userIds});
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => UserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
