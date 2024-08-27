import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/member_entity.dart';

mixin SessionMembersMixin on BaseLogic {
  var selectUsers = RxList<MemberEntity>([]);

  var allUsers = RxList<MemberEntity>([]);

  var searchUsers = RxList<MemberEntity>([]);

  void search(String keyword) async {
    if (keywords.value == keyword) return;
    keywords.value = keyword;
    if (keywords.value.isEmpty) {
      searchUsers.value = allUsers;
    } else {
      searchUsers.value = allUsers
          .where((element) =>
              element.showNickName.toString().toUpperCase().contains(keywords.value.toUpperCase()) ||
              element.remarkNickName.toString().toUpperCase().contains(keywords.value.toUpperCase()))
          .toList();
    }
    searchUsers.refresh();
  }
}
