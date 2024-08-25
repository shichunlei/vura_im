import 'package:dio/dio.dart';
import 'package:im/entities/base64.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/file_entity.dart';
import 'package:im/utils/http_utils.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/tool_util.dart';

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

  static Future<Base64Entity?> getAuthCode() async {
    var data = await HttpUtils.getInstance().request('captchaImage', method: HttpUtils.GET, showErrorToast: true);
    BaseBean result = BaseBean.fromJsonToObject(data);
    if (result.code == 200) {
      return Base64Entity.fromJson(result.data);
    } else {
      return null;
    }
  }
}
