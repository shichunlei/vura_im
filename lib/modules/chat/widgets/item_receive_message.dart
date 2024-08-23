import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/utils/date_util.dart';
import 'package:im/widgets/avatar_image.dart';

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
              height: 35.h, alignment: Alignment.center, child: Text(DateUtil.getWechatTime(message.sendTime)))),
      SizedBox(height: 10.h),
      Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        AvatarImageView("${message.sendHeadImage}", radius: 22.r, name: "${message.sendNickName}"),
        buildMessageView(message.type)
      ])
    ]);
  }

  Widget buildMessageView(int type) {
    switch (type) {
      case 0: // 文本
        return ItemReceiveText(message: message);
      case 904: // 红包
        return ItemReceiveText(message: message);
      default:
        return Container(child: Text("${message.content}"));
    }
  }
}
