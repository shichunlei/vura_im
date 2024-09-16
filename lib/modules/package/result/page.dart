import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/red_package_result.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class PackageResultPage extends StatelessWidget {
  final String? tag;

  const PackageResultPage({super.key, this.tag});

  PackageResultLogic get logic => Get.find<PackageResultLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: const Color(0xfffafafa), width: double.infinity, height: double.infinity),
      Image.asset("assets/images/package_top_bg.webp", width: double.infinity, fit: BoxFit.fitWidth),
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
              bgColor: Colors.transparent,
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
                  SizedBox(height: 22.h),
                  Visibility(
                      visible: StringUtil.isNotEmpty(logic.bean.value?.minesStr),
                      child: Text("${logic.bean.value?.minesStr}".replaceAll(",", ""),
                          style: GoogleFonts.roboto(fontSize: 25.sp, color: ColorUtil.color_666666))),
                  SizedBox(height: StringUtil.isNotEmpty(logic.bean.value?.minesStr) ? 11.h : 22.h),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: logic.myRedPackage
                          ? [
                              Text(logic.bean.value!.totalTime > 0 ? "已领取" : "未领取",
                                  style: GoogleFonts.roboto(
                                      fontSize: StringUtil.isNotEmpty(logic.bean.value?.minesStr) ? 20.sp : 30.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffDB5549)))
                            ]
                          : logic.bean.value!.totalTime > 0 &&
                                  logic.bean.value!.detailList
                                      .every((item) => item.userId != Get.find<RootLogic>().user.value?.id)
                              ? [
                                  Text("手慢了，已领完",
                                      style: GoogleFonts.roboto(
                                          fontSize: StringUtil.isNotEmpty(logic.bean.value?.minesStr) ? 20.sp : 30.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffDB5549)))
                                ]
                              : [
                                  Text("${logic.bean.value?.amount}",
                                      style: GoogleFonts.roboto(
                                          fontSize: StringUtil.isNotEmpty(logic.bean.value?.minesStr) ? 20.sp : 44.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffDB5549))),
                                  Text("幸运值",
                                      style: GoogleFonts.roboto(
                                          fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xffDB5549)))
                                ]),
                  SizedBox(height: 22.h),
                  Container(
                      margin: EdgeInsets.only(bottom: 11.h, left: 22.w),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          logic.bean.value!.totalTime > 0
                              ? "${logic.bean.value!.totalPacket}个幸运值,${DateUtil.formatDuration(logic.bean.value!.totalTime)}被抢光"
                              : "${logic.bean.value!.totalPacket}个幸运值，余${logic.balance.value}/${logic.bean.value!.totalAmount}",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp, fontWeight: FontWeight.w600, color: ColorUtil.color_333333))),
                  Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          itemBuilder: (_, index) {
                            return ItemRedPackage(redPackageResult: logic.bean.value!.detailList[index]);
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

class ItemRedPackage extends StatelessWidget {
  final RedPackageResultEntity redPackageResult;

  const ItemRedPackage({super.key, required this.redPackageResult});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(children: [
          AvatarRoundImage("${redPackageResult.headImage}",
              width: 66.r, height: 66.r, radius: 7.r, name: redPackageResult.nickName),
          SizedBox(width: 22.w),
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Text("${redPackageResult.nickName}",
                    style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.sp)),
                const Spacer(),
                Text("${redPackageResult.amount}幸运值",
                    style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.sp))
              ]),
              SizedBox(height: 5.h),
              Row(children: [
                Text("${redPackageResult.createDate}",
                    style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp)),
                const Spacer(),
                Visibility(
                    visible: redPackageResult.isGreat == YorNType.Y,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(IconFont.like, size: 22.sp),
                      Text("手气最佳",
                          style: GoogleFonts.roboto(
                              color: const Color(0xffFFAE58), fontWeight: FontWeight.w600, fontSize: 13.sp))
                    ])),
                Visibility(
                    visible: redPackageResult.isMine == YorNType.Y,
                    child: SvgPicture.asset("assets/svg/mine.svg", width: 25.r, height: 25.r))
              ])
            ]),
          )
        ]));
  }
}
