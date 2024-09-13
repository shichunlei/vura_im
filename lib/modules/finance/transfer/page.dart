import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/package/input_pay_password/dialog.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  TransferLogic get logic => Get.find<TransferLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffC5E9C2), Color(0xfffafafa), Color(0xfffafafa), Color(0xfffafafa)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter))),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text("Transfer".tr), backgroundColor: Colors.transparent, centerTitle: true),
          body: BaseWidget(
              logic: logic,
              bgColor: Colors.transparent,
              builder: (logic) {
                return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Center(
                          child: SizedBox(
                              width: 265.w,
                              child: AspectRatio(aspectRatio: 1, child: Image.asset("assets/images/jinbi.webp")))),
                      Container(
                          height: 266.h,
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9.r), color: Colors.white),
                          margin: EdgeInsets.symmetric(vertical: 13.h),
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Column(children: [
                            Expanded(
                              child: Row(children: [
                                Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                      Text("数量",
                                          style: GoogleFonts.poppins(color: ColorUtil.color_333333, fontSize: 13.sp)),
                                      SizedBox(height: 10.h),
                                      TextField(
                                          controller: logic.amountController,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                          ],
                                          onChanged: logic.onTextChanged,
                                          style: GoogleFonts.poppins(
                                              fontSize: 26.sp,
                                              color: ColorUtil.color_333333,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "0",
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize: 26.sp,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                  color: ColorUtil.color_999999))),
                                      Row(children: [
                                        Text("可用:${logic.bean.value!.money} USDT",
                                            style: GoogleFonts.poppins(fontSize: 13.sp, color: ColorUtil.color_999999)),
                                        const Spacer(),
                                        GestureDetector(
                                            onTap: () {
                                              logic.amountController.text = "${logic.bean.value!.money}";
                                            },
                                            child: Text("全部",
                                                style: GoogleFonts.poppins(
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 13.sp,
                                                    decorationColor: ColorUtil.color_333333,
                                                    color: ColorUtil.color_333333))),
                                        SizedBox(width: 13.w)
                                      ])
                                    ])),
                                CustomIconButton(
                                    icon: Icon(IconFont.usdt, size: 18.sp),
                                    bgColor: const Color(0xfff5f5f5),
                                    radius: 17.5.r),
                                SizedBox(width: 13.w),
                                Text("USDT", style: GoogleFonts.poppins(fontSize: 15.sp, color: ColorUtil.color_333333))
                              ]),
                            ),
                            const Divider(height: 0),
                            // Expanded(
                            //     child: Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //       Text("地址",
                            //           style: GoogleFonts.poppins(color: ColorUtil.color_333333, fontSize: 13.sp)),
                            //       SizedBox(height: 10.h),
                            //       Row(children: [
                            //         Expanded(
                            //             child: TextField(
                            //                 controller: logic.addressController,
                            //                 style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333),
                            //                 decoration: InputDecoration(
                            //                     border: InputBorder.none,
                            //                     hintText: "请输入接收者地址",
                            //                     hintStyle: GoogleFonts.roboto(
                            //                         fontSize: 15.sp, color: ColorUtil.color_999999)))),
                            //         Text("粘贴",
                            //             style: GoogleFonts.poppins(
                            //                 color: const Color(0xff2ECC72),
                            //                 fontSize: 13.sp,
                            //                 decoration: TextDecoration.underline,
                            //                 decorationColor: const Color(0xff2ECC72)))
                            //       ])
                            //     ])),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text("用户",
                                      style: GoogleFonts.poppins(color: ColorUtil.color_333333, fontSize: 13.sp)),
                                  SizedBox(height: 10.h),
                                  GestureDetector(
                                      onTap: () {
                                        Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE, arguments: {"isCheckBox": false})
                                            ?.then((value) {
                                          if (value != null) logic.selectUser(value);
                                        });
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: SizedBox(
                                          height: 50.h,
                                          width: double.infinity,
                                          child: Obx(() {
                                            return Row(children: [
                                              Text("发给谁",
                                                  style: GoogleFonts.roboto(
                                                      color: ColorUtil.color_333333, fontSize: 15.sp)),
                                              const Spacer(),
                                              ...logic.user.value == null
                                                  ? [
                                                      Text("请选择联系人",
                                                          style: GoogleFonts.roboto(
                                                              color: ColorUtil.color_999999, fontSize: 15.sp))
                                                    ]
                                                  : [
                                                      AvatarRoundImage("${logic.user.value?.headImage}",
                                                          height: 36.r,
                                                          width: 36.r,
                                                          radius: 4.r,
                                                          name: logic.user.value?.nickName),
                                                      SizedBox(width: 11.w),
                                                      Text("${logic.user.value?.nickName}",
                                                          style: GoogleFonts.roboto(
                                                              color: ColorUtil.color_333333, fontSize: 15.sp))
                                                    ],
                                              Icon(Icons.keyboard_arrow_right,
                                                  size: 18.sp, color: ColorUtil.color_999999)
                                            ]);
                                          })))
                                ]))
                          ])),
                      Center(
                          child: RadiusInkWellWidget(
                              radius: 40,
                              onPressed: () {
                                DeviceUtils.hideKeyboard(context);

                                if (StringUtil.isEmpty(Get.find<RootLogic>().user.value?.payPassword)) {
                                  showToast(text: "请先设置支付密码");
                                  return;
                                }

                                if (StringUtil.isEmpty(logic.amountController.text)) {
                                  showToast(text: "请输入转账数量");
                                  return;
                                }

                                // if (StringUtil.isEmpty(logic.addressController.text)) {
                                //   showToast(text: "请输入收款者账号地址");
                                //   return;
                                // }

                                Get.bottomSheet(
                                        InputPayPasswordDialog(
                                            amount: double.tryParse(logic.amountController.text),
                                            title: "转账金额",
                                            isUsdt: true),
                                        isScrollControlled: true)
                                    .then((value) {
                                  if (value != null) logic.transferToMember(value);
                                });
                              },
                              margin: EdgeInsets.only(top: 8.h, bottom: 22.h),
                              child: Container(
                                  height: 44.h,
                                  width: 180.w,
                                  alignment: Alignment.center,
                                  child: Text("确认转账",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp))))),
                      Text("24h转账额度:0.00/0.00VURA",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_999999, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                      SizedBox(height: 5.h),
                      Text("到账数量=转账数量=手续费",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_999999, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                      SizedBox(height: 5.h),
                      Text("请勿用于其他比重，否则资产将不可找回",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_999999, fontWeight: FontWeight.w600, fontSize: 15.sp))
                    ]));
              }))
    ]);
  }
}
