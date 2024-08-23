import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/utils/date_util.dart';

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
              height: 35.h, alignment: Alignment.center, child: Text(DateUtil.getWechatTime(message.sendTime)))),
      SizedBox(height: 10.h),
      Container(alignment: Alignment.center, child: Text("${message.content}"))
    ]);
  }
}
