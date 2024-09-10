import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/package_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/chat/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/enum_to_string.dart';

class ItemSendRedPackage extends StatelessWidget {
  final MessageEntity message;
  final String? tag;
  final RedPackageEntity redPackage;

  const ItemSendRedPackage({super.key, required this.message, this.tag, required this.redPackage});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (logic.type == SessionType.private) {
            // 单聊自己发的红包不能打开，可以直接查看结果
            if (redPackage.type == RedPackageType.SPECIAL.code) {
              Get.toNamed(RoutePath.TRANSFER_RESULT_PAGE, arguments: {Keys.ID: redPackage.id, "myRedPackage": true});
            } else {
              Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackage.id, "myRedPackage": true});
            }
          } else {
            logic.openRedPackage(context, message, redPackage);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9.r), color: const Color(0xffF0924A)),
            width: 272.w,
            child: Stack(children: [
              Positioned(
                  right: 0,
                  top: 0,
                  child: Image.asset(
                      EnumToString.fromString(RedPackageCoverType.values, redPackage.cover,
                              defaultValue: RedPackageCoverType.cover_0)!
                          .itemPath,
                      width: 99.w)),
              Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: 13.h),
                Row(children: [
                  SizedBox(width: 18.w),
                  Image.asset("assets/images/red_package.png", width: 35.r, height: 35.r),
                  SizedBox(width: 13.w),
                  ...redPackage.type == 3
                      ? [
                          Text("x${redPackage.totalAmount}",
                              style:
                                  GoogleFonts.inter(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text("${redPackage.minesStr}",
                              style:
                                  GoogleFonts.inter(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold))
                        ]
                      : redPackage.type == 4
                          ? [
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("x${redPackage.totalAmount}",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.sp)),
                                    Text("${redPackage.blessing}",
                                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 14.sp)),
                                  ])
                            ]
                          : [
                              Text("${redPackage.blessing}",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.sp))
                            ],
                  SizedBox(width: 15.w)
                ]),
                SizedBox(height: 13.h),
                const Divider(height: 0, color: Colors.white12),
                Container(
                    height: 38.h,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 13.w, right: 13.w),
                    child: Row(children: [
                      Text("${redPackage.expireTime}", style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.white)),
                      const Spacer(),
                      Visibility(
                          visible: redPackage.type == 4,
                          child: Text("USDT转账", style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.white))),
                    ]))
              ])
            ])));
  }
}
