import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';
import 'package:vura/widgets/round_image.dart';

class ItemSession extends StatelessWidget {
  final SessionEntity session;
  final VoidCallback? onLongPress;

  const ItemSession({super.key, required this.session, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return RadiusInkWellWidget(
        foregroundDecoration: session.moveTop
            ? RotatedCornerDecoration.withColor(
                color: const Color(0xff5F6FFF).withOpacity(.3), badgeSize: const Size(16, 16))
            : null,
        color: Colors.white,
        onPressed: () {
          Get.toNamed(RoutePath.CHAT_PAGE, arguments: {Keys.ID: session.id, Keys.TYPE: session.type});
        },
        onLongPress: onLongPress?.call,
        radius: 0,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: SizedBox(
          height: 88.r,
          child: Row(children: [
            RoundImage("${session.headImage}",
                width: 44.r,
                height: 44.r,
                radius: 9.r,
                errorWidget: session.type == SessionType.private
                    ? StringUtil.isNotEmpty(session.name)
                        ? Container(
                            width: 44.r,
                            height: 44.r,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: Colors.white, width: 1),
                                color: ColorUtil.strToColor(session.name!)),
                            alignment: Alignment.center,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(session.name![0],
                                        style: TextStyle(fontSize: 40.sp, color: Colors.white)))))
                        : Image.asset("assets/images/default_face.webp", width: 44.r, height: 44.r)
                    : null,
                errorImage: session.type == SessionType.private ? null : "assets/images/default_group_head.webp",
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
                Text(
                    session.lastMessage?.type == MessageType.IMAGE.code
                        ? "[图片]"
                        : session.lastMessage?.type == MessageType.AUDIO.code
                            ? "[语音]"
                            : session.lastMessage?.type == MessageType.VIDEO.code
                                ? "[视频]"
                                : session.lastMessage?.type == MessageType.FILE.code
                                    ? "[文件]"
                                    : session.lastMessage?.type == MessageType.RED_PACKAGE.code ||
                                            session.lastMessage?.type == MessageType.GROUP_RED_PACKAGE.code
                                        ? "[红包]"
                                        : session.lastMessage?.type == MessageType.ID_CARD.code
                                            ? "[个人名片]"
                                            : session.lastMessage?.content ?? "",
                    style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
              ]),
            )
          ]),
        ));
  }
}
