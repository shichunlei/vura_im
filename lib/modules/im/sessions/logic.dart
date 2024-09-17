import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/session_db_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

import 'create/logic.dart';

class SessionsLogic extends BaseLogic with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final RootLogic rootLogic = Get.find<RootLogic>(); // 获取依赖

  SessionsLogic() {
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future createSession(List<UserEntity> users) async {
    Map<String, dynamic> params = {};

    params["name"] = StringUtil.truncateString(users.map((item) => item.nickName).toList().join(","));
    params["ownerId"] = rootLogic.user.value?.id;
    params["remarkNickName"] = rootLogic.user.value?.nickName;
    params["showNickName"] = rootLogic.user.value?.nickName;
    params["showGroupName"] = "";
    params["remarkGroupName"] = "";
    params['headImage'] = "";
    params['headImageThumb'] = "";
    params['isAdmin'] = true;
    params["friendIds"] = users.map((item) => item.id).toList();

    showLoading();
    BaseBean result = await SessionRepository.createSession(params);
    hiddenLoading();

    if (result.code == 200) {
      showToast(text: "创建成功");
      loadSessionsFromNet();
      try {
        Get.find<MyCreateSessionsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  void loadSessionsFromNet() async {
    List<SessionEntity> sessions = await SessionRepository.getSessionList();
    if (sessions.isNotEmpty) {
      for (var item in sessions) {
        item.type = SessionType.group;
        await SessionRealm(realm: rootLogic.realm).saveChannel(item, refreshList: false);
      }
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }
}
