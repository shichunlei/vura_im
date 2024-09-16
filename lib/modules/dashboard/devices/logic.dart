import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/device_entity.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/utils/device_utils.dart';

class DevicesLogic extends BaseListLogic<DeviceEntity> {
  var deviceName = "".obs;
  String? deviceId;

  @override
  void onInit() {
    getDeviceName();
    initData();
    super.onInit();
  }

  void getDeviceName() async {
    deviceName.value = await DeviceUtils.getDeviceName();
    deviceId = await DeviceUtils.getDeviceId();
  }

  @override
  Future<List<DeviceEntity>> loadData() async {
    return await CommonRepository.getDeviceList();
  }

  var currentIndex = (-1).obs;

  @override
  void onCompleted(List<DeviceEntity> data) {
    if (data.isNotEmpty) {
      currentIndex.value =
          data.any((item) => item.deviceId == deviceId) ? data.indexWhere((item) => item.deviceId == deviceId) : -1;
    }
  }
}
