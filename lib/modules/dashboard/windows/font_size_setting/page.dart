import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class FontSizeSettingPage extends StatelessWidget {
  const FontSizeSettingPage({super.key});

  FontSizeSettingLogic get logic => Get.find<FontSizeSettingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Text Size".tr), centerTitle: true, actions: [
          Center(
              child: RadiusInkWellWidget(
                  radius: 4.r,
                  margin: EdgeInsets.only(right: 11.w),
                  onPressed: logic.setFontSize,
                  child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 50.w,
                      child: Text("Done".tr, style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.white)))))
        ]),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(children: [
                    SizedBox(height: 22.h),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.r),
                                  topLeft: Radius.circular(15.r),
                                  bottomRight: Radius.circular(15.r),
                                  bottomLeft: Radius.circular(15.r)),
                              color: const Color(0xff2ECC72)),
                          constraints: BoxConstraints(maxWidth: 266.w, minWidth: 0, minHeight: 44.r),
                          child: Obx(() {
                            return Text('预览字体大小',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: logic.textSizeType.value.fontSize.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600));
                          }))
                    ]),
                    SizedBox(height: 22.h),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipOval(child: Image.asset("assets/images/default_face.webp", width: 44.r, height: 44.r)),
                          SizedBox(width: 10.w),
                          Container(
                              margin: EdgeInsets.only(top: 5.h),
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.r),
                                      topLeft: Radius.circular(5.r),
                                      bottomRight: Radius.circular(15.r),
                                      bottomLeft: Radius.circular(15.r)),
                                  color: Colors.white),
                              constraints: BoxConstraints(maxWidth: 266.w, minWidth: 0, minHeight: 44.r),
                              child: Obx(() {
                                return Text('拖动下面的滑块，可设置字体的大小',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: ColorUtil.color_333333,
                                        fontSize: logic.textSizeType.value.fontSize.sp,
                                        fontWeight: FontWeight.w600));
                              }))
                        ]),
                    SizedBox(height: 22.h),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipOval(child: Image.asset("assets/images/default_face.webp", width: 44.r, height: 44.r)),
                          SizedBox(width: 10.w),
                          Container(
                              margin: EdgeInsets.only(top: 5.h),
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.r),
                                      topLeft: Radius.circular(5.r),
                                      bottomRight: Radius.circular(15.r),
                                      bottomLeft: Radius.circular(15.r)),
                                  color: Colors.white),
                              constraints: BoxConstraints(maxWidth: 266.w, minWidth: 0, minHeight: 44.r),
                              child: Obx(() {
                                return Text('设置后，会改变聊天的字体大小。如果使用过程中存在问题或意见，可反馈给VURA团队',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: ColorUtil.color_333333,
                                        fontSize: logic.textSizeType.value.fontSize.sp,
                                        fontWeight: FontWeight.w600));
                              }))
                        ])
                  ]))),
          Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: DeviceUtils.bottomSafeHeight, left: 22.w, right: 22.w),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: 22.h),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: List.generate(TextSizeType.values.length, (index) {
                      return Expanded(
                          child: Center(
                              child: Text(TextSizeType.values[index].label,
                                  style: GoogleFonts.roboto(
                                      fontSize: TextSizeType.values[index].fontSize.sp,
                                      color: ColorUtil.color_333333))));
                    }).toList()),
                Obx(() {
                  return Slider(
                      activeColor: const Color(0xfff4f4f4),
                      thumbColor: Colors.white,
                      value: logic.textSizeType.value.stepValue,
                      onChanged: logic.updateFontSize,
                      max: 7,
                      divisions: 7);
                }),
                SizedBox(height: 33.h)
              ]))
        ]));
  }
}
