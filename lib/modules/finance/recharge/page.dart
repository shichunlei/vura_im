import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class RechargePage extends StatelessWidget {
  const RechargePage({super.key});

  RechargeLogic get logic => Get.find<RechargeLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: ColorUtil.mainColor, width: double.infinity, height: double.infinity),
      Image.asset("assets/images/recharge_top_bg.webp", width: double.infinity, fit: BoxFit.fitWidth),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: Text("充值",
                  style: GoogleFonts.dmSans(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true),
          body: BaseWidget(
              logic: logic,
              bgColor: Colors.transparent,
              showEmpty: false,
              showLoading: false,
              builder: (logic) {
                return Column(children: [
                  SizedBox(height: 30.h),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Text("账户余额",
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18.sp))),
                  Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Text("${Get.find<RootLogic>().user.value?.money}",
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 44.sp))),
                  Expanded(
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
                              color: Colors.white),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("充值数量",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600, color: ColorUtil.color_333333, fontSize: 15.sp)),
                              Container(
                                  height: 57.h,
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                      controller: logic.controller,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, //只输入数字
                                      ],
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          hintText: "请输入充值数量",
                                          hintStyle:
                                              GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 22.h),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 105 / 72,
                                      crossAxisSpacing: 11.w,
                                      mainAxisSpacing: 11.w),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          logic.selectIndex.value = index;
                                          logic.controller.text = "${logic.list[index].usdt}";
                                        },
                                        behavior: HitTestBehavior.translucent,
                                        child: Obx(() {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  color: logic.selectIndex.value == index
                                                      ? const Color(0xff2ECC72).withOpacity(.2)
                                                      : const Color(0xffF1F6F7),
                                                  borderRadius: BorderRadius.circular(10.r),
                                                  border: Border.all(
                                                      color: logic.selectIndex.value == index
                                                          ? ColorUtil.mainColor
                                                          : const Color(0xffF1F6F7),
                                                      width: 1)),
                                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                                    textBaseline: TextBaseline.alphabetic,
                                                    children: [
                                                      Text("${logic.list[index].usdt}",
                                                          style: GoogleFonts.roboto(
                                                              color: logic.selectIndex.value == index
                                                                  ? ColorUtil.mainColor
                                                                  : ColorUtil.color_333333,
                                                              fontSize: 22.sp,
                                                              fontWeight: FontWeight.bold)),
                                                      Text("u",
                                                          style: GoogleFonts.roboto(
                                                              color: logic.selectIndex.value == index
                                                                  ? ColorUtil.mainColor
                                                                  : ColorUtil.color_333333,
                                                              fontSize: 12.sp,
                                                              fontWeight: FontWeight.w600))
                                                    ]),
                                                Text(
                                                    "≈￥${StringUtil.formatPrice(logic.list[index].money)}", // TODO  人民币
                                                    style: GoogleFonts.roboto(
                                                        color: logic.selectIndex.value == index
                                                            ? ColorUtil.mainColor
                                                            : ColorUtil.color_999999,
                                                        fontSize: 13.sp))
                                              ]));
                                        }));
                                  },
                                  itemCount: logic.list.length),
                              const Divider(height: 0),
                              SizedBox(height: 22.h),
                              Text("选择付款方式",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600, color: ColorUtil.color_333333, fontSize: 15.sp)),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 22.h),
                                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                                  height: 62.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11.r),
                                      border: Border.all(width: 1, color: const Color(0xffF1F6F7))),
                                  child: Row(children: [
                                    Image.asset("assets/images/USDT.png", width: 44.r, height: 44.r),
                                    SizedBox(width: 13.w),
                                    Expanded(
                                        child: Text("USDT",
                                            style: GoogleFonts.dmSans(
                                                color: ColorUtil.color_333333,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold))),
                                    Icon(IconFont.check, size: 15.sp)
                                  ])),
                              Row(children: [
                                Text("参考单价", style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                Text("${StringUtil.formatPrice(logic.exchangeRate.value)}CNY",
                                    style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333))
                              ]),
                              SizedBox(height: 22.h),
                              Row(children: [
                                Text("预计支付", style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                GetBuilder<RechargeLogic>(
                                    init: logic,
                                    builder: (logic) {
                                      return Text(
                                          "≈￥${StringUtil.formatPrice(StringUtil.isEmpty(logic.controller.text) ? 0 : (double.parse(logic.controller.text) * logic.exchangeRate.value))}",
                                          // TODO  人民币
                                          style: GoogleFonts.roboto(
                                              color: const Color(0xffFF4255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp));
                                    })
                              ]),
                              Center(
                                  child: RadiusInkWellWidget(
                                      radius: 40,
                                      onPressed: () {
                                        DeviceUtils.hideKeyboard(context);
                                        if (StringUtil.isEmpty(Get.find<RootLogic>().user.value?.payPassword)) {
                                          showToast(text: "请先设置支付密码");
                                          return;
                                        }

                                        if (StringUtil.isEmpty(logic.controller.text)) {
                                          showToast(text: "请输入充值数量");
                                          return;
                                        }

                                        Get.toNamed(RoutePath.PAY_VOUCHER_PAGE,
                                            arguments: {"money": double.parse(logic.controller.text)});
                                      },
                                      margin: EdgeInsets.only(top: 44.h),
                                      child: Container(
                                          height: 53.h,
                                          width: 180.w,
                                          alignment: Alignment.center,
                                          child: Text("充值USDT",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)))))
                            ]),
                          )))
                ]);
              }))
    ]);
  }
}
