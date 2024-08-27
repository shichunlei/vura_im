import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/date_util.dart';

class ItemReceiveRedPackage extends StatelessWidget {
  final MessageEntity message;

  const ItemReceiveRedPackage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: message.id});
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.r),
                gradient: const LinearGradient(
                    colors: [Color(0xffF99C3C), Color(0xffDB5549)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            width: 227.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 13.h),
              Row(children: [
                SizedBox(width: 18.w),
                Image.asset("assets/images/red_package.png", width: 35.r, height: 35.r),
                SizedBox(width: 13.w),
                Text("x23429",
                    style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text("23432",
                    style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 15.w)
              ]),
              SizedBox(height: 13.h),
              const Divider(height: 0, color: Colors.white12),
              Container(
                  height: 38.h,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 13.w),
                  child: Text("${DateUtil.getDateStrByMs(message.sendTime)}",
                      style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.white)))
            ])));
  }
}
