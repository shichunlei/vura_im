import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/session_db_util.dart';

class MyCreateSessionsLogic extends BaseListLogic<SessionEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<SessionEntity>> loadData() async {
    List<SessionEntity> sessions = await SessionRepository.getMyCreateSessionList();
    if (sessions.isEmpty) return [];
    asyncSessionData(sessions);
    return sessions.where((item) => !item.quit && !item.deleted).toList();
  }

  void asyncSessionData(List<SessionEntity> data) async {
    for (var item in data) {
      item.type = SessionType.group;
      await SessionRealm(realm: Get.find<RootLogic>().realm).saveChannel(item, refreshList: false);
    }
    try {
      Get.find<SessionLogic>().refreshList();
    } catch (e) {
      Log.e(e.toString());
    }
  }
}
