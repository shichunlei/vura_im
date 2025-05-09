import 'package:flutter/material.dart';

///Widget that draw a beautiful checkbox rounded. Provided with animation if wanted
class RoundCheckBox extends StatefulWidget {
  const RoundCheckBox(
      {super.key,
      this.isChecked,
      this.checkedWidget,
      this.uncheckedWidget,
      this.checkedColor,
      this.uncheckedColor,
      this.disabledColor,
      this.border,
      this.borderColor,
      this.size,
      this.animationDuration,
      this.isRound = true,
      required this.onChanged,
      this.space = 0});

  ///Define wether the checkbox is marked or not
  final bool? isChecked;

  ///Define the widget that is shown when Widgets is checked
  final Widget? checkedWidget;

  ///Define the widget that is shown when Widgets is unchecked
  final Widget? uncheckedWidget;

  ///Define the color that is shown when Widgets is checked
  final Color? checkedColor;

  ///Define the color that is shown when Widgets is unchecked
  final Color? uncheckedColor;

  ///Define the color that is shown when Widgets is disabled
  final Color? disabledColor;

  ///Define the border of the widget
  final Border? border;

  ///Define the border color  of the widget
  final Color? borderColor;

  ///Define the size of the checkbox
  final double? size;

  ///Define Function that os executed when user tap on checkbox
  ///If onTap is given a null callack, it will be disabled
  final Function(bool?)? onChanged;

  ///Define the duration of the animation. If any
  final Duration? animationDuration;

  final bool isRound;

  final double? space;

  @override
  createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  bool? isChecked;
  late Duration animationDuration;
  double? size;
  Widget? checkedWidget;
  Widget? uncheckedWidget;
  late Color checkedColor;
  Color? uncheckedColor;
  Color? disabledColor;
  late Color borderColor;
  late double space;

  @override
  void initState() {
    isChecked = widget.isChecked ?? false;
    animationDuration = widget.animationDuration ?? const Duration(milliseconds: 500);
    size = widget.size ?? 40.0;
    checkedColor = widget.checkedColor ?? Colors.green;
    uncheckedColor = widget.uncheckedColor;
    borderColor = widget.borderColor ?? Colors.grey;
    checkedWidget = widget.checkedWidget ?? const Icon(Icons.check, color: Colors.white);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    space = widget.space ?? 0;
    super.initState();
  }

  @override
  void didUpdateWidget(RoundCheckBox oldWidget) {
    uncheckedColor = widget.uncheckedColor ?? Theme.of(context).scaffoldBackgroundColor;
    if (isChecked != widget.isChecked) {
      isChecked = widget.isChecked ?? false;
    }
    if (animationDuration != widget.animationDuration) {
      animationDuration = widget.animationDuration ?? const Duration(milliseconds: 500);
    }
    if (size != widget.size) {
      size = widget.size ?? 40.0;
    }
    if (checkedColor != widget.checkedColor) {
      checkedColor = widget.checkedColor ?? Colors.green;
    }
    if (borderColor != widget.borderColor) {
      borderColor = widget.borderColor ?? Colors.grey;
    }
    if (checkedWidget != widget.checkedWidget) {
      checkedWidget = widget.checkedWidget ?? const Icon(Icons.check, color: Colors.white);
    }
    if (uncheckedWidget != widget.uncheckedWidget) {
      uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.onChanged != null
        ? GestureDetector(
            onTap: () {
              setState(() => isChecked = !isChecked!);
              widget.onChanged!(isChecked);
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
                padding: EdgeInsets.all(space),
                child: ClipRRect(
                    borderRadius: borderRadius,
                    child: AnimatedContainer(
                        duration: animationDuration,
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                            color: isChecked! ? checkedColor : uncheckedColor,
                            border: widget.border ?? Border.all(color: isChecked! ? checkedColor : borderColor),
                            borderRadius: borderRadius),
                        child: isChecked! ? checkedWidget : uncheckedWidget))))
        : Padding(
            padding: EdgeInsets.all(space),
            child: ClipRRect(
                borderRadius: borderRadius,
                child: AnimatedContainer(
                    duration: animationDuration,
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                        color: widget.disabledColor ?? Theme.of(context).disabledColor,
                        border:
                            widget.border ?? Border.all(color: widget.disabledColor ?? Theme.of(context).disabledColor),
                        borderRadius: borderRadius),
                    child: isChecked! ? checkedWidget : uncheckedWidget)));
  }

  BorderRadius get borderRadius {
    if (widget.isRound) {
      return BorderRadius.circular(size! / 2);
    } else {
      return BorderRadius.zero;
    }
  }
}
