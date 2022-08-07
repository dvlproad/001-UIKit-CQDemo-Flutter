/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-16 23:40:52
 * @Description: 内置曝光事件的listView
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_exposure_kit/flutter_exposure_kit.dart';
import 'package:flutter_buried_point/flutter_buried_point.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './app_exposure_scroll_container.dart';

class AppExposureStaggeredGrid extends AppExposureScrollContainer {
  AppExposureStaggeredGrid.masonryGridViewCount({
    Key? key,
    int? itemCount,
    required IndexedWidgetBuilder itemBuilder,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    required int crossAxisCount,
    ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    required Map<String, dynamic> Function(int itemIndex)
        exposureEventAttrGetBlock,
    RefreshController? refreshController,
    Widget? header,
    Widget? footer,
    bool enablePullUp = false,
    bool enablePullDown = true,
    VoidCallback? onRefresh,
    VoidCallback? onLoading,
  }) : super(
          key: key,
          childBuilder: ({
            required ChildItemContainerBuilder childItemContainerBuilder,
          }) {
            Widget child = MasonryGridView.count(
              // controller: controller,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              scrollDirection: scrollDirection,
              shrinkWrap: shrinkWrap,
              padding: padding,
              physics: physics,
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                Widget item = itemBuilder(context, index);
                return childItemContainerBuilder(
                  child: item,
                  index: index,
                );
              },
            );

            if (refreshController != null) {
              return SmartRefresher(
                enablePullDown: enablePullDown,
                enablePullUp: enablePullUp,
                header: header,
                footer: footer,
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading,
                child: child,
              );
            }
            return child;
          },
          exposureEventAttrGetBlock: exposureEventAttrGetBlock,
        );
}
