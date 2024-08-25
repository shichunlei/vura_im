import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/global/icon_font.dart';

class ItemSendVoice extends StatelessWidget {
  final MessageEntity message;

  const ItemSendVoice({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Container(
            margin: EdgeInsets.only(top: 5.h),
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    topLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r)),
                color: Colors.white),
            width: 140.w,
            child: Row(children: [
              Text('10s',
                  style: TextStyle(color: const Color(0xff2ECC72), fontSize: 15.sp, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(IconFont.send_voice, color: const Color(0xff2ECC72), size: 22.sp)
            ])));
  }
}
