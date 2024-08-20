import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/utils/color_util.dart';

class EmptyPage extends StatelessWidget {
  final Color? bgColor;
  final double? height;
  final String? text;
  final Widget? iconWidget;

  const EmptyPage({super.key, this.bgColor, this.height, this.text, this.iconWidget});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              height: height,
              child: Center(
                  child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                            constraints: BoxConstraints(maxWidth: 200.w, maxHeight: 200.w),
                            margin: EdgeInsets.only(bottom: 15.w),
                            child: iconWidget ?? Image.asset("assets/images/empty.webp")),
                        Text(text ?? "暂无数据", style: TextStyle(color: ColorUtil.color_999999, fontSize: 16.sp))
                      ]))));
        }));
  }
}
