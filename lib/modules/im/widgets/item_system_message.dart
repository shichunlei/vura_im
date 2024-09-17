import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';

class ItemSystemMessage extends StatelessWidget {
  final MessageEntity message;
  final bool showTime;

  const ItemSystemMessage({super.key, required this.message, this.showTime = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Visibility(
          visible: showTime,
          child: Container(
              height: 30.h,
              alignment: Alignment.center,
              child: Text(DateUtil.getWechatTime(message.sendTime),
                  style: GoogleFonts.roboto(color: ColorUtil.color_666666, fontSize: 13.sp)))),
      SizedBox(height: 5.h),
      Container(
          alignment: Alignment.center,
          child: Text(
              message.type == MessageType.TIP_TEXT.code
                  ? "${message.content}"
                  : message.type == MessageType.GROUP_RED_PACKET_TIP_TEXT.code ||
                          message.type == MessageType.PRIVATE_RED_PACKET_TIP_TEXT.code
                      ? "${message.sendNickName}领取了您的红包"
                      : "",
              textAlign: TextAlign.center))
    ]);
  }
}
