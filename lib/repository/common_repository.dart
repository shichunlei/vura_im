import 'package:dio/dio.dart';
import 'package:vura/entities/base64.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/bill_record_entity.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/rate_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/utils/http_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/tool_util.dart';

class CommonRepository {
  /// 上传图片
  ///
  /// [path] 图片路径
  ///
  static Future<ImageEntity?> uploadImage(String path) async {
    String localFileName = getFileNameByPath(path);
    Log.d("---@@@@@@@@@@@@@@----------实际的图片文件名-----------$localFileName");
    Log.d("---@@@@@@@@@@@@@@----------图片路径-----------$path");
    MultipartFile? multipartFile = await MultipartFile.fromFile(path, filename: localFileName);
    // 构建FormData
    FormData formData = FormData.fromMap({'file': multipartFile});
    BaseBean result = await HttpUtils.getInstance().uploadFile("image/upload", formData);
    if (result.code == 200) {
      return ImageEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 上传文件
  ///
  /// [path] 文件路径
  ///
  static Future<String?> uploadFile(String path) async {
    String localFileName = getFileNameByPath(path);
    Log.d("---@@@@@@@@@@@@@@----------实际的文件名-----------$localFileName");

    MultipartFile? multipartFile = MultipartFile.fromFileSync(path, filename: localFileName);
    // 构建FormData
    FormData formData = FormData.fromMap({'file': multipartFile});
    BaseBean result = await HttpUtils.getInstance().uploadFile("file/upload", formData);
    if (result.code == 200) {
      return result.data as String;
    } else {
      return null;
    }
  }

  /// 验证码
  ///
  static Future<Base64Entity?> getAuthCode() async {
    var data = await HttpUtils.getInstance().request('captchaImage', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return Base64Entity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 获取汇率
  static Future<RateEntity?> getRate() async {
    var data = await HttpUtils.getInstance().request('rate/config/get', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return RateEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 获取服务费配置
  static Future<RateEntity?> getFee() async {
    var data = await HttpUtils.getInstance().request('rate/config/getFee', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return RateEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 收支记录
  ///
  /// [startDate] 开始时间 yyyy-MM-dd
  /// [endDate] 结束时间 yyyy-MM-dd
  /// [type] 收入 INCOME 支出 PAY
  /// [userId] 用户Id 查询自己的 不用给
  ///
  static Future<List<BillRecordEntity>> bookMoneyList(
      {int page = 1,
      int size = 20,
      required FeeType type,
      DateTime? startDate,
      DateTime? endDate,
      String? userId}) async {
    var data = await HttpUtils.getInstance().request("bookMoney/myListByPage", params: {
      "current": page,
      Keys.SIZE: size,
      if (endDate != null) "endDate": DateUtil.getDateStrByDateTime(endDate, format: DateFormat.YEAR_MONTH_DAY),
      if (startDate != null) "startDate": DateUtil.getDateStrByDateTime(startDate, format: DateFormat.YEAR_MONTH_DAY),
      if (type != FeeType.ALL) Keys.TYPE: type.name,
      if (userId != null) Keys.USER_ID: userId
    });
    BaseBean result = BaseBean.fromJsonToObject(data);
    return (result.data["records"] as List).map((item) => BillRecordEntity.fromJson(item)).toList();
  }

  /// 申请转账
  ///
  /// [account] 账户
  /// [money] 转账金额
  /// [type] 类型 1-提现 2-充值 3-转账
  /// [remarks] 转账备注
  /// [payAddress] 充值平台地址
  /// [evidenceUrl] 凭证图片地址
  ///
  static Future<BaseBean> withdraw(
      {required double money,
      required BookType type,
      String? remarks,
      String? account,
      String? payPassword,
      String? payAddress,
      String? evidenceUrl}) async {
    var data = await HttpUtils.getInstance().request("withdraw/apply",
        params: {
          "money": money,
          "type": type.index,
          "remarks": remarks,
          "account": account,
          "payPassword": payPassword,
          if (StringUtil.isNotEmpty(payAddress)) "payAddress": payAddress,
          if (StringUtil.isNotEmpty(evidenceUrl)) "evidenceUrl": evidenceUrl
        },
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 转账
  ///
  /// [userId] 用户ID
  /// [money] 转账金额
  /// [remarks] 转账备注
  /// [payPassword] 支付密码
  ///
  static Future<BaseBean> transferToMember(
      {required double money, String? remarks, String? userId, String? payPassword}) async {
    var data = await HttpUtils.getInstance().request("withdraw/redPacketApply",
        params: {"money": money, "remarks": remarks, "userId": userId, "payPassword": payPassword},
        showErrorToast: true);
    return BaseBean.fromJson(data);
  }

  /// 获取平台地址信息
  ///
  static Future<List<ImConfigEntity>> getImConfig() async {
    var data = await HttpUtils.getInstance()
        .request('im-platform/imConfig/getImConfigs', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToList(data);
    if (result.code == 200) {
      return result.items.map((item) => ImConfigEntity.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
