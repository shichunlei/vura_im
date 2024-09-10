import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnWebSocketData = void Function(int cmd, Map<String, dynamic> data);

typedef OnWebSocketConnect = void Function();

typedef OnWebSocketClose = void Function();

class WebSocketManager {
  WebSocketChannel? _channel;
  late String _accessToken;
  bool _isConnected = false;
  Timer? _heartbeatTimer;
  final Duration _heartbeatInterval = const Duration(seconds: 30); // 心跳间隔时间

  // 使用映射表存储页面的回调，键为页面标识符，值为回调函数
  final Map<String, OnWebSocketData> _messageCallbacks = {};
  final Map<String, OnWebSocketConnect> _connectCallbacks = {};
  final Map<String, OnWebSocketClose> _closeCallbacks = {};

  WebSocketManager listen(String pageId, OnWebSocketData messageCallBack,
      {OnWebSocketConnect? connectCallBack, OnWebSocketClose? closeCallBack}) {
    _messageCallbacks[pageId] = messageCallBack;
    if (connectCallBack != null) _connectCallbacks[pageId] = connectCallBack;
    if (closeCallBack != null) _closeCallbacks[pageId] = closeCallBack;
    return this;
  }

  // 移除回调函数的方法
  void removeCallbacks(String pageId) {
    _messageCallbacks.remove(pageId);
    _connectCallbacks.remove(pageId);
    _closeCallbacks.remove(pageId);
  }

  void init() async {
    // 初始化 WebSocket 连接
    _channel ??= WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));
    await _channel!.ready;
    _accessToken = SpUtil.getString(Keys.ACCESS_TOKEN);
    Log.d("@@@@@@@@@@@@@@@@@@@@@@@@=>>>>$_accessToken");
    _isConnected = true;
    if (StringUtil.isNotEmpty(_accessToken)) {
      _loginWebsocket(_accessToken);
      _startHeartbeat();
    }
    _channel!.stream.listen(_onMessage, onError: _onError, onDone: _onDone);
  }

  void _onMessage(message) {
    Map<String, dynamic> json = jsonDecode(message);
    if (json[Keys.CMD] == WebSocketCode.LOGIN.code) {
      Log.d("🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝🤝");
      // 登录成功
      _connectCallbacks.forEach((pageId, callback) {
        callback();
      });
    } else if (json[Keys.CMD] == WebSocketCode.HEARTBEAT.code) {
      Log.d("💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓💓");
      // 心跳
      _heartbeatTimer?.cancel();
      _heartbeatTimer = null;
      _startHeartbeat();
    } else if (json[Keys.CMD] == WebSocketCode.LOGOFF.code) {
      Log.d("👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻👋🏻");
      SpUtil.remove(Keys.ACCESS_TOKEN);
      SpUtil.remove(Keys.REFRESH_TOKEN);
      close();
      Get.offAllNamed(RoutePath.LOGIN_PAGE, arguments: {"isIllegalLogin": true});
    } else {
      Log.json(json);
      if (json[Keys.CMD] == WebSocketCode.FRIEND_APPLY.code) {
        Log.d("👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻👬🏻");
      }
      if (json[Keys.CMD] == WebSocketCode.SYSTEM_MESSAGE.code) {
        Log.d("👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙👙");
      }
      // 其他消息处理
      _messageCallbacks.forEach((pageId, callback) {
        callback(json[Keys.CMD], json[Keys.DATA]);
      });
    }
  }

  void _onError(error) {
    Log.e('WebSocket error: $error');
    _isConnected = false;
    _closeCallbacks.forEach((pageId, callback) {
      callback();
    });
  }

  void _onDone() {
    Log.d('WebSocket connection closed');
    _isConnected = false;
    _closeCallbacks.forEach((pageId, callback) {
      callback();
    });
    _channel?.sink.close();
    _channel = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _startHeartbeat() {
    _heartbeatTimer ??= Timer.periodic(_heartbeatInterval, (timer) {
      if (_isConnected) {
        sendMessage(jsonEncode({Keys.CMD: WebSocketCode.HEARTBEAT.code, Keys.DATA: {}}));
      }
    });
  }

  void _loginWebsocket(String accessToken) {
    sendMessage(jsonEncode({
      Keys.CMD: WebSocketCode.LOGIN.code,
      Keys.DATA: {Keys.ACCESS_TOKEN: accessToken}
    }));
  }

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  void connect() {
    // 连接 WebSocket
    init();
  }

  // 重连逻辑
  void reconnect() {
    if (!_isConnected) connect();
  }

  // 重连检查
  void check() {
    Log.d("_isConnected = $_isConnected");
    if (!_isConnected) reconnect();
  }

  void switchAccount() {
    close();
    Future.delayed(const Duration(milliseconds: 200), () {
      reconnect();
    });
  }

  void close() {
    // 关闭 WebSocket 连接
    _channel?.sink.close();
    _channel = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _isConnected = false;
  }
}
