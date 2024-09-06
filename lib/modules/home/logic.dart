import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/message.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/dialog/alert_dialog.dart';
import 'package:vura/widgets/frame_stack.dart';

class HomeLogic extends BaseLogic {
  var selectedIndex = 0.obs;

  IndexController indexController = IndexController();

  var lockScreenTime = (60 * 1000).obs;
  var loginProtect = false.obs;

  Rx<int?> startTime = Rx<int?>(null);

  HomeLogic() {
    webSocketManager.listen("HomeLogic", (int cmd, Map<String, dynamic> data) {
      Log.d("HomeLogic == 》接收到消息: $cmd, 数据: $data");
      switch (cmd) {
        case 6: // {"cmd":6,"data":{"sendNickName":"煎饼果子","sendId":"1826517087758188544","sendHeadImage":"","recvId":"1826547880958230528","id":"1826549763462529024","type":900,"content":"申请添加您为好友","sendTime":1724318373933}}
          show(builder: (_) {
            return CustomAlertDialog(
                title: "提示",
                content: "${data["sendNickName"]}申请添加您为好友",
                onConfirm: () {
                  Get.toNamed(RoutePath.NEW_FRIEND_PAGE);
                },
                confirmText: "去处理");
          });
          break;
        case 5:
          break;
        case 3: // {"cmd":3,"data":{"sendNickName":"煎饼果子","sendId":"1826517087758188544","sendHeadImage":"http://39.98.127.91:9001/box-im/image/20240825/1724562459243.jpg","id":"1828641371536359424","type":902,"content":"添加好友成功","sendTime":1724817052145}}
          if (data[Keys.TYPE] == MessageType.APPLY_ADD_FRIEND_SUCCESS.code) {
            // 对方同意您的好友申请，刷新好友列表
            try {
              Get.find<ContactsLogic>().refreshData();
            } catch (e) {
              Log.e(e.toString());
            }
          }
          break;
        case 2: // {"cmd":2,"data":"您已在其他地方登陆，将被强制下线"}
          break;
        default:
          break;
      }
    }, connectCallBack: () async {
      Log.d("WebSocket 连接成功");
      String? groupLastMessageId, privateLastMessageId;
      try {
        groupLastMessageId = await MessageRealm(realm: Get.find<RootLogic>().realm).queryGroupLastMessageTime();
        privateLastMessageId = await MessageRealm(realm: Get.find<RootLogic>().realm).queryPrivateLastMessageTime();
      } catch (e) {
        Log.e(e.toString());
      }

      /// 拉取离线消息
      SessionRepository.getOfflineMessages("all",
          groupMinId: groupLastMessageId ?? "0", privateMinId: privateLastMessageId ?? "0");
    });

    lockScreenTime.value = SpUtil.getInt(Keys.LOCK_SCREEN_TIME, defValue: 60 * 1000); // 设定的锁屏间隔时间，默认为1分钟
    loginProtect.value = SpUtil.getBool(Keys.LOGIN_PROTECT, defValue: false); // 是否设置了登录保护
  }

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    /// todo
    // Future.delayed(const Duration(seconds: 2), Get.find<RootLogic>().checkVersion);
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
    if (Get.find<RootLogic>().user.value == null) {
      UserEntity? user = await UserRepository.getUserInfo();
      if (user != null) {
        Get.find<RootLogic>().setUserInfo(user);
        webSocketManager.connect();
      }
    } else {
      webSocketManager.connect();
    }
  }

  void updateLoginProtect(bool value) {
    loginProtect.value = value; // 是否设置了登录保护
  }

  void updateLockScreenTime(int time) {
    lockScreenTime.value = time; // 设定的锁屏间隔时间，默认为1分钟
  }

  @override
  void onClose() {
    webSocketManager.removeCallbacks("HomeLogic");
    super.onClose();
  }
}
