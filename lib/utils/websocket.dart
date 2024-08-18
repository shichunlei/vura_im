import 'dart:async';
import 'dart:convert';

import 'package:im/global/config.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/sp_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  // 定义回调函数的变量
  Function? _connectCallBack;
  Function(int cmd, Map<String, dynamic> data)? _messageCallBack;
  Function? _closeCallBack;

  late WebSocketChannel _channel;
  late String _accessToken;
  bool _isConnected = false;
  Timer? _heartbeatTimer;
  final Duration _heartbeatInterval = const Duration(seconds: 30); // 心跳间隔时间

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
      _connectCallBack?.call();
    } else if (json[Keys.CMD] == WebSocketCode.HEARTBEAT.code) {
      // 心跳
      _heartbeatTimer?.cancel();
      _startHeartbeat();
    } else {
      // 其他消息处理
      _messageCallBack?.call(json[Keys.CMD], json[Keys.DATA]);
    }
  }

  void _onError(error) {
    Log.e('WebSocket error: $error');
    _isConnected = false;
    _closeCallBack?.call();
  }

  void _onDone() {
    Log.d('WebSocket connection closed');
    _isConnected = false;
    _closeCallBack?.call();
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

  void setOnConnectCallback(Function callback) {
    _connectCallBack = callback;
  }

  void setOnMessageCallback(Function(int cmd, Map<String, dynamic> data) callback) {
    _messageCallBack = callback;
  }

  void setOnCloseCallback(Function callback) {
    _closeCallBack = callback;
  }
}
