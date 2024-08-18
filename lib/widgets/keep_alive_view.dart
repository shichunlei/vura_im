import 'package:flutter/material.dart';

/// 页面保活方法
class KeepAliveView extends StatefulWidget {
  final Widget child;

  const KeepAliveView({super.key, required this.child});

  @override
  createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAliveView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
