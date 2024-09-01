import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/package_entity.dart';
import 'package:vura/modules/im/chat/logic.dart';

class ItemReceiveRedPackage extends StatelessWidget {
  final MessageEntity message;
  final String? tag;
  final RedPackageEntity redPackage;

  const ItemReceiveRedPackage({super.key, required this.message, this.tag, required this.redPackage});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          logic.openRedPackage(message.id, redPackage.id);
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
              redPackage.type == 3
                  ? Row(children: [
                      SizedBox(width: 18.w),
                      Image.asset("assets/images/red_package.png", width: 35.r, height: 35.r),
                      SizedBox(width: 13.w),
                      Text("x${redPackage.totalAmount}",
                          style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text("${redPackage.minesStr}",
                          style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(width: 15.w)
                    ])
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      height: 35.r,
                      alignment: Alignment.centerLeft,
                      child: Text("${redPackage.blessing}",
                          style:
                              GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.sp))),
              SizedBox(height: 13.h),
              const Divider(height: 0, color: Colors.white12),
              Container(
                  height: 38.h,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 13.w),
                  child:
                      Text("${redPackage.expireTime}", style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.white)))
            ])));
  }
}
