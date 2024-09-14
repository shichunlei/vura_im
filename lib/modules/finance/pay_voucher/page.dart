import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/package/input_pay_password/dialog.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/utils/tool_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class PayVoucherPage extends StatelessWidget {
  const PayVoucherPage({super.key});

  PayVoucherLogic get logic => Get.find<PayVoucherLogic>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffC5E9C2), Color(0xfffafafa), Color(0xfffafafa), Color(0xfffafafa)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter))),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: const Text("充值USDT"), backgroundColor: Colors.transparent, centerTitle: true),
            body: BaseWidget(
                logic: logic,
                bgColor: Colors.transparent,
                builder: (logic) {
                  return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 22.w),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r), color: Colors.white),
                            child: Column(children: [
                              SizedBox(height: 22.h),
                              Text("扫码支付", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              SizedBox(height: 22.h),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 60.w),
                                  child:
                                      AspectRatio(aspectRatio: 1, child: Image.network("${logic.bean.value!.qrCode}"))),
                              SizedBox(height: 22.h),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "充值金额",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w500)),
                                const TextSpan(text: "（USDT）")
                              ], style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 22.h),
                                  child: Text("${logic.money}",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff2ECC72),
                                          fontSize: 35.sp))),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                                  margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.r), color: const Color(0xfffafafa)),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      Text("充值地址",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              color: ColorUtil.color_333333,
                                              fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      CustomIconButton(
                                          radius: 15.r,
                                          icon: Icon(IconFont.copy, color: ColorUtil.color_999999, size: 18.sp),
                                          onPressed: () {
                                            copyToClipboard("${logic.bean.value!.address}");
                                          })
                                    ]),
                                    SizedBox(height: 8.h),
                                    Text("${logic.bean.value!.address}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 13.sp,
                                            color: ColorUtil.color_999999,
                                            fontWeight: FontWeight.w600))
                                  ]))
                            ])),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                            margin: EdgeInsets.symmetric(vertical: 22.h),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r), color: Colors.white),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("支付凭证",
                                  style: GoogleFonts.roboto(
                                      fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w600)),
                              Container(
                                  margin: EdgeInsets.only(top: 20.h, bottom: 13.h),
                                  width: 75.w,
                                  height: 75.w,
                                  child: logic.imagePath.value == null
                                      ? GestureDetector(
                                          onTap: () {
                                            pickerImage(ImageSource.gallery, cropImage: false).then((path) {
                                              if (path != null) {
                                                logic.imagePath.value = path;
                                                logic.uploadImage();
                                              }
                                            });
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(12),
                                              padding: EdgeInsets.zero,
                                              color: ColorUtil.color_999999,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 75.w,
                                                      height: 75.w,
                                                      child: Icon(IconFont.add,
                                                          color: ColorUtil.color_999999, size: 30.r)))))
                                      : Stack(clipBehavior: Clip.none, children: [
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.file(File(logic.imagePath.value!),
                                                  fit: BoxFit.cover, width: 75.w, height: 75.w)),
                                          Positioned(
                                              top: -5,
                                              right: -5,
                                              child: CustomIconButton(
                                                  bgColor: Colors.red,
                                                  radius: 10.r,
                                                  icon: Icon(Icons.close, color: Colors.white, size: 15.r),
                                                  onPressed: () {
                                                    logic.imagePath.value = null;
                                                  }))
                                        ])),
                              Container(
                                  width: 75.w,
                                  alignment: Alignment.center,
                                  child: Text(logic.imagePath.value == null ? "点击上传" : "点击查看",
                                      style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))
                            ])),
                        Center(
                            child: RadiusInkWellWidget(
                                radius: 40,
                                onPressed: () {
                                  if (StringUtil.isEmpty(logic.imagePath.value)) {
                                    showToast(text: "上传充值凭证");
                                    return;
                                  }

                                  Get.bottomSheet(
                                          InputPayPasswordDialog(
                                              amount: logic.money, title: "充值金额", tip: "支付账户", isUsdt: true),
                                          isScrollControlled: true)
                                      .then((value) {
                                    if (value != null) logic.recharge(value);
                                  });
                                },
                                margin: EdgeInsets.only(bottom: 22.h),
                                child: Container(
                                    height: 53.h,
                                    width: 180.w,
                                    alignment: Alignment.center,
                                    child: Text("提交",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)))))
                      ]));
                }))
      ]),
    );
  }
}
