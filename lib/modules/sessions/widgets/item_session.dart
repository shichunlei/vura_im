import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/date_util.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';
import 'package:im/widgets/round_image.dart';

class ItemSession extends StatelessWidget {
  final SessionEntity session;

  const ItemSession({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return RadiusInkWellWidget(
        color: Colors.white,
        onPressed: () {
          Get.toNamed(RoutePath.CHAT_PAGE, arguments: {Keys.ID: session.id, Keys.TYPE: session.type});
        },
        onLongPress: () {},
        radius: 0,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: SizedBox(
          height: 88.r,
          child: Row(children: [
            RoundImage("${session.headImage}",
                width: 44.r,
                height: 44.r,
                radius: 9.r,
                errorImage: session.type == SessionType.private
                    ? "assets/images/default_face.webp"
                    : "assets/images/default_group_head.webp",
                placeholderImage: session.type == SessionType.private
                    ? "assets/images/default_face.webp"
                    : "assets/images/default_group_head.webp"),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Expanded(
                      child: Text("${session.name}",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w600))),
                  Text(session.lastMessageTime == 0 ? "" : DateUtil.getWechatTime(session.lastMessageTime),
                      style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 11.sp))
                ]),
                SizedBox(height: 3.h),
                Text(session.lastMessage?.content ?? "",
                    style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))
              ]),
            )
          ]),
        ));
  }
}
