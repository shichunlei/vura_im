import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/utils/color_util.dart';
import 'package:wrapper/wrapper.dart';

class ItemReceiveText extends StatelessWidget {
  final MessageEntity message;

  const ItemReceiveText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {},
        child: Wrapper(
            spineType: SpineType.left,
            spineHeight: 10,
            angle: 90,
            offset: 10,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Container(
                constraints: BoxConstraints(maxWidth: .6.sw, minWidth: 0),
                child: Text('${message.content}',
                    style: TextStyle(color: ColorUtil.color_333333, fontSize: 15.sp, fontWeight: FontWeight.w600)))));
  }
}
