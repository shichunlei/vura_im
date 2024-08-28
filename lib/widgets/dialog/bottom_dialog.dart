import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

class BottomDialog extends StatelessWidget {
  final String? content;
  final VoidCallback? onConfirm;
  final String? confirmText;
  final Color? confirmTextColor;

  const BottomDialog({super.key, this.content, this.onConfirm, this.confirmText = "确定", this.confirmTextColor});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                color: Colors.white),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Visibility(
                  visible: StringUtil.isNotEmpty(content),
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 22.h),
                      child:
                          Text("$content", style: GoogleFonts.roboto(fontSize: 14.sp, color: ColorUtil.color_666666)))),
              const Divider(height: 0),
              RadiusInkWellWidget(
                  onPressed: () {
                    Get.back();
                    onConfirm?.call();
                  },
                  radius: 0,
                  color: Colors.transparent,
                  child: Container(
                      height: 60.h,
                      padding: EdgeInsets.only(bottom: DeviceUtils.bottomSafeHeight),
                      alignment: Alignment.center,
                      child: Text("$confirmText",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: confirmTextColor ?? Colors.redAccent,
                              fontWeight: FontWeight.bold)))),
              const Divider(height: 0),
              Container(height: 10.h, width: double.infinity, color: const Color(0xfff5f5f5)),
              GestureDetector(
                  onTap: Get.back,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                      height: 60.h + DeviceUtils.bottomSafeHeight,
                      padding: EdgeInsets.only(bottom: DeviceUtils.bottomSafeHeight),
                      alignment: Alignment.center,
                      child: Text("取消", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))))
            ])));
  }
}
