import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/widgets/state_view/empty_page.dart';
import 'package:vura/widgets/state_view/error_page.dart';
import 'package:vura/widgets/state_view/loading_widget.dart';

class BaseWidget<T extends BaseLogic> extends StatelessWidget {
  final T logic;
  final GetControllerBuilder<T> builder;
  final bool showEmpty;
  final bool showError;
  final VoidCallback? onRetry;
  final bool showLoading;
  final double? height;
  final String? emptyTip;
  final Color? bgColor;

  const BaseWidget(
      {super.key,
      required this.logic,
      required this.builder,
      this.showEmpty = true,
      this.showError = true,
      this.showLoading = true,
      this.height,
      this.onRetry,
      this.bgColor,
      this.emptyTip = "暂无数据"});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (logic.pageState.value == ViewState.loading && showLoading) {
        return LoadingWidget(height: height, bgColor: bgColor);
      }

      if (logic.pageState.value == ViewState.empty && showEmpty) {
        return EmptyPage(height: height, text: emptyTip, bgColor: bgColor);
      }

      if (logic.pageState.value == ViewState.error && showError) {
        return ErrorPage(onRetry: onRetry, height: height, bgColor: bgColor);
      }

      return builder(logic);
    });
  }
}
