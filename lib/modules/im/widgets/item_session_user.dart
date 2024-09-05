import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/avatar_image.dart';

class ItemSessionUser extends StatelessWidget {
  final MemberEntity member;
  final String? groupId;
  final bool addFriend;
  final bool isAdmin;

  const ItemSessionUser({super.key, required this.member, this.groupId, this.addFriend = true, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AspectRatio(
          aspectRatio: 1,
          child: AvatarRoundImage("${member.headImage}",
              width: double.infinity,
              height: double.infinity,
              radius: 5.r,
              onTap: addFriend || isAdmin
                  ? () {
                      Get.toNamed(RoutePath.SESSION_MEMBER_PAGE,
                          arguments: {Keys.ID: member.userId, Keys.GROUP_ID: groupId, "isAdmin": isAdmin});
                    }
                  : null,
              name: member.showNickName)),
      SizedBox(height: 10.h),
      Text("${member.showNickName}",
          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999),
          maxLines: 1,
          overflow: TextOverflow.ellipsis)
    ]);
  }
}
