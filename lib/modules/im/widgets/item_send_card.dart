import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/widgets/widgets.dart';

class ItemSendCard extends StatelessWidget {
  final MessageEntity message;
  final UserEntity user;

  const ItemSendCard({super.key, required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (user.id == Get.find<RootLogic>().user.value?.id) {
            Get.toNamed(RoutePath.MY_INFO_PAGE);
          } else {
            Get.toNamed(RoutePath.USER_INFO_PAGE, arguments: {Keys.ID: user.id});
          }
        },
        child: Container(
            margin: EdgeInsets.only(top: 5.h),
            width: 227.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    topLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r)),
                color: const Color(0xff2ECC72)),
            child: Column(children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  height: 65.h,
                  child: Row(children: [
                    AvatarRoundImage("${user.headImageThumb}",
                        width: 35.r, height: 35.r, radius: 8.r, name: user.nickName),
                    SizedBox(width: 13.w),
                    Expanded(
                        child:
                            Text("${user.nickName}", style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.white)))
                  ])),
              const Divider(height: 0, color: Colors.white12),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  height: 38.h,
                  child: Row(children: [
                    Text("个人名片", style: GoogleFonts.roboto(fontSize: 11.sp, color: Colors.white60)),
                    const Spacer(),
                    Text(DateUtil.getWechatTime(message.sendTime),
                        style: GoogleFonts.roboto(fontSize: 11.sp, color: Colors.white60))
                  ]))
            ])));
  }
}
