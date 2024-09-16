import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/package/input_pay_password/dialog.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class PackagePublishPage extends StatelessWidget {
  const PackagePublishPage({super.key});

  PackagePublishLogic get logic => Get.find<PackagePublishLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: const Color(0xfffafafa), width: double.infinity, height: double.infinity),
      Image.asset("assets/images/red_package_publish_bg.webp", width: double.infinity, fit: BoxFit.fitWidth),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: const Text("发幸运值", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white)),
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: DeviceUtils.setBottomMargin(22.h)),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                  child: Column(children: [
                    logic.type == SessionType.private
                        ? logic.isTransfer
                            ? Container(
                                margin: EdgeInsets.only(top: 13.h),
                                height: 50.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 18.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                                child: Row(children: [
                                  Text("发给谁",
                                      style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp)),
                                  const Spacer(),
                                  AvatarRoundImage("${logic.user?.headImageThumb}",
                                      height: 36.r, width: 36.r, radius: 4.r, name: logic.user?.nickName),
                                  SizedBox(width: 11.w),
                                  Text("${logic.user?.nickName}",
                                      style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp))
                                ]))
                            : const SizedBox()
                        : Container(
                            height: 50.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                            child: Row(children: [
                              Text("幸运值个数", style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp)),
                              Expanded(
                                  child: TextField(
                                      controller: logic.countController,
                                      style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp),
                                      textAlign: TextAlign.end,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: InputDecoration(
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                          hintText: "填写个数",
                                          hintStyle:
                                              GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)))),
                              Text("个", style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp))
                            ])),
                    Container(
                        margin: EdgeInsets.only(top: 13.h),
                        height: 50.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                        child: Row(children: [
                          Text(logic.type == SessionType.private ? "幸运值金额" : "总金额",
                              style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp)),
                          Expanded(
                              child: TextField(
                                  controller: logic.amountController,
                                  style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp),
                                  textAlign: TextAlign.end,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  onChanged: logic.onTextChanged,
                                  decoration: InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                      hintText: "￥0.00",
                                      hintStyle: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)))),
                          Text("元", style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp))
                        ])),
                    logic.type == SessionType.private
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.only(top: 13.h),
                            height: 50.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                                controller: logic.valueController,
                                style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // 只允许输入数字和逗号
                                ],
                                onChanged: logic.validateInput,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(right: 10.w),
                                    hintText: "请输入幸运值",
                                    hintStyle: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)))),
                    Container(
                        margin: EdgeInsets.only(top: 13.h),
                        height: 50.h,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                        child: TextField(
                            controller: logic.textController,
                            style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp),
                            decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(right: 10.w),
                                hintText: "恭喜发财，大吉大利",
                                hintStyle: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)))),
                    Container(
                        margin: EdgeInsets.only(top: 13.h),
                        width: double.infinity,
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                        child: Column(children: [
                          Container(
                              height: 50.h,
                              padding: EdgeInsets.only(left: 18.w, right: 8.w),
                              child: Row(children: [
                                Text("幸运值封面",
                                    style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp)),
                                const Spacer(),
                                CustomIconButton(
                                    icon: Obx(() {
                                      return Icon(
                                          logic.showCover.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up);
                                    }),
                                    onPressed: logic.showCover.toggle,
                                    radius: 25.r)
                              ])),
                          Obx(() {
                            return Visibility(
                                visible: logic.showCover.value,
                                child: Column(children: [
                                  const Divider(height: 0),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(left: 18.w, top: 18.h, bottom: 15.h),
                                      child: Text("默认封面",
                                          style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 13.sp))),
                                  Container(
                                      margin: EdgeInsets.only(left: 18.w),
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Image.asset(logic.selectCover.value.imagePath, height: 137.r, width: 94.r)),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(left: 18.w, top: 18.h, bottom: 15.h),
                                      child: Text("推荐封面",
                                          style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 13.sp))),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(left: 18.w, bottom: 18.h),
                                      child: Wrap(
                                          spacing: 11.w,
                                          children: List.generate(3, (index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  logic.selectCoverFun(logic.packageCovers2[index]);
                                                },
                                                behavior: HitTestBehavior.translucent,
                                                child: Image.asset(logic.packageCovers2[index].imagePath,
                                                    height: 132.r, width: 89.r));
                                          })))
                                ]));
                          })
                        ])),
                    SizedBox(height: 23.h),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("￥",
                              style: GoogleFonts.roboto(
                                  color: const Color(0xffDB5549), fontSize: 22.sp, fontWeight: FontWeight.bold)),
                          GetBuilder<PackagePublishLogic>(
                              init: logic,
                              builder: (logic) {
                                return Text(
                                    StringUtil.isEmpty(logic.amountController.text)
                                        ? "0.00"
                                        : double.parse(logic.amountController.text).toStringAsFixed(2),
                                    style: GoogleFonts.roboto(
                                        color: const Color(0xffDB5549), fontSize: 44.sp, fontWeight: FontWeight.bold));
                              })
                        ]),
                    RadiusInkWellWidget(
                        color: const Color(0xffDB5549),
                        onPressed: () {
                          DeviceUtils.hideKeyboard(context);
                          if (StringUtil.isEmpty(Get.find<RootLogic>().user.value?.payPassword)) {
                            showToast(text: "请先设置支付密码");
                            return;
                          }

                          if (StringUtil.isEmpty(logic.amountController.text)) {
                            showToast(text: "请输入总金额");
                            return;
                          }

                          if (logic.type == SessionType.group && StringUtil.isEmpty(logic.countController.text)) {
                            showToast(text: "请输入幸运值个数");
                            return;
                          }

                          Get.bottomSheet(
                                  InputPayPasswordDialog(
                                      amount: double.tryParse(logic.amountController.text),
                                      title: logic.isTransfer ? "转账金额" : "红包金额"),
                                  isScrollControlled: true)
                              .then((value) {
                            if (value != null) logic.sendRedPackage(value);
                          });
                        },
                        radius: 40,
                        margin: EdgeInsets.only(top: 22.h),
                        child: Container(
                            height: 45.h,
                            width: 180.w,
                            alignment: Alignment.center,
                            child: Text("确认发送",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18.sp))))
                  ])))),
      Positioned(
          top: 30.h + DeviceUtils.topSafeHeight,
          left: 8.w,
          child: Image.asset("assets/images/red_package_image.png", width: 56.w, height: 56.w))
    ]);
  }
}
