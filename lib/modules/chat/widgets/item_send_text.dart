import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';

class ItemSendText extends StatelessWidget {
  final MessageEntity message;

  const ItemSendText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {

        },
        behavior: HitTestBehavior.translucent,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    topLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r)),
                color: const Color(0xff2ECC72)),
            constraints: BoxConstraints(maxWidth: .7.sw, minWidth: 0),
            child: Text('${message.content}',
                style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w600))));
  }
}
