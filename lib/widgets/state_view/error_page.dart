import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/utils/color_util.dart';

class ErrorPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final Color? bgColor;
  final double? height;

  const ErrorPage({super.key, this.onRetry, this.bgColor, this.height});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              height: height,
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    constraints: BoxConstraints(maxWidth: 200.w, maxHeight: 200.w),
                    margin: EdgeInsets.only(bottom: 15.w),
                    child: Image.asset("assets/images/error.png")),
                Text("网络请求失败，请检查网络重试一次！", style: TextStyle(color: ColorUtil.color_999999, fontSize: 16.sp)),
                SizedBox(height: onRetry != null ? 15 : 0, width: double.infinity),
                Visibility(
                    visible: onRetry != null,
                    child: TextButton(
                        onPressed: onRetry?.call,
                        child: Text(onRetry != null ? '点击刷新' : '', style: const TextStyle(fontSize: 16))))
              ]));
        }));
  }
}
