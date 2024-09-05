import 'package:flutter/material.dart';

class TextMarquee extends StatefulWidget {
  /// 要滚动的文本
  final String text;

  /// 文本样式
  final TextStyle style;

  /// 动画持续时间
  final Duration? duration;

  /// 动画曲线
  final Curve curve;

  /// 滚动开始的延迟时间
  final Duration delay;

  /// 原始文本与重复文本之间的距离
  final double spaceSize;

  /// 文本与小部件起始位置的间距
  final double startPaddingSize;

  /// 如果文本从右排列，应设置为 true
  final bool rtl;

  const TextMarquee(
    this.text, {
    super.key,
    this.style = const TextStyle(),
    this.duration,
    this.curve = Curves.linear,
    this.delay = const Duration(seconds: 2),
    this.spaceSize = 20,
    this.startPaddingSize = 0,
    this.rtl = false,
  });

  @override
  createState() => _TextMarqueeState();
}

class _TextMarqueeState extends State<TextMarquee> {
  final ScrollController _scrollController = ScrollController();
  double _textWidth = 0;
  bool _isLarger = false;
  bool _isScrolling = false;

  // 标志位，防止多次启动动画
  bool _isAnimating = false;

  @override
  void didUpdateWidget(TextMarquee oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isScrolling) _startAnimating();
    });
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _startAnimating() async {
    // 如果正在执行动画，则直接返回，防止多次调用
    if (_isAnimating) return;

    // 设置标志位，表示动画正在执行
    _isAnimating = true;

    // 如果文本长度不够，停止动画
    if (!_isLarger || !mounted) {
      _isScrolling = false;
      _isAnimating = false;
      return;
    }

    // 添加延迟
    await Future.delayed(widget.delay);

    // 计算滚动长度
    double scrollLength = _textWidth + widget.spaceSize + widget.startPaddingSize;

    // 滚动到末尾
    await _scrollController.animateTo(scrollLength,
        duration: widget.duration ?? Duration(milliseconds: (scrollLength * 10).toInt()), curve: widget.curve);

    // 回到起点
    _scrollController.jumpTo(0);

    // 递归调用继续滚动
    _isAnimating = false;
    _startAnimating();
  }

  @override
  Widget build(BuildContext context) {
    _textWidth = _getTextWidth();

    return LayoutBuilder(builder: (_, constraint) {
      _isLarger = constraint.maxWidth <= _textWidth;

      return Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              reverse: widget.rtl,
              child: Row(children: [
                SizedBox(width: widget.startPaddingSize),
                Text(widget.text, style: widget.style, maxLines: 1),
                if (_isLarger)
                  Padding(
                      padding: EdgeInsets.only(left: widget.spaceSize + widget.startPaddingSize),
                      child: Text(widget.text, style: widget.style, maxLines: 1))
              ])));
    });
  }

  double _getTextWidth() {
    if (widget.text.isEmpty) return 0;

    // 使用 TextPainter 计算文本宽度
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout();

    return textPainter.size.width;
  }

  @override
  void dispose() {
    _isLarger = false;
    _scrollController.dispose();
    super.dispose();
  }
}
