import 'dart:async';

import 'package:event_bus/event_bus.dart';

typedef EventCallback<T> = void Function(T event);

class EventBusUtil {
  static EventBusUtil get instance => _getInstance();

  static EventBusUtil? _instance;

  EventBusUtil._internal() {
    /// 初始化
    _eventBus = EventBus();
  }

  /// 初始化eventBus
  late EventBus _eventBus;

  static EventBusUtil _getInstance() {
    _instance ??= EventBusUtil._internal();
    return _instance!;
  }

  /// 开启eventBus订阅
  StreamSubscription on<T>(EventCallback<T> callback) {
    StreamSubscription stream = _eventBus.on<T>().listen((event) {
      callback(event);
    });
    return stream;
  }

  /// 发送消息
  void fire(event) {
    _eventBus.fire(event);
  }

  /// 移除steam
  void off(StreamSubscription steam) {
    steam.cancel();
  }
}

var eventBus = EventBusUtil.instance;
