import 'package:dio/dio.dart';
import 'package:vura/entities/base64.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/bill_record_entity.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/version_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/utils/http_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/tool_util.dart';

class CommonRepository {
  /// 上传图片
  ///
  /// [path] 图片路径
  ///
  static Future<FileEntity?> uploadImage(String path) async {
    String localFileName = getFileNameByPath(path);
    Log.d("---@@@@@@@@@@@@@@----------实际的图片文件名-----------$localFileName");
    Log.d("---@@@@@@@@@@@@@@----------图片路径-----------$path");
    MultipartFile? multipartFile = await MultipartFile.fromFile(path, filename: localFileName);
    // 构建FormData
    FormData formData = FormData.fromMap({'file': multipartFile});
    BaseBean result = await HttpUtils.getInstance().uploadFile("image/upload", formData);
    if (result.code == 200) {
      return FileEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 上传文件
  ///
  /// [path] 文件路径
  ///
  static Future<FileEntity?> uploadFile(String path) async {
    String localFileName = getFileNameByPath(path);
    Log.d("---@@@@@@@@@@@@@@----------实际的文件名-----------$localFileName");

    MultipartFile? multipartFile = MultipartFile.fromFileSync(path, filename: localFileName);
    // 构建FormData
    FormData formData = FormData.fromMap({'file': multipartFile});
    BaseBean result = await HttpUtils.getInstance().uploadFile("file/upload", formData);
    if (result.code == 200) {
      return FileEntity.fromJson(result.data);
    } else {
      return null;
    }
  }

  /// 验证码
  static Future<Base64Entity?> getAuthCode() async {
    var data = await HttpUtils.getInstance().request('captchaImage', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return Base64Entity.fromJson(result.data);
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
      {int page = 0, int size = 20, required FeeType type, String? startDate, String? endDate, String? userId}) async {
    var data = await HttpUtils.getInstance().request("bookMoney/myListByPage", params: {
      Keys.CURRENT_PAGE: page,
      Keys.PAGE_SIZE: size,
      if (endDate != null) "endDate": endDate,
      if (startDate != null) "startDate": startDate,
      if (type != FeeType.ALL) Keys.TYPE: type.name,
      if (userId != null) Keys.USER_ID: userId
    });
    BaseBean result = BaseBean.fromJsonToObject(data);
    return (result.data["records"] as List).map((item) => BillRecordEntity.fromJson(item)).toList();
  }

  /// 版本检查
  static Future<VersionEntity?> checkVersion() async {
    var data = await HttpUtils.getInstance().request('captchaImage', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return VersionEntity.fromJson(result.data);
    } else {
      return null;
    }
  }
}
