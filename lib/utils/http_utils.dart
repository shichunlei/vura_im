import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/global/config.dart';
import 'package:im/global/keys.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/utils/sp_util.dart';
import 'package:im/utils/toast_util.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import 'log_utils.dart';

class HttpUtils {
  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String DELETE = 'delete';

  static const int CONNECT_TIMEOUT = 60000;
  static const int RECEIVE_TIMEOUT = 60000;
  static const int UPLOAD_TIMEOUT = 60000;

  Dio? _dio;

  static final HttpUtils _instance = HttpUtils._internal();

  factory HttpUtils() => _instance;

  ///通用全局单例，第一次使用时初始化
  HttpUtils._internal() {
    if (null == _dio) {
      _dio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(milliseconds: CONNECT_TIMEOUT),
          receiveTimeout: const Duration(milliseconds: RECEIVE_TIMEOUT)));

      if (kDebugMode) {
        if (DeviceUtils.isAndroid) {
          _dio!.interceptors.add(TalkerDioLogger(
              settings: TalkerDioLoggerSettings(
                  printRequestHeaders: true,
                  printResponseHeaders: false,
                  printResponseMessage: false,
                  requestPen: AnsiPen()..blue(),
                  responsePen: AnsiPen()..green(),
                  errorPen: AnsiPen()..red())));
        } else {
          _dio!.interceptors.add(LoggingInterceptor());
        }
      }
    }
  }

  static HttpUtils getInstance({String? baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  /// 用于指定特定域名
  HttpUtils _baseUrl(String baseUrl) {
    if (_dio != null) _dio!.options.baseUrl = baseUrl;

    return this;
  }

  /// 一般请求，默认域名
  HttpUtils _normal() {
    if (_dio != null && _dio!.options.baseUrl != AppConfig.baseUrl) {
      _dio!.options.baseUrl = AppConfig.baseUrl;
    }
    return this;
  }

  /// Make http request with options.
  ///
  /// [method] The request method.
  /// [path] The url path.
  /// [params] The request data
  ///
  /// String 返回 json data .
  Future request(String path,
      {Map<String, dynamic> params = const {},
      String method = POST,
      bool showErrorToast = false,
      bool refreshToken = false}) async {
    try {
      String accessToken = SpUtil.getString(Keys.ACCESS_TOKEN);
      String refreshTokenValue = SpUtil.getString(Keys.REFRESH_TOKEN);

      Response response = await _dio!.request(path,
          data: params,
          queryParameters: method == GET || method == PUT ? params : null,
          options: Options(method: method, headers: {
            if (!refreshToken) Keys.ACCESS_TOKEN: accessToken,
            if (refreshToken) Keys.REFRESH_TOKEN: refreshTokenValue
          }));

      var res = BaseBean.fromJson(response.data);

      if (response.statusCode == 200) {
        if (res.code != 200 && showErrorToast) showToast(text: "${res.message}");
        return response.data;
      } else {
        if (showErrorToast) showToast(text: "请求发生错误");
        return {Keys.MSG: "请求发生错误", Keys.CODE: -1};
      }
    } on DioException catch (error) {
      /// 响应信息, 如果错误发生在服务器返回数据之前，它为 `null`
      Log.d('$method请求发生错误：${error.toString()}');
      if (showErrorToast) showToast(text: "请求发生错误：${error.toString()}");
      return formatError(error);
    }
  }

  /// 下载
  Future<Response?> download(url, savePath,
      {Function(int count, int total)? onReceiveProgress, CancelToken? cancelToken}) async {
    Log.d('download请求启动! url：$url');
    Response? response;
    try {
      response =
          await Dio().download(url, savePath, cancelToken: cancelToken, onReceiveProgress: (int count, int total) {
        Log.d('onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');

        onReceiveProgress!(count, total);
      });
    } on DioException catch (e) {
      Log.d(e.response.toString());
      Map<String, dynamic> data = formatError(e);
      showToast(text: data[Keys.MSG]);
    }

    return response;
  }

  /// 上传文件
  ///
  /// [path] The url path.
  /// [formData] The request data
  ///
  Future<BaseBean> uploadFile(String path, FormData formData) async {
    /// 打印请求相关信息：请求地址、请求方式、请求参数
    Log.d("path=>$path");

    try {
      Response response = await _dio!.post(path,
          data: formData,
          options: Options(
              contentType: "multipart/form-data",
              receiveTimeout: const Duration(milliseconds: UPLOAD_TIMEOUT),
              headers: {Keys.ACCESS_TOKEN: SpUtil.getString(Keys.ACCESS_TOKEN)}),
          onReceiveProgress: (int count, int total) {
        Log.d('onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');
      }, onSendProgress: (int count, int total) {
        Log.d('onSendProgress: ${(count / total * 100).toStringAsFixed(0)} %');
      });

      return BaseBean.fromJsonToObject(response.data);
    } on DioException catch (e) {
      Map<String, dynamic> data = formatError(e);
      showToast(text: data[Keys.MSG]);
      return BaseBean(code: data[Keys.CODE], message: data[Keys.MSG]);
    }
  }

  /// error统一处理
  Map<String, dynamic> formatError(DioException error) {
    Log.d("${error.message}-------------------------------------------------${error.error}");
    if (error.type == DioExceptionType.connectionTimeout) {
      // It occurs when url is opened timeout.
      Log.d("连接超时 Ծ‸ Ծ");
      return {Keys.MSG: "连接超时 Ծ‸ Ծ", Keys.CODE: 100};
    } else if (error.type == DioExceptionType.sendTimeout) {
      // It occurs when url is sent timeout.
      Log.d("请求超时 Ծ‸ Ծ");
      return {Keys.MSG: "请求超时 Ծ‸ Ծ", Keys.CODE: 101};
    } else if (error.type == DioExceptionType.receiveTimeout) {
      //It occurs when receiving timeout
      Log.d("响应超时 Ծ‸ Ծ");
      return {Keys.MSG: "响应超时 Ծ‸ Ծ", Keys.CODE: 102};
    } else if (error.type == DioExceptionType.badResponse) {
      // When the server response, but with a incorrect status, such as 404, 503...
      int? errCode = error.response?.statusCode;
      switch (errCode) {
        case 400:
          return error.response?.data;
        case 401:
          return {Keys.MSG: "没有权限 Ծ‸ Ծ", Keys.CODE: 401};
        case 403:
          return {Keys.MSG: "服务器拒绝执行 Ծ‸ Ծ", Keys.CODE: 403};
        case 404:
          return {Keys.MSG: "无法连接服务器 Ծ‸ Ծ", Keys.CODE: 404};
        case 405:
          return {Keys.MSG: "请求方法被禁止 Ծ‸ Ծ", Keys.CODE: 405};
        case 500:
          return {Keys.MSG: "服务器内部错误 Ծ‸ Ծ", Keys.CODE: 500};
        case 502:
          return {Keys.MSG: "无效请求 Ծ‸ Ծ", Keys.CODE: 502};
        case 503:
          return {Keys.MSG: "服务器异常 Ծ‸ Ծ", Keys.CODE: 503};
        case 505:
          return {Keys.MSG: "不支持HTTP协议请求 Ծ‸ Ծ", Keys.CODE: 505};
        default:
          return {Keys.MSG: "请求异常 Ծ‸ Ծ", Keys.CODE: 103};
      }
    } else if (error.type == DioExceptionType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      Log.d("请求取消 Ծ‸ Ծ");
      return {Keys.MSG: "请求取消 Ծ‸ Ծ", Keys.CODE: 104};
    } else {
      // Default error type, Some other Error. In this case, you can use the DioError.error if it is not null.
      return {Keys.MSG: "未知错误 Ծ‸ Ծ", Keys.CODE: 105};
    }
  }

  /// 取消请求
  ///
  /// 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。所以参数可选
  void cancelRequests(CancelToken token) {
    token.cancel();
  }
}

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, handler) async {
    String accessToken = SpUtil.getString(Keys.ACCESS_TOKEN);
    options.headers[Keys.ACCESS_TOKEN] = accessToken;
    String refreshToken = SpUtil.getString("refreshToken");
    options.headers["refreshToken"] = refreshToken;
    return handler.next(options);
  }
}

class LoggingInterceptor extends Interceptor {
  late DateTime startTime;
  late DateTime endTime;

  @override
  onRequest(RequestOptions options, handler) {
    startTime = DateTime.now();
    Log.d("----------Start----------");
    if (options.queryParameters.isEmpty) {
      Log.i("RequestUrl: ${options.baseUrl}${options.path}");
    } else {
      Log.i("RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}");
    }
    Log.d("RequestMethod: ${options.method}");
    Log.d("RequestHeaders:${json.encode(options.headers)}");
    if (options.data is Map) Log.d("RequestParams: ${json.encode(options.data)}");
    return handler.next(options);
  }

  @override
  onResponse(Response response, handler) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    Log.d("ResponseCode: ${response.statusCode}");
    // 输出结果
    Log.d('↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ${response.realUri} ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓');
    Log.json(response.data);
    Log.d("↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ End: $duration 毫秒 ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑");
    return handler.next(response);
  }

  @override
  onError(DioException err, handler) {
    Log.e("----------Error-----------${err.toString()}");
    return handler.next(err);
  }
}
