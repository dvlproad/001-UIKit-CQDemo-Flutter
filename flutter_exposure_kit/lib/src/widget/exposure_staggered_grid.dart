// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:13:31
 * @Description: 内置曝光事件的listView
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../base/single_exposure_scroll_view.dart';
import '../model/exposure_model.dart';

class ExposureStaggeredGrid extends StatelessWidget {
  final int? itemCount;
  final IndexedWidgetBuilder itemBuilder;
  // final IndexedStaggeredTileBuilder staggeredTileBuilder;

  final ScrollController? controller;
  final Axis axis;

  ScrollPhysics? physics;
  final SingleScrollCallback? scrollCallback;
  // final ExposureReferee exposureReferee;
  final ExposureStartCallback? exposureStartCallback;
  final ExposureEndCallback? exposureEndCallback;
  // final Widget child;
  // final Axis scrollDirection;
  // final ScrollController scrollController;

  ExposureStaggeredGrid({
    Key? key,
    this.itemCount,
    required this.itemBuilder,
    // required this.staggeredTileBuilder,
    this.controller,
    this.axis = Axis.vertical,
    this.physics,
    this.scrollCallback,
    this.exposureStartCallback,
    this.exposureEndCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController? _scrollController =
        controller ?? PrimaryScrollController.of(context);

    // Widget child = StaggeredGrid.countBuilder(
    //   controller: _scrollController,
    //   scrollDirection: axis,
    //   padding: EdgeInsets.zero,
    //   shrinkWrap: true,
    //   crossAxisCount: 4,
    //   physics: physics,
    //   mainAxisSpacing: 7,
    //   crossAxisSpacing: 3,
    //   itemCount: itemCount,
    //   itemBuilder: itemBuilder,
    //   staggeredTileBuilder: staggeredTileBuilder,
    // );

    // Widget child = GridView.custom(
    //   gridDelegate: SliverWovenGridDelegate.count(
    //     crossAxisCount: 2,
    //     mainAxisSpacing: 8,
    //     crossAxisSpacing: 8,
    //     pattern: [
    //       WovenGridTile(1),
    //       WovenGridTile(
    //         5 / 7,
    //         crossAxisRatio: 0.9,
    //         alignment: AlignmentDirectional.centerEnd,
    //       ),
    //     ],
    //   ),
    //   childrenDelegate: SliverChildBuilderDelegate(itemBuilder),
    // );
    Widget child = AlignedGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: itemBuilder,
    );

    return child;
    // ignore: dead_code
    return SingleExposureScrollView(
      scrollController: _scrollController,
      scrollDirection: axis,
      // scrollCallback: (List<IndexRange> indexRanges,
      //     ScrollNotification scrollNotification) {
      //   if (scrollCallback != null &&
      //       indexRanges != null &&
      //       indexRanges.isNotEmpty) {
      //     IndexRange _indexRange = indexRanges[0];

      //     scrollCallback!(_indexRange, scrollNotification);
      //   }
      // },
      scrollCallback: (
        IndexRange? _indexRange,
        ScrollNotification scrollNotification,
      ) {
        if (scrollCallback != null) {
          scrollCallback!(_indexRange, scrollNotification);
        }
      },
      exposureEndCallback: (ExposureEndIndex index) {
        if (exposureEndCallback != null) {
          exposureEndCallback!(index);
        }
      },
      exposureStartCallback: (ExposureStartIndex index) {
        if (exposureStartCallback != null) {
          exposureStartCallback!(index);
        }
      },
      exposureReferee: (ExposureStartIndex index, double paintExtent,
          double maxPaintExtent) {
        double abs = maxPaintExtent - paintExtent;
        return abs < 1; // 避免paintExtent与maxPaintExtent有小数点误差,如204.666和204.669
      },
      child: child,
    );
  }
}
