import 'dart:async';
import 'dart:convert';

import 'package:im/global/config.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/sp_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnWebSocketData = void Function(int cmd, Map<String, dynamic> data);

typedef OnWebSocketConnect = void Function();

typedef OnWebSocketClose = void Function();

class WebSocketManager {
  late WebSocketChannel _channel;
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
    _channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));
    await _channel.ready;
    _accessToken = SpUtil.getString(Keys.ACCESS_TOKEN);
    Log.d("@@@@@@@@@@@@@@@@@@@@@@@@=>>>>$_accessToken");
    _isConnected = true;
    if (StringUtil.isNotEmpty(_accessToken)) {
      _loginWebsocket(_accessToken);
      _startHeartbeat();
    }
    _channel.stream.listen(_onMessage, onError: _onError, onDone: _onDone);
  }

  void _onMessage(message) {
    Map<String, dynamic> json = jsonDecode(message);
    Log.json(json);
    if (json[Keys.CMD] == WebSocketCode.LOGIN.code) {
      // 登录成功
      _connectCallbacks.forEach((pageId, callback) {
        callback();
      });
    } else if (json[Keys.CMD] == WebSocketCode.HEARTBEAT.code) {
      // 心跳
      _heartbeatTimer?.cancel();
      _startHeartbeat();
    } else {
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
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
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
    _channel.sink.add(message);
  }

  void connect() {
    // 连接 WebSocket
    init();
  }

  void reconnect() {
    // 重连逻辑
    if (!_isConnected) {
      Timer(const Duration(seconds: 10), () {
        connect();
      });
    }
  }

  void close() {
    // 关闭 WebSocket 连接
    _channel.sink.close();
    _isConnected = false;
  }
}
