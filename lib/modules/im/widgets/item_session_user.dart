import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/session_detail/group/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/avatar_image.dart';

class ItemSessionUser extends StatelessWidget {
  final MemberEntity member;
  final String? groupId;
  final String? tag;

  const ItemSessionUser({super.key, required this.member, this.groupId, this.tag});

  GroupSessionDetailLogic get logic => Get.find<GroupSessionDetailLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AspectRatio(
          aspectRatio: 1,
          child: AvatarRoundImage("${member.headImage}",
              width: double.infinity,
              height: double.infinity,
              radius: 5.r,
              border: null,
              foregroundDecoration: member.isSupAdmin == YorNType.Y || member.isAdmin == YorNType.Y
                  ? RotatedCornerDecoration.withColor(
                      color: const Color(0xff4857E2),
                      badgeSize: const Size(32, 32),
                      badgeCornerRadius: Radius.circular(5.r),
                      badgePosition: BadgePosition.topStart,
                      textSpan: TextSpan(
                          text: member.isAdmin == YorNType.Y ? "群主" : "管理员",
                          style: TextStyle(color: Colors.white, fontSize: member.isAdmin == YorNType.Y ? 10.sp : 8.sp)))
                  : null,
              onTap: logic.bean.value?.configObj?.addFriend == YorNType.N
                  ? () {
                      Get.toNamed(RoutePath.SESSION_MEMBER_PAGE, arguments: {
                        Keys.ID: member.userId,
                        Keys.GROUP_ID: groupId,
                        "isAdmin": member.isAdmin == YorNType.Y
                      });
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
