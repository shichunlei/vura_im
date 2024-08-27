import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/utils/color_util.dart';

class ItemReceiveText extends StatelessWidget {
  final MessageEntity message;

  const ItemReceiveText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {},
        child: Container(
            margin: EdgeInsets.only(top: 5.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.r),
                    topLeft: Radius.circular(5.r),
                    bottomRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r)),
                color: Colors.white),
            constraints: BoxConstraints(maxWidth: .6.sw, minWidth: 0),
            child: Text('${message.content}',
                style: TextStyle(color: ColorUtil.color_333333, fontSize: 15.sp, fontWeight: FontWeight.w600))));
  }
}
