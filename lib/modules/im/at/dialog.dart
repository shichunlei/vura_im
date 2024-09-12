import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class SelectAtMemberDialog extends StatelessWidget {
  final List<MemberEntity> members;

  const SelectAtMemberDialog({super.key, required this.members});

  SelectAtMemberLogic get logic => Get.put(SelectAtMemberLogic(members));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: .65.sh,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: const Text("选择@的人"),
                centerTitle: true,
                actions: [
                  Obx(() => logic.isCheckBox.value
                      ? TextButton(
                          onPressed: logic.selectMembers.isEmpty
                              ? null
                              : () {
                                  Get.back(result: logic.selectMembers);
                                },
                          child: Text("Done".tr))
                      : CustomIconButton(
                          icon: Text("多选", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp)),
                          onPressed: logic.isCheckBox.toggle))
                ],
                // bottom: AppBarBottomSearchView(onSubmitted: (String value) {}),
                leading: Obx(() => logic.isCheckBox.value
                    ? TextButton(
                        onPressed: logic.isCheckBox.toggle,
                        child: Text("Cancel".tr, style: GoogleFonts.roboto(color: ColorUtil.color_999999)))
                    : CustomIconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, color: ColorUtil.color_333333),
                        onPressed: Get.back))),
            body: ListView.builder(
                itemBuilder: (_, index) {
                  return Obx(() {
                    return logic.isCheckBox.value
                        ? CheckboxListTile(
                            value: logic.selectMembers.any((item) => item.userId == logic.members[index].userId),
                            onChanged: (v) {
                              if (v!) {
                                logic.selectMembers.add(logic.members[index]);
                              } else {
                                logic.selectMembers.removeWhere((item) => logic.members[index].userId == item.userId);
                              }
                            },
                            title: Row(children: [
                              AvatarRoundImage("${logic.members[index].headImage}",
                                  width: 35.r, height: 35.r, radius: 5.r, name: logic.members[index].showNickName),
                              SizedBox(width: 10.h),
                              Text("${logic.members[index].showNickName}",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))
                            ]),
                            controlAffinity: ListTileControlAffinity.leading)
                        : ListTile(
                            title: Row(children: [
                              AvatarRoundImage("${logic.members[index].headImage}",
                                  width: 35.r, height: 35.r, radius: 5.r, name: logic.members[index].showNickName),
                              SizedBox(width: 10.h),
                              Text("${logic.members[index].showNickName}",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))
                            ]),
                            onTap: () {
                              Get.back(result: [logic.members[index]]);
                            });
                  });
                },
                itemCount: logic.members.length)));
  }
}
