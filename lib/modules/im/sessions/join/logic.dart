import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/repository/session_repository.dart';

class MyJoinSessionsLogic extends BaseListLogic<SessionEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<SessionEntity>> loadData() async {
    return await SessionRepository.getMyJoinSessionList();
  }
}
