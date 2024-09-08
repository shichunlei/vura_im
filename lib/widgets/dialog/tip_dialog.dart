import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/widgets.dart';

class CustomTipDialog extends Dialog {
  final String title;
  final String content;
  final VoidCallback? onConfirm;
  final TextStyle? titleStyle;
  final String btnText;

  const CustomTipDialog(
      {super.key, this.title = "", this.onConfirm, this.content = "", this.titleStyle, this.btnText = "知道了"});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Colors.white),
                width: 300.w,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  StringUtil.isEmpty(title)
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                          child: Text(title,
                              style: titleStyle ??
                                  GoogleFonts.roboto(
                                      fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorUtil.color_333333))),
                  Container(
                      constraints: BoxConstraints(minHeight: 80.h),
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                      child: Text(content,
                          style: GoogleFonts.roboto(fontSize: 14.sp, color: ColorUtil.color_333333),
                          textAlign: TextAlign.justify)),
                  const Divider(height: 0),
                  RadiusInkWellWidget(
                      color: Colors.transparent,
                      onPressed: () {
                        Get.back();
                        onConfirm?.call();
                      },
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
                      child: Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          width: double.infinity,
                          child:
                              Text(btnText, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp))))
                ]))));
  }
}
