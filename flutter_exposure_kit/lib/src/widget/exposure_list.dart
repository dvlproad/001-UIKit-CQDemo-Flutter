// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:07:16
 * @Description: 内置曝光事件的listView
 */
import 'package:flutter/material.dart';
import '../base/single_exposure_scroll_view.dart';
import '../model/exposure_model.dart';

class ExposureList extends StatelessWidget {
  ScrollController? controller;
  Axis axis;

  final SingleScrollCallback? scrollCallback;
  // final ExposureReferee exposureReferee;
  final ExposureStartCallback? exposureStartCallback;
  final ExposureEndCallback? exposureEndCallback;
  // final Widget child;
  // final Axis scrollDirection;
  // final ScrollController scrollController;

  BoxScrollView? listenList;

  ExposureList({
    Key? key,
    required this.listenList,
    this.axis = Axis.vertical,
    this.controller,
    this.scrollCallback,
    this.exposureStartCallback,
    this.exposureEndCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController? _scrollController =
        controller ?? PrimaryScrollController.of(context);

    Widget child = listenList!;

    return SingleExposureScrollView(
      scrollController: _scrollController,
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
        // return paintExtent == maxPaintExtent;
        double abs = maxPaintExtent - paintExtent;
        return abs < 1; // 避免paintExtent与maxPaintExtent有小数点误差,如204.666和204.669
      },
      child: child,
    );
  }
}
