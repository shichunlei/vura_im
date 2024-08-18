import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';
import 'package:wrapper/wrapper.dart';

class ItemSendText extends StatelessWidget {
  final MessageEntity message;

  const ItemSendText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      GestureDetector(
          onDoubleTap: () {},
          behavior: HitTestBehavior.translucent,
          child: Wrapper(
              spineType: SpineType.right,
              spineHeight: 10,
              angle: 90,
              offset: 10,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              color: const Color(0xff2ECC72),
              child: Container(
                  constraints: BoxConstraints(maxWidth: .7.sw, minWidth: 0),
                  child: Text('${message.content}',
                      style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w600)))))
    ]);
  }
}
