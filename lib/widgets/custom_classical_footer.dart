import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh_strong/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 经典Footer
class CustomClassicalFooter extends Footer {
  /// Key
  final Key? key;

  /// 方位
  final AlignmentGeometry? alignment;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  final bool showNoData;

  CustomClassicalFooter(
      {super.extent,
      super.triggerDistance,
      super.float,
      super.completeDuration = const Duration(seconds: 1),
      super.enableInfiniteLoad,
      super.enableHapticFeedback = true,
      super.overScroll,
      super.safeArea = true,
      super.padding,
      this.key,
      this.alignment,
      this.bgColor = Colors.transparent,
      this.textColor = Colors.black,
      this.infoColor = Colors.teal,
      this.showNoData = true});

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return CustomClassicalFooterWidget(
        key: key,
        classicalFooter: this,
        loadState: loadState,
        pulledExtent: pulledExtent,
        loadTriggerPullDistance: loadTriggerPullDistance,
        loadIndicatorExtent: loadIndicatorExtent,
        axisDirection: axisDirection,
        float: float,
        completeDuration: completeDuration,
        enableInfiniteLoad: enableInfiniteLoad,
        success: success,
        noMore: noMore,
        showNoData: showNoData);
  }
}

/// 经典Footer组件
class CustomClassicalFooterWidget extends StatefulWidget {
  final CustomClassicalFooter classicalFooter;
  final LoadMode loadState;
  final double pulledExtent;
  final double loadTriggerPullDistance;
  final double loadIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration? completeDuration;
  final bool enableInfiniteLoad;
  final bool success;
  final bool noMore;
  final bool showNoData;

  const CustomClassicalFooterWidget(
      {super.key,
      required this.loadState,
      required this.classicalFooter,
      required this.pulledExtent,
      required this.loadTriggerPullDistance,
      required this.loadIndicatorExtent,
      required this.axisDirection,
      required this.float,
      this.completeDuration,
      required this.enableInfiniteLoad,
      required this.success,
      required this.noMore,
      this.showNoData = true});

  @override
  createState() => CustomClassicalFooterWidgetState();
}

class CustomClassicalFooterWidgetState extends State<CustomClassicalFooterWidget>
    with TickerProviderStateMixin<CustomClassicalFooterWidget> {
  // 是否到达触发加载距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance ? _readyController.forward() : _restoreController.forward();
    }
    _overTriggerDistance = over;
  }

  // 动画
  late AnimationController _readyController;
  late Animation<double> _readyAnimation;
  late AnimationController _restoreController;
  late Animation<double> _restoreAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 显示文字
  String get _showText {
    if (widget.noMore) return "我是有底线的";
    if (widget.enableInfiniteLoad) {
      if (widget.loadState == LoadMode.loaded ||
          widget.loadState == LoadMode.inactive ||
          widget.loadState == LoadMode.drag) {
        return _finishedText;
      } else {
        return "正在加载...";
      }
    }
    switch (widget.loadState) {
      case LoadMode.load:
        return "正在加载...";
      case LoadMode.armed:
        return "正在加载...";
      case LoadMode.loaded:
        return _finishedText;
      case LoadMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return "释放加载";
        } else {
          return "上拉加载";
        }
    }
  }

  // 加载结束文字
  String get _finishedText {
    if (!widget.success) return "加载失败";
    if (widget.noMore) return "我是有底线的";
    return "加载完成";
  }

  // 加载结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    return Icons.done;
  }

  @override
  void initState() {
    super.initState();
    // 初始化动画
    _readyController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    _restoreController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation = Tween(begin: 1.0, end: 0.5).animate(_restoreController)
      ..addListener(() {
        setState(() {
          if (_restoreAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _restoreAnimation.value;
          }
        });
      });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否为垂直方向
    bool isVertical = widget.axisDirection == AxisDirection.down || widget.axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up || widget.axisDirection == AxisDirection.left;
    // 是否到达触发加载距离
    overTriggerDistance =
        widget.loadState != LoadMode.inactive && widget.pulledExtent >= widget.loadTriggerPullDistance;
    return Stack(children: [
      Positioned(
          top: !isVertical
              ? 0.0
              : !isReverse
                  ? 0.0
                  : null,
          bottom: !isVertical
              ? 0.0
              : isReverse
                  ? 0.0
                  : null,
          left: isVertical
              ? 0.0
              : !isReverse
                  ? 0.0
                  : null,
          right: isVertical
              ? 0.0
              : isReverse
                  ? 0.0
                  : null,
          child: Container(
              alignment: widget.classicalFooter.alignment ??
                  (isVertical
                      ? !isReverse
                          ? Alignment.topCenter
                          : Alignment.bottomCenter
                      : isReverse
                          ? Alignment.centerRight
                          : Alignment.centerLeft),
              width: !isVertical
                  ? widget.loadIndicatorExtent > widget.pulledExtent
                      ? widget.loadIndicatorExtent
                      : widget.pulledExtent
                  : double.infinity,
              height: isVertical
                  ? widget.loadIndicatorExtent > widget.pulledExtent
                      ? widget.loadIndicatorExtent
                      : widget.pulledExtent
                  : double.infinity,
              color: widget.classicalFooter.bgColor,
              child: SizedBox(
                  height: isVertical
                      ? widget.showNoData
                          ? widget.loadIndicatorExtent
                          : 0
                      : double.infinity,
                  width: !isVertical
                      ? widget.showNoData
                          ? widget.loadIndicatorExtent
                          : 0
                      : double.infinity,
                  child: isVertical
                      ? Row(mainAxisAlignment: MainAxisAlignment.center, children: _buildContent(isVertical, isReverse))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildContent(isVertical, isReverse)))))
    ]);
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isVertical, bool isReverse) {
    return isVertical
        ? [
            Expanded(
                flex: 2,
                child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10.0),
                    child: (widget.loadState == LoadMode.load || widget.loadState == LoadMode.armed) && !widget.noMore
                        ? SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation(widget.classicalFooter.textColor)))
                        : widget.loadState == LoadMode.loaded ||
                                widget.loadState == LoadMode.done ||
                                (widget.enableInfiniteLoad && widget.loadState != LoadMode.loaded)
                            ? widget.noMore
                                ? const SizedBox()
                                : Icon(_finishedIcon, color: widget.classicalFooter.textColor)
                            : Transform.rotate(
                                angle: 2 * pi * _iconRotationValue,
                                child: Icon(!isReverse ? Icons.arrow_upward : Icons.arrow_downward,
                                    color: widget.classicalFooter.textColor)))),
            Expanded(
                flex: 3,
                child: Center(
                    child: Text(_showText,
                        style: TextStyle(
                            fontSize: widget.noMore ? 13.sp : 16.sp,
                            color: widget.noMore ? const Color(0xff999999) : widget.classicalFooter.textColor)))),
            const Expanded(flex: 2, child: SizedBox())
          ]
        : [
            Container(
                child: widget.loadState == LoadMode.load || widget.loadState == LoadMode.armed
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation(widget.classicalFooter.textColor)))
                    : widget.loadState == LoadMode.loaded ||
                            widget.loadState == LoadMode.done ||
                            (widget.enableInfiniteLoad && widget.loadState != LoadMode.loaded)
                        ? widget.noMore
                            ? const SizedBox()
                            : Icon(_finishedIcon, color: widget.classicalFooter.textColor)
                        : Transform.rotate(
                            angle: 2 * pi * _iconRotationValue,
                            child: Icon(!isReverse ? Icons.arrow_back : Icons.arrow_forward,
                                color: widget.classicalFooter.textColor)))
          ];
  }
}
