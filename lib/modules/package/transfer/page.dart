import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class TransferResultPage extends StatelessWidget {
  final String? tag;

  const TransferResultPage({super.key, this.tag});

  TransferResultLogic get logic => Get.find<TransferResultLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: const Color(0xfffafafa), width: double.infinity, height: double.infinity),
      Image.asset("assets/images/package_top_bg.webp", width: double.infinity, fit: BoxFit.fitWidth),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: const Text("转账信息", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white)),
          body: BaseWidget(
              logic: logic,
              bgColor: Colors.transparent,
              builder: (logic) {
                return Column(children: [
                  SizedBox(height: 80.h, width: double.infinity),
                  AvatarRoundImage("${logic.bean.value!.senderHeadImage}",
                      width: 88.r, height: 88.r, radius: 9.r, name: logic.bean.value?.senderNickName),
                  SizedBox(height: 22.h),
                  Text("${logic.bean.value?.senderNickName}的幸运值",
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp, fontWeight: FontWeight.w600, color: ColorUtil.color_333333)),
                  SizedBox(height: 13.h),
                  Text("${logic.bean.value?.totalAmount ?? 0}幸运值",
                      style: GoogleFonts.roboto(
                          fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color(0xffDB5549))),
                  SizedBox(height: 44.h),
                  Text("${DateUtil.getDateStrByMs(logic.bean.value!.createTimestamp)}",
                      style: GoogleFonts.roboto(
                          fontSize: 13.sp, fontWeight: FontWeight.w600, color: ColorUtil.color_333333)),
                ]);
              }))
    ]);
  }
}
