import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/dialog_util.dart';
import 'package:im/utils/tool_util.dart';
import 'package:im/widgets/avatar_image.dart';
import 'package:im/widgets/dialog/update_text_dialog.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  PersonalLogic get logic => Get.find<PersonalLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("个人信息"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: [
                SizedBox(height: 30.h),
                SizedBox(
                    height: 88.r,
                    width: 88.r,
                    child: Stack(clipBehavior: Clip.none, children: [
                      AvatarImageView("${logic.bean.value?.headImageThumb}",
                          radius: 44.r, name: logic.bean.value?.nickName),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                              onTap: () {
                                showImagePickerDialog(context).then((value) {
                                  if (value != null) {
                                    pickerImage(value, cropImage: true).then((path) {
                                      if (path != null) logic.updateAvatar(path);
                                    });
                                  }
                                });
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                  height: 22.r,
                                  width: 22.r,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff83C240), borderRadius: BorderRadius.circular(200)),
                                  child: Icon(IconFont.edit, color: Colors.white, size: 13.r))))
                    ])),
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                    margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 44.h),
                    child: Column(children: [
                      RadiusInkWellWidget(
                          color: Colors.transparent,
                          onPressed: () {
                            Get.dialog(UpdateTextDialog(title: "请输入昵称", value: logic.bean.value?.nickName ?? ""))
                                .then((value) {
                              if (value != null) logic.updateNickname(value);
                            });
                          },
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                          child: Container(
                              height: 66.h,
                              padding: EdgeInsets.only(left: 22.w, right: 10.w),
                              child: Row(children: [
                                Text("昵称",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text("${logic.bean.value?.nickName}",
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                                const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                              ]))),
                      Divider(height: 0, indent: 22.w, endIndent: 22.w),
                      RadiusInkWellWidget(
                          radius: 0,
                          color: Colors.transparent,
                          onPressed: () {},
                          child: Container(
                              height: 66.h,
                              padding: EdgeInsets.only(left: 22.w, right: 10.w),
                              child: Row(children: [
                                Text("ID号",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text("${logic.bean.value?.id}",
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                                const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                              ]))),
                      Divider(height: 0, indent: 22.w, endIndent: 22.w),
                      RadiusInkWellWidget(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                          onPressed: () {
                            Get.toNamed(RoutePath.MY_QR_CODE_PAGE,
                                arguments: {Keys.ID: Get.find<RootLogic>().user.value?.id});
                          },
                          child: Container(
                              height: 66.h,
                              padding: EdgeInsets.only(left: 22.w, right: 10.w),
                              child: Row(children: [
                                Text("我的二维码",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Icon(IconFont.qr, color: ColorUtil.color_999999, size: 15.sp),
                                const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                              ])))
                    ]))
              ]);
            }));
  }
}
