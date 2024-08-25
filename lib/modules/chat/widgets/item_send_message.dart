import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/entities/file_entity.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/modules/chat/widgets/item_send_red_package.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/date_util.dart';

import 'item_send_card.dart';
import 'item_send_image.dart';
import 'item_send_text.dart';

class ItemSendMessage extends StatelessWidget {
  final MessageEntity message;
  final bool showTime;

  const ItemSendMessage({super.key, required this.message, this.showTime = false});

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
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
            onLongPress: () {
              /// TODO 消息长按操作

            },
            child: buildMessageView(message.type))
      ])
    ]);
  }

  Widget buildMessageView(int type) {
    if (type == MessageType.TEXT.code) return ItemSendText(message: message);
    if (type == MessageType.IMAGE.code && message.content != null) {
      return ItemSendImage(message: message, file: FileEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.ID_CARD.code && message.content != null) {
      return ItemSendCard(message: message, user: UserEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.RED_PACKAGE.code && message.content != null) {
      return ItemSendRedPackage(message: message);
    }
    return Text("暂未适配的消息类型${message.content}");
  }
}
