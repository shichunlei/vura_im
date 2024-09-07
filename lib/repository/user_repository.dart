import 'package:get/get.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/login_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/http_utils.dart';
import 'package:vura/utils/sp_util.dart';

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
  /// [answer] 密保问题
  /// [code] 验证码
  /// [uuid] 校验验证码的UUID
  ///
  static Future<BaseBean> register(
      {String? userName, String? password, String? nickName, String? answer, String? code, String? uuid}) async {
    var data = await HttpUtils.getInstance().request('register',
        params: {
          "userName": userName,
          "password": password,
          "nickName": nickName,
          "answer": answer,
          "code": code,
          "uuid": uuid
        },
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 忘记密码 TODO
  ///
  /// [userName] 用户名
  /// [password] 密码
  /// [answer] 密保问题
  /// [code] 验证码
  /// [uuid] 校验验证码的UUID
  ///
  static Future<BaseBean> forgetPassword(
      {String? userName, String? password, String? answer, String? code, String? uuid}) async {
    var data = await HttpUtils.getInstance().request('forget',
        params: {"userName": userName, "password": password, "answer": answer, "code": code, "uuid": uuid},
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 修改密码
  ///
  /// [oldPassword] 旧密码
  /// [newPassword] 新密码
  /// [answer] 密保问题
  /// [code] 验证码
  /// [uuid] 校验验证码的UUID
  ///
  static Future<BaseBean> updatePassword(
      {String? oldPassword, String? newPassword, String? answer, String? code, String? uuid}) async {
    var data = await HttpUtils.getInstance().request('modifyPwd',
        params: {"oldPassword": oldPassword, "newPassword": newPassword, "answer": answer, "code": code, "uuid": uuid},
        method: HttpUtils.PUT,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 刷新token
  ///
  static Future<BaseBean> refreshToken() async {
    var data = await HttpUtils.getInstance().request('refreshToken', method: HttpUtils.PUT, refreshToken: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      LoginEntity? login = LoginEntity.fromJson(result.data);
      SpUtil.setString(Keys.ACCESS_TOKEN, "${login.accessToken}");
      SpUtil.setString(Keys.REFRESH_TOKEN, "${login.refreshToken}");
    }
    return result;
  }

  /// 修改用户基本信息
  ///
  /// [id] ID
  /// [userName] 用户名
  /// [nickName] 昵称
  ///
  static Future<BaseBean> updateUser(String? id,
      {String? userName, String? nickName, String? headImage, String? headImageThumb}) async {
    var data = await HttpUtils.getInstance().request('user/update',
        params: {
          Keys.ID: id,
          "userName": userName,
          "nickName": nickName,
          if (headImage != null) "headImage": headImage,
          if (headImageThumb != null) "headImageThumb": headImageThumb
        },
        method: HttpUtils.PUT,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 修改用户编号
  ///
  /// [id] ID
  /// [no] 用户编号
  ///
  static Future<BaseBean> updateUserNo(String? id, String? no) async {
    var data =
        await HttpUtils.getInstance().request('user/setUserNo', params: {Keys.ID: id, "no": no}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 修改用户配置
  ///
  /// [id] ID
  /// [addFriend] 允许加好友
  /// [protect] 登录保护
  /// [search] 允许搜索
  /// [setGroup] 开启群聊功能
  /// [vura] vura
  ///
  static Future<BaseBean> updateUserConfig(String? id,
      {YorNType? addFriend, YorNType? protect, YorNType? search, YorNType? setGroup, YorNType? vura}) async {
    var data = await HttpUtils.getInstance().request('user/update/secrecy',
        params: {
          Keys.ID: id,
          if (addFriend != null) "addFriend": addFriend.name,
          if (protect != null) "protect": protect.name,
          if (search != null) "search": search.name,
          if (setGroup != null) "setGroup": setGroup.name,
          if (vura != null) "vura": vura.name
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

  /// 获取当前用户二维码
  ///
  static Future<String?> getUserQrCode() async {
    var data = await HttpUtils.getInstance().request('user/qrcode', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200 && result.data is String) {
      return result.data;
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
        await HttpUtils.getInstance().request('user/findByName', method: HttpUtils.GET, params: {Keys.NAME: keyword});
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
  static Future<UserEntity?> getUserInfoById(String? id) async {
    var data = await HttpUtils.getInstance().request('user/find/$id', method: HttpUtils.GET);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return UserEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 扫码获取用户信息
  ///
  /// [qrcode] 二维码信息
  ///
  static Future<UserEntity?> getUserInfoByQrCode(String? qrcode) async {
    var data =
        await HttpUtils.getInstance().request('user/find/qrcode/$qrcode', method: HttpUtils.GET, showErrorToast: true);
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
  static Future<List<UserEntity>> getUserDevices(String? userIds) async {
    var data = await HttpUtils.getInstance()
        .request('user/terminal/online', method: HttpUtils.GET, params: {"userIds": userIds});
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => UserEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 修改用户钱包信息
  ///
  /// [walletCard] 地址
  /// [walletRemark] 备注
  ///
  static Future<BaseBean> updateWallet(String? walletCard, String? walletRemark) async {
    var data = await HttpUtils.getInstance().request('user/updateWallet',
        params: {"walletCard": walletCard, "walletRemark": walletRemark}, showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 设置支付密码
  ///
  /// [password] 支付密码
  ///
  static Future<BaseBean> setPayPassword(String? password) async {
    var data = await HttpUtils.getInstance().request('user/setPayPassword',
        params: {"payPassword": password, "id": Get.find<RootLogic>().user.value?.id},
        method: HttpUtils.PUT,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 设置支付密码
  ///
  /// [password] 支付密码
  ///
  static Future<BaseBean> checkPayPassword(String? password) async {
    var data = await HttpUtils.getInstance().request('user/checkPayPassword',
        params: {"payPassword": password, "id": Get.find<RootLogic>().user.value?.id},
        method: HttpUtils.GET,
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }
}
