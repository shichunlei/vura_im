import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/modules/package/input_pay_password/dialog.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class TransferToMemberPage extends StatelessWidget {
  const TransferToMemberPage({super.key});

  TransferToMemberLogic get logic => Get.find<TransferToMemberLogic>();

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
                    Container(
                        margin: EdgeInsets.only(top: 13.h),
                        height: 50.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                        child: Row(children: [
                          Text("发给谁", style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp)),
                          const Spacer(),
                          AvatarRoundImage("${logic.user?.headImageThumb}",
                              height: 36.r, width: 36.r, radius: 4.r, name: logic.user?.nickName),
                          SizedBox(width: 11.w),
                          Text("${logic.user?.nickName}",
                              style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp))
                        ])),
                    Container(
                        margin: EdgeInsets.only(top: 13.h),
                        height: 50.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: const Color(0xffFEFAFA)),
                        child: Row(children: [
                          Text("金额", style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp)),
                          Expanded(
                              child: TextField(
                                  controller: logic.amountController,
                                  style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp, height: 1),
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
                                      hintStyle: GoogleFonts.roboto(
                                          fontSize: 15.sp, color: ColorUtil.color_999999, height: 1)))),
                          Text("元", style: GoogleFonts.roboto(color: const Color(0xffDB5549), fontSize: 15.sp))
                        ])),
                    Container(
                        margin: EdgeInsets.only(top: 13.h),
                        alignment: Alignment.centerLeft,
                        height: 50.h,
                        width: double.infinity,
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
                    SizedBox(height: 23.h),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("￥",
                              style: GoogleFonts.roboto(
                                  color: const Color(0xffDB5549), fontSize: 22.sp, fontWeight: FontWeight.bold)),
                          GetBuilder<TransferToMemberLogic>(
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
                            showToast(text: "请输入金额");
                            return;
                          }

                          Get.bottomSheet(
                                  InputPayPasswordDialog(
                                      amount: double.tryParse(logic.amountController.text), title: "转账金额"),
                                  isScrollControlled: true)
                              .then((value) {
                            if (value != null) logic.sendRedPackage();
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
    ]);
  }
}
