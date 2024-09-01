import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class ChargeWayPage extends StatelessWidget {
  const ChargeWayPage({super.key});

  ChargeWayLogic get logic => Get.find<ChargeWayLogic>();

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
          appBar: AppBar(title: const Text("添加收款方式"), backgroundColor: Colors.transparent, centerTitle: true),
          body: BaseWidget(
              logic: logic,
              showEmpty: false,
              showError: false,
              builder: (logic) {
                return Column(children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
                          margin: EdgeInsets.only(left: 22.w, right: 22.w, top: 22.h),
                          child: Column(children: [
                            Container(
                                height: 62.h,
                                alignment: Alignment.center,
                                child: Text("USDT钱包",
                                    style: GoogleFonts.roboto(
                                        color: const Color(0xff2ECC72), fontWeight: FontWeight.bold, fontSize: 18.sp))),
                            const Divider(height: 0),
                            Expanded(
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 22.h),
                                    width: double.infinity,
                                    child: logic.list.isNotEmpty
                                        ? ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (_, index) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Row(children: [
                                                    Text("地址${StringUtil.numToChinese(index + 1)}",
                                                        style: GoogleFonts.roboto(
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorUtil.color_333333,
                                                            fontSize: 15.sp)),
                                                    const Spacer(),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Get.toNamed(RoutePath.ADD_CHARGE_WAY_PAGE,
                                                              arguments: {Keys.DATA: logic.list[index]});
                                                        },
                                                        behavior: HitTestBehavior.translucent,
                                                        child: Icon(IconFont.edit,
                                                            color: ColorUtil.color_333333, size: 18.sp))
                                                  ]),
                                                  SizedBox(height: 5.h),
                                                  Text("${logic.list[index].walletCard}",
                                                      style: GoogleFonts.roboto(
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorUtil.color_333333,
                                                          fontSize: 13.sp)),
                                                  SizedBox(height: 4.h),
                                                  Row(children: [
                                                    Text("备注",
                                                        style: GoogleFonts.roboto(
                                                            color: ColorUtil.color_999999, fontSize: 13.sp)),
                                                    const Spacer(),
                                                    Text("${logic.list[index].walletRemark}",
                                                        style: GoogleFonts.roboto(
                                                            color: ColorUtil.color_999999, fontSize: 13.sp))
                                                  ])
                                                ]),
                                              );
                                            },
                                            separatorBuilder: (_, index) {
                                              return const Divider(height: 0);
                                            },
                                            itemCount: logic.list.length)
                                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Image.asset("assets/images/empty.webp", width: 177.w, height: 177.w),
                                            SizedBox(height: 11.h),
                                            Text("暂无数据",
                                                style:
                                                    GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp))
                                          ])))
                          ]))),
                  Visibility(
                      visible: logic.list.isEmpty,
                      child: RadiusInkWellWidget(
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          radius: 40,
                          onPressed: () {
                            Get.toNamed(RoutePath.ADD_CHARGE_WAY_PAGE);
                          },
                          margin: EdgeInsets.only(top: 44.h, bottom: DeviceUtils.setBottomMargin(22.h)),
                          child: Container(
                              height: 53.h,
                              width: 180.w,
                              alignment: Alignment.center,
                              child: Text("新增收款方式",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)))))
                ]);
              }))
    ]);
  }
}
