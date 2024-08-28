import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/session_repository.dart';

class SessionMembersLogic extends BaseListLogic<MemberEntity> {
  String? id;
  late String title;
  late SelectType selectType;
  late bool includeMe;
  int? maxCount;
  late List<String?> selectIds;

  SessionMembersLogic() {
    id = Get.arguments[Keys.ID];
    title = Get.arguments[Keys.TITLE];
    selectType = Get.arguments["selectType"] ?? SelectType.none;
    includeMe = Get.arguments["includeMe"] ?? true;
    selectIds = Get.arguments?["selectIds"] ?? [];
    maxCount = Get.arguments?["maxCount"];
  }

  RxList<MemberEntity> selectMembers = RxList<MemberEntity>([]);

  var selectUser = Rx<MemberEntity?>(null);

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<MemberEntity>> loadData() async {
    return await SessionRepository.getSessionMembers(id);
  }

  @override
  void onCompleted(List<MemberEntity> data) {
    list.removeWhere((item) => item.userId == Get.find<RootLogic>().user.value?.id);
    list.refresh();
  }
}
