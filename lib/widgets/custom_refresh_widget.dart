import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh_strong/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_classical_footer.dart';
import 'custom_sticky_header_delegate.dart';

class CustomRefreshWidget extends StatelessWidget {
  final EasyRefreshController? controller;
  final OnRefreshCallback? onRefresh;
  final OnRefreshCallback? onLoad;
  final ScrollController? scrollController;
  final double titleHeight;
  final Widget? headerWidget;
  final Widget? footerWidget;
  final IndexedWidgetBuilder? itemBuilder;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? slivers;
  final bool headerPinned;
  final bool headerFloating;
  final Header? refreshHeader;
  final Color? textColor;
  final bool showNoData;

  const CustomRefreshWidget(
      {super.key,
      required this.controller,
      this.onRefresh,
      this.onLoad,
      this.scrollController,
      this.titleHeight = 0,
      this.headerWidget,
      this.footerWidget,
      this.itemBuilder,
      this.itemCount = 0,
      this.padding,
      this.slivers,
      this.refreshHeader,
      this.headerPinned = false,
      this.headerFloating = true,
      this.textColor,
      this.showNoData = true});

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
        enableControlFinishRefresh: onRefresh != null,
        enableControlFinishLoad: onLoad != null,
        controller: controller,
        scrollController: scrollController,
        header: refreshHeader ??
            ClassicalHeader(
                enableInfiniteRefresh: false,
                refreshText: "下拉刷新",
                refreshReadyText: "释放刷新",
                refreshingText: "正在刷新中...",
                refreshedText: "刷新完成",
                refreshFailedText: "刷新失败",
                noMoreText: "我是有底线的",
                showInfo: false,
                enableHapticFeedback: false,
                textColor: textColor ?? Theme.of(context).textTheme.bodyMedium!.color!),
        footer: CustomClassicalFooter(
            enableHapticFeedback: false, textColor: textColor ?? Theme.of(context).textTheme.bodyMedium!.color!),
        onRefresh: onRefresh?.call,
        onLoad: onLoad?.call,
        slivers: slivers ??
            [
              SliverPersistentHeader(
                  pinned: headerPinned,
                  floating: headerFloating,
                  delegate: CustomSliverPersistentHeaderDelegate(
                      height: titleHeight, child: headerWidget ?? const SizedBox())),
              SliverPadding(
                  padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate(itemBuilder!, childCount: itemCount))),
              SliverToBoxAdapter(child: footerWidget)
            ]);
  }
}

class OnlyRefreshWidget extends StatelessWidget {
  final EasyRefreshController controller;
  final OnRefreshCallback onRefresh;
  final Header? header;
  final Widget child;

  const OnlyRefreshWidget(
      {super.key, required this.controller, required this.onRefresh, required this.child, this.header});

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        enableControlFinishLoad: false,
        controller: controller,
        header: header ??
            ClassicalHeader(
                enableInfiniteRefresh: false,
                refreshText: "下拉刷新",
                refreshReadyText: "释放刷新",
                refreshingText: "正在刷新中...",
                refreshedText: "刷新完成",
                refreshFailedText: "刷新失败",
                noMoreText: "我是有底线的",
                showInfo: false,
                textColor: Theme.of(context).textTheme.bodyMedium!.color!),
        child: child,
        onRefresh: () async => await onRefresh());
  }
}
