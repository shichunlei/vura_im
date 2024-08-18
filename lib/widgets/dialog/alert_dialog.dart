import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

class CustomAlertDialog extends Dialog {
  final String title;
  final String content;
  final VoidCallback? onConfirm;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onCancel;

  const CustomAlertDialog(
      {super.key,
      this.title = "提示",
      this.onConfirm,
      this.content = "",
      this.confirmText = "确定",
      this.cancelText = "取消",
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                width: 330.w,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.r),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Container(
                      margin: EdgeInsets.only(bottom: 20.r, top: 10.r),
                      child: Text(content, style: Theme.of(context).textTheme.titleSmall)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RadiusInkWellWidget(
                        radius: 40.r,
                        color: Colors.transparent,
                        border: Border.all(color: Theme.of(context).primaryColor, width: .5),
                        onPressed: () {
                          Get.back(result: false);
                          onCancel?.call();
                        },
                        margin: EdgeInsets.only(right: 15.w),
                        child: Container(
                            alignment: Alignment.center,
                            height: 40.r,
                            width: 100.w,
                            child: Text(cancelText,
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13.sp)))),
                    RadiusInkWellWidget(
                        margin: EdgeInsets.only(left: 15.w),
                        radius: 40.r,
                        border: Border.all(color: Colors.transparent, width: .5),
                        onPressed: () {
                          Get.back(result: true);
                          onConfirm?.call();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 40.r,
                            width: 100.w,
                            child: Text(confirmText, style: TextStyle(color: Colors.white, fontSize: 13.sp))))
                  ])
                ]))));
  }
}
