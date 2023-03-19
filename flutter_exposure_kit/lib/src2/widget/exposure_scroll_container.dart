/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-16 23:08:16
 * @Description: 内置曝光事件的listView
 */
import 'dart:math';

import 'package:flutter/material.dart';
import '../base/scroll_detail_provider.dart';
import '../base/exposure_widget.dart';
import '../base/exposure_helper.dart';

import '../../src/model/exposure_model.dart';
import '../base/base_exposure_scroll_container.dart'
    show ChildItemContainerBuilder;

class ExposureScrollContainer extends StatefulWidget {
  final Widget Function(
          {required ChildItemContainerBuilder childItemContainerBuilder})
      childBuilder;

  // final SingleScrollCallback? scrollCallback;
  // final ExposureReferee exposureReferee;
  final ExposureStartCallback? exposureStartCallback;
  final ExposureEndCallback? exposureEndCallback;

  ExposureScrollContainer({
    Key? key,
    // required Widget child,
    // bool lazy = false,
    required this.childBuilder,
    // this.scrollCallback,
    required this.exposureStartCallback,
    required this.exposureEndCallback,
  }) : super(
          key: key,
          // child: child,
          // lazy: lazy,
        );

  @override
  State<ExposureScrollContainer> createState() =>
      _ExposureScrollContainerState();
}

class _ExposureScrollContainerState extends State<ExposureScrollContainer> {
  List<ExposureStartIndex> _exposureModels = [];

  @override
  void dispose() {
    _dispatchExposureEnd(DateTime.now().millisecondsSinceEpoch, dispose: true);
    super.dispose();
  }

  void _dispatchExposureEnd(int exposureTime, {bool dispose = false}) {
    List<String> exposureStrings = [];
    for (ExposureStartIndex item in _exposureModels) {
      exposureStrings.add(item.message);

      ExposureEndIndex exposureModel = ExposureEndIndex(
        parentIndex: item.parentIndex,
        itemIndex: item.itemIndex,
        startExposureTimeStamp: item.startExposureTimeStamp,
        endExposureTimeStamp: DateTime.now().millisecondsSinceEpoch,
      );
      _endExposure(exposureModel);
    }
    // String exposureModelsString = exposureStrings.join('\n');
    // debugPrint('现在结束曝光中的数据为:\n${exposureModelsString}');
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _itemContainer({
    required Widget child,
    required int index,
  }) {
    return Exposure(
      exposeFactor: 0,
      onExpose: (DateTime exposureDateTimeStart) {
        ExposureStartIndex exposureModel = ExposureStartIndex(
          parentIndex: 0,
          itemIndex: index,
          startExposureTimeStamp: exposureDateTimeStart.millisecondsSinceEpoch,
        );
        _beginExposure(exposureModel);
      },
      onHide: (DateTime exposureDateTimeStart, DateTime exposureDateTimeEnd) {
        _exposureModels.removeWhere((element) => element.itemIndex == index);

        // List<String> exposureStrings = [];
        // for (var item in exposureModels) {
        //   exposureStrings.add(item.message);
        // }
        // String exposureModelsString = exposureStrings.join('\n');
        // debugPrint('现在曝光中的数据为:\n${exposureModelsString}');

        ExposureEndIndex exposureModel = ExposureEndIndex(
          parentIndex: 0,
          itemIndex: index,
          startExposureTimeStamp: exposureDateTimeStart.millisecondsSinceEpoch,
          endExposureTimeStamp: exposureDateTimeEnd.millisecondsSinceEpoch,
        );

        _endExposure(exposureModel);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.childBuilder(
      childItemContainerBuilder: ({required Widget child, required int index}) {
        return _itemContainer(
          child: child,
          index: index,
        );
      },
    );
    // 注意：ScrollDetailProvider 只能包child，而不能包自身
    return ScrollDetailProvider(
      lazy: false,
      child: child,
    );
  }

  _beginExposure(ExposureStartIndex exposureModel) {
    // debugPrint('onExpose ${exposureModel.message}');

    _exposureModels.add(exposureModel);
    widget.exposureStartCallback?.call(exposureModel);
  }

  _endExposure(ExposureEndIndex exposureModel) {
    // debugPrint('end exposure ${exposureModel.message}');
    widget.exposureEndCallback?.call(exposureModel);
  }
}
