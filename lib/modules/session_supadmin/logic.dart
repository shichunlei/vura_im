import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/session_repository.dart';

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
