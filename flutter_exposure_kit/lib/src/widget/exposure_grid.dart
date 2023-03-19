/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-07 19:03:32
 * @Description: 内置曝光事件的listView
 */
import 'dart:math';

import 'package:flutter/material.dart';
import '../base/single_exposure_scrollView.dart';
import '../model/exposure_model.dart';

class ExposureGrid extends StatelessWidget {
  final SliverGridDelegate gridDelegate;
  final int? itemCount;
  final IndexedWidgetBuilder itemBuilder;

  final ScrollController? controller;
  final Axis axis;

  final SingleScrollCallback? scrollCallback;
  // final ExposureReferee exposureReferee;
  final ExposureStartCallback? exposureStartCallback;
  final ExposureEndCallback? exposureEndCallback;
  // final Widget child;
  // final Axis scrollDirection;
  // final ScrollController scrollController;

  ExposureGrid({
    Key? key,
    required this.gridDelegate,
    this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.axis = Axis.vertical,
    this.scrollCallback,
    this.exposureStartCallback,
    this.exposureEndCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController? _scrollController =
        controller ?? PrimaryScrollController.of(context);

    Widget child = GridView.builder(
      controller: _scrollController,
      scrollDirection: axis,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );

    return SingleExposureScrollView(
      scrollController: _scrollController,
      child: child,
      scrollDirection: axis,
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
    );
  }
}
