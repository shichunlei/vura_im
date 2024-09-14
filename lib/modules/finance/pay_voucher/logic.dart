import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/rate_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/finance/wallet/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class PayVoucherLogic extends BaseObjectLogic<ImConfigBean> {
  double money = 0;

  var imagePath = Rx<String?>(null);

  PayVoucherLogic() {
    money = Get.arguments["money"] ?? 0;
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<ImConfigBean> loadData() async {
    List<ImConfigEntity> list = await CommonRepository.getImConfig();
    return ImConfigBean(
        address: list.firstWhere((item) => item.type == 1).value,
        qrCode: list.firstWhere((item) => item.type == 2).value);
  }

  String? imageUrl;

  Future uploadImage() async {
    showLoading();
    ImageEntity? file = await CommonRepository.uploadImage(imagePath.value!);
    hiddenLoading();
    if (file != null) imageUrl = file.originUrl;
  }

  Future recharge(String password) async {
    if (imageUrl == null) await uploadImage();
    showLoading();
    BaseBean result = await CommonRepository.withdraw(
        type: BookType.RECHARGE,
        money: money,
        account: Get.find<RootLogic>().user.value?.walletCard,
        remarks: "充值",
        payPassword: password,
        evidenceUrl: imageUrl,
        payAddress: "");
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "充值申请已提交");
      try {
        Get.find<WalletLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
      Get.until((route) => route.settings.name == RoutePath.WALLET_PAGE);
    }
  }
}

class ImConfigBean {
  String? address;
  String? qrCode;

  ImConfigBean({this.address, this.qrCode});
}
