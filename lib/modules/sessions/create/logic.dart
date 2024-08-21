import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/repository/session_repository.dart';

class MyCreateSessionsLogic extends BaseListLogic<SessionEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<SessionEntity>> loadData() async {
    return await SessionRepository.getMyCreateSessionList();
  }
}
