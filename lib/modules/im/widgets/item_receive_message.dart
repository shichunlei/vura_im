import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/avatar_image.dart';

import 'item_receive_card.dart';
import 'item_receive_image.dart';
import 'item_receive_red_package.dart';
import 'item_receive_text.dart';

class ItemReceiveMessage extends StatelessWidget {
  final MessageEntity message;
  final bool showTime;

  const ItemReceiveMessage({super.key, required this.message, this.showTime = false});

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
      Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
        AvatarImageView("${message.sendHeadImage}", radius: 22.r, name: "${message.sendNickName}"),
        SizedBox(width: 10.w),
        GestureDetector(
            onLongPress: () {
              /// todo 消息长按操作
            },
            child: buildMessageView(message.type))
      ])
    ]);
  }

  Widget buildMessageView(int type) {
    if (type == MessageType.TEXT.code) return ItemReceiveText(message: message);
    if (type == MessageType.IMAGE.code && StringUtil.isNotEmpty(message.content)) {
      return ItemReceiveImage(message: message, file: FileEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.ID_CARD.code && StringUtil.isNotEmpty(message.content)) {
      return ItemReceiveCard(message: message, user: UserEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.RED_PACKAGE.code && message.content != null) {
      return ItemReceiveRedPackage(message: message);
    }
    return Text("暂未适配的消息类型${message.content}");
  }
}
