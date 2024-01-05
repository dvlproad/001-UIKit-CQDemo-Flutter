/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 16:27:08
 * @Description: 内置曝光事件的listView
 */
import 'package:flutter/material.dart';
import 'package:flutter_exposure_kit/flutter_exposure_kit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExposureStaggeredGrid extends ExposureScrollContainer {
  ExposureStaggeredGrid.masonryGridViewCount({
    Key? key,
    int? itemCount,
    required IndexedWidgetBuilder itemBuilder,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    required int crossAxisCount,
    ScrollController? controller,
    Axis axis = Axis.vertical,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,

    //  SingleScrollCallback? scrollCallback,
    //  ExposureReferee exposureReferee,
    ExposureStartCallback? exposureStartCallback,
    ExposureEndCallback? exposureEndCallback,
  }) : super(
          key: key,
          childBuilder: ({
            required ChildItemContainerBuilder childItemContainerBuilder,
          }) {
            return MasonryGridView.count(
              // controller: controller,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              scrollDirection: axis,
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
          },
          exposureStartCallback: exposureStartCallback,
          exposureEndCallback: exposureEndCallback,
        );
}
