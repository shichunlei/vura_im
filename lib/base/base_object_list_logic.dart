import 'package:get/get.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/log_utils.dart';

import 'base_logic.dart';

abstract class BaseObjectListLogic<T, R> extends BaseLogic {
  initData() async {
    refreshData(isFirst: true);
  }

  bool isFirstLoading = false;

  Future refreshData({bool isFirst = false}) async {
    if (isFirst) {
      pageState.value = ViewState.loading;
      isFirstLoading = true;
    }
    var res = await refreshObject();

    if (res != null) {
      easyRefreshController.finishRefresh(success: true);
      onCompleted(res);
      pageState.value = ViewState.success;
      await refreshList();
      isFirstLoading = false;
    } else {
      easyRefreshController.finishRefresh(success: false);
      if (isFirst) {
        pageState.value = ViewState.error;
      } else {
        Log.d("网络请求失败");
      }
    }
  }

  RxList<R> list = RxList<R>([]);

  Rx<T?> bean = Rx<T?>(null);

  Future<T?> refreshObject() async {
    var res = await loadObjectData();
    bean.value = res;
    easyRefreshController.resetLoadState();
    return bean.value;
  }

  var refreshState = RefreshState.none.obs;

  Future<List<R>> refreshList() async {
    refreshState.value = RefreshState.refresh;
    pageNumber.value = 1;
    offset.value = 0;
    var data = await loadListData();
    easyRefreshController.finishRefresh();
    list.clear();
    list.addAll(data);
    offset.value = list.length;
    refreshState.value = RefreshState.none;

    /// 完成加载、没有数据了
    easyRefreshController.finishLoad(success: true, noMore: data.length < pageSize.value);
    return list;
  }

  /// 上拉加载更多
  Future<List<R>> loadMore() async {
    refreshState.value = RefreshState.load;
    try {
      pageNumber.value++;
      var data = await loadListData();
      if (data.isEmpty) {
        pageNumber.value--;
        easyRefreshController.finishLoad(success: true, noMore: false);
      } else {
        list.addAll(data);
        offset.value = list.length;
        if (data.length < pageSize.value) {
          easyRefreshController.finishLoad(success: true, noMore: false);
        } else {
          easyRefreshController.finishLoad();
        }
      }
      refreshState.value = RefreshState.none;
      return data;
    } catch (e) {
      refreshState.value = RefreshState.error;
      pageNumber.value--;
      easyRefreshController.finishLoad(success: false);
      return [];
    }
  }

  Future<T?> loadObjectData();

  Future<List<R>> loadListData();

  void onCompleted(T? data) {}

  @override
  void onClose() {
    easyRefreshController.dispose();
    super.onClose();
  }
}
