import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';

class SessionSupAdminLogic extends BaseListLogic<MemberEntity> {
  String? id;

  SessionSupAdminLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<MemberEntity>> loadData() async {
    return await SessionRepository.sessionSupAdmin(id);
  }

  Future removeSupAdmin()async{

  }
}
