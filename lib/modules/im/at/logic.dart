import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/member_entity.dart';

class SelectAtMemberLogic extends BaseLogic {
  List<MemberEntity> members = [];

  SelectAtMemberLogic(this.members);

  var selectMembers = RxList<MemberEntity>([]);

  var isCheckBox = false.obs;
}
