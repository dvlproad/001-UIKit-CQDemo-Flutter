// ignore_for_file: must_be_immutable

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 16:26:49
 * @Description: 内置曝光事件的listView
 */

import 'package:flutter/material.dart';
import 'package:flutter_exposure_kit/flutter_exposure_kit.dart';
import 'package:flutter_buried_point/flutter_buried_point.dart';

class AppExposureList extends ExposureList {
  AppExposureList.builder({
    Key? key,
    int? itemCount,
    required IndexedWidgetBuilder itemBuilder,
    Axis axis = Axis.vertical,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    bool shrinkWrap = false,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    ScrollController? controller,
    required Map<String, dynamic> Function(int itemIndex)
        exposureEventAttrGetBlock,
  }) : super(
          key: key,
          listenList: ListView.builder(
            controller: controller,
            scrollDirection: axis,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            padding: padding,
            itemExtent: itemExtent,
            shrinkWrap: shrinkWrap,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          ),
          axis: axis,
          controller: controller,
          // scrollCallback: scrollCallback,
          exposureStartCallback: (exposureModel) {},
          exposureEndCallback: (exposureModel) {
            Map<String, dynamic> eventAttr =
                exposureEventAttrGetBlock(exposureModel.itemIndex);
            BuriedPointManager().addExposureEventAttr(eventAttr);
          },
        );
}
