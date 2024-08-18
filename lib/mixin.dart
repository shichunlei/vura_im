import 'package:im/base/base_logic.dart';
import 'package:im/utils/log_utils.dart';

import 'modules/home/logic.dart';

mixin WebsocketMixin on BaseLogic {
  void websocketCallback() {
    webSocketManager
      ..setOnConnectCallback(() {
        Log.d("WebSocket 连接成功");
      })
      ..setOnMessageCallback((cmd, data) {
        Log.d("接收到消息: $cmd, 数据: $data");
      })
      ..setOnCloseCallback(() {
        Log.d("WebSocket 连接关闭");
      });
  }
}
