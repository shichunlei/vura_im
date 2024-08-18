import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/toast_util.dart';
import 'package:im/utils/websocket.dart';
import 'package:im/widgets/frame_stack.dart';

// 全局 WebSocket 实例
final WebSocketManager webSocketManager = WebSocketManager();

class HomeLogic extends BaseLogic {
  var selectedIndex = 0.obs;

  IndexController indexController = IndexController();

  HomeLogic() {
    webSocketManager.connect();
  }

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
  }

  void onItemTapped(int index) {
    if (index != selectedIndex.value) {
      selectedIndex.value = index;
      indexController.changeIndex!(index);
    }
  }

  /// 退出请求时间
  DateTime? currentBackPressTime;

  var canPop = false.obs;

  /// 返回键退出
  bool closeOnConfirm() {
    DateTime now = DateTime.now();

    /// 物理键，两次间隔大于2秒, 退出请求无效
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(text: "再按一次退出");
      return false;
    }

    /// 退出请求有效
    currentBackPressTime = null;
    return true;
  }

  void getUserInfo() async {
    UserEntity? user = await UserRepository.getUserInfo();
    if (user != null) Get.find<RootLogic>().setUserInfo(user);
  }
}
