import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/widgets.dart';

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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Colors.white),
                width: 330.w,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 22.h),
                  Text(title,
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorUtil.color_333333)),
                  Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minHeight: 82.h),
                      child: Text(content, style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333))),
                  const Divider(height: 0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: RadiusInkWellWidget(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r)),
                            color: Colors.transparent,
                            onPressed: () {
                              Get.back(result: false);
                              onCancel?.call();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 52.h,
                                child: Text(cancelText,
                                    style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))))),
                    Container(height: 52.h, width: .5, color: Theme.of(context).dividerColor),
                    Expanded(
                        child: RadiusInkWellWidget(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r)),
                            color: Colors.transparent,
                            onPressed: () {
                              Get.back(result: true);
                              onConfirm?.call();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 52.h,
                                child: Text(confirmText,
                                    style: GoogleFonts.roboto(color: const Color(0xff2ECC72), fontSize: 15.sp)))))
                  ])
                ]))));
  }
}
