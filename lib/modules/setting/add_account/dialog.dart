import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class AddAccountDialog extends StatelessWidget {
  const AddAccountDialog({super.key});

  AddAccountLogic get logic => Get.put(AddAccountLogic());

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
              child: GestureDetector(
                  onTap: Get.back,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox(height: double.infinity, width: double.infinity))),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r))),
            child: Column(children: [
              SizedBox(height: 22.h),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 22.w),
                  height: 50.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor)),
                  child: Row(children: [
                    SizedBox(width: 22.w),
                    Text("账号",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333)),
                    SizedBox(width: 22.w),
                    Expanded(
                        child: TextField(
                            controller: logic.accountController,
                            maxLines: 1,
                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(right: 18.w),
                                hintText: "请输入登录账号",
                                hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))))
                  ])),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 11.h, horizontal: 22.w),
                  height: 50.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor)),
                  child: Row(children: [
                    SizedBox(width: 22.w),
                    Text("密码",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333)),
                    SizedBox(width: 22.w),
                    Expanded(
                        child: TextField(
                            controller: logic.passwordController,
                            maxLines: 1,
                            obscureText: logic.obscureText.value,
                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(right: 18.w),
                                hintText: "请输入登录密码",
                                hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                    CustomIconButton(
                        icon: Obx(() {
                          return Icon(logic.obscureText.value ? IconFont.eye_close_line : IconFont.eye_open_line,
                              color: ColorUtil.color_333333);
                        }),
                        onPressed: logic.obscureText.toggle,
                        radius: 18.r),
                    SizedBox(width: 10.w)
                  ])),
              Row(children: [
                SizedBox(width: 22.w),
                Expanded(
                    child: RadiusInkWellWidget(
                        onPressed: () {
                          DeviceUtils.hideKeyboard(context);
                          Get.offNamed(RoutePath.REGISTER_PAGE, arguments: {"isAddAccount": true});
                        },
                        radius: 40,
                        color: Colors.transparent,
                        border: Border.all(color: Theme.of(context).primaryColor, width: .5),
                        child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            child: Text("注册账号",
                                style: GoogleFonts.roboto(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold))))),
                SizedBox(width: 22.w),
                Expanded(
                    child: RadiusInkWellWidget(
                        onPressed: () => logic.login(context),
                        radius: 40,
                        color: Theme.of(context).primaryColor,
                        child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            child: Text("登录",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold))))),
                SizedBox(width: 22.w)
              ]),
              SizedBox(height: DeviceUtils.setBottomMargin(22.h))
            ]),
          )
        ]));
  }
}
