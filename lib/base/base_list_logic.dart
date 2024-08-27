import 'package:get/get.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/log_utils.dart';

import 'base_logic.dart';

abstract class BaseListLogic<T> extends BaseLogic {
  final RxList<T> list = RxList<T>([]);

  void clearKeywords() {
    keywords.value = '';
  }

  Future initData() async {
    pageState.value = ViewState.loading;
    await refreshData(init: true);
  }

  var refreshState = RefreshState.none.obs;

  /// 下拉刷新
  /// [init] 是否是第一次加载
  /// true:  Error时,需要跳转页面
  /// false: Error时,不需要跳转页面,直接给出提示
  Future<List<T>?> refreshData({bool init = false}) async {
    refreshState.value = RefreshState.refresh;
    try {
      easyRefreshController.resetLoadState();
      pageNumber.value = 1;
      offset.value = 0;
      var data = await loadData();
      data ??= [];
      list.clear();
      if (data.isEmpty) {
        onCompleted([]);
        pageState.value = ViewState.empty;
      } else {
        list.addAll(data);
        onCompleted(data);
        list.refresh();
        // 小于分页的数量,禁止上拉加载更多
        easyRefreshController.finishLoad(noMore: data.length < pageSize.value);
        pageState.value = ViewState.success;
      }
      easyRefreshController.finishRefresh(success: true);
      hiddenLoading();
      refreshState.value = RefreshState.none;
      return data;
    } catch (e) {
      refreshState.value = RefreshState.error;

      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      Log.e("错误$e=================");
      if (init) list.clear();
      list.refresh();
      easyRefreshController.finishRefresh(success: false);
      hiddenLoading();
      pageState.value = ViewState.error;
      return [];
    }
  }

  /// 上拉加载更多
  Future<List<T>> loadMore() async {
    refreshState.value = RefreshState.load;
    try {
      easyRefreshController.resetRefreshState();
      pageNumber.value++;
      offset.value = list.length;
      var data = await loadData();
      data ??= [];
      if (data.isEmpty) {
        pageNumber.value--;
        easyRefreshController.finishLoad(noMore: true);
      } else {
        list.addAll(data);
        list.refresh();
        onCompleted(data);
        if (data.length < pageSize.value) {
          easyRefreshController.finishLoad(noMore: true);
        } else {
          easyRefreshController.finishLoad();
        }
      }
      update();
      refreshState.value = RefreshState.none;
      return data;
    } catch (e) {
      refreshState.value = RefreshState.error;
      pageNumber.value--;
      easyRefreshController
        ..finishLoad(success: false)
        ..resetRefreshState();
      pageState.value = ViewState.error;
      return [];
    }
  }

  void loadDataBySearch({String keywords = ''}) async {
    refreshState.value = RefreshState.refresh;
    pageNumber.value = 1;
    this.keywords.value = keywords;
    showLoading();
    var data = await loadData();
    data ??= [];
    hiddenLoading();
    list.clear();
    list.addAll(data);
    list.refresh();
    refreshState.value = RefreshState.none;
  }

  /// 加载数据
  Future<List<T>?> loadData();

  void onCompleted(List<T> data) {}

  @override
  void onClose() {
    easyRefreshController.dispose();
    super.onClose();
  }
}
