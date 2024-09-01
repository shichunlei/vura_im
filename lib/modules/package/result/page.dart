import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class PackageResultPage extends StatelessWidget {
  final String? tag;

  const PackageResultPage({super.key, this.tag});

  PackageResultLogic get logic => Get.find<PackageResultLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: const Color(0xfffafafa), width: double.infinity, height: double.infinity),
      Image.asset("assets/images/package_top_bg.png", width: double.infinity, fit: BoxFit.fitWidth),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: const Text("发幸运值", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white)),
          body: BaseWidget(
              logic: logic,
              builder: (logic) {
                return Column(children: [
                  SizedBox(height: 80.h),
                  AvatarRoundImage("${logic.bean.value!.senderHeadImage}",
                      width: 88.r, height: 88.r, radius: 9.r, name: logic.bean.value?.senderNickName),
                  SizedBox(height: 22.h),
                  Text("${logic.bean.value!.senderNickName}的幸运值",
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp, fontWeight: FontWeight.w600, color: ColorUtil.color_333333)),
                  SizedBox(height: 13.h),
                  Text("${logic.bean.value!.totalAmount}幸运值",
                      style: GoogleFonts.roboto(
                          fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color(0xffDB5549))),
                  SizedBox(height: 44.h),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${logic.bean.value?.amount}",
                            style: GoogleFonts.roboto(
                                fontSize: 44.sp, fontWeight: FontWeight.w600, color: const Color(0xffDB5549))),
                        Text("幸运值",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xffDB5549))),
                      ]),
                  SizedBox(height: 22.h),
                  Container(
                      margin: EdgeInsets.only(bottom: 11.h, left: 22.w),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          logic.bean.value!.totalTime > 0
                              ? "${logic.bean.value!.totalPacket}个幸运值,${logic.bean.value!.totalTime}秒被抢光"
                              : "${logic.bean.value!.totalPacket}个幸运值",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp, fontWeight: FontWeight.w600, color: ColorUtil.color_333333))),
                  Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          itemBuilder: (_, index) {
                            return Container(
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                child: Row(children: [
                                  AvatarRoundImage("${logic.bean.value!.detailList[index].headImage}",
                                      width: 66.r,
                                      height: 66.r,
                                      radius: 7.r,
                                      name: logic.bean.value!.detailList[index].nickName),
                                  SizedBox(width: 22.w),
                                  Expanded(
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                      Row(children: [
                                        Text("${logic.bean.value!.detailList[index].nickName}",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.sp)),
                                        const Spacer(),
                                        Text("${logic.bean.value!.detailList[index].amount}幸运值",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.sp))
                                      ]),
                                      SizedBox(height: 5.h),
                                      Row(children: [
                                        Text("${logic.bean.value!.detailList[index].createDate}",
                                            style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp)),
                                        const Spacer(),
                                        Visibility(
                                            visible: logic.bean.value!.detailList[index].isGreat == YorNType.Y,
                                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                                              Icon(IconFont.like, size: 22.sp),
                                              Text("手气最佳",
                                                  style: GoogleFonts.roboto(
                                                      color: const Color(0xffFFAE58),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13.sp))
                                            ]))
                                      ])
                                    ]),
                                  )
                                ]));
                          },
                          separatorBuilder: (_, index) {
                            return const Divider(height: 0);
                          },
                          itemCount: logic.bean.value!.detailList.length))
                ]);
              }))
    ]);
  }
}
