/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 16:26:55
 * @Description: 内置曝光事件的listView
 */
import 'package:flutter/material.dart';
import 'package:flutter_exposure_kit/flutter_exposure_kit.dart';
import 'package:flutter_buried_point/flutter_buried_point.dart';

class AppExposureScrollContainer extends ExposureScrollContainerProvider {
  AppExposureScrollContainer({
    Key? key,
    required Widget Function(
            {required ChildItemContainerBuilder childItemContainerBuilder})
        childBuilder,
    required Map<String, dynamic> Function(int itemIndex)
        exposureEventAttrGetBlock,
  }) : super(
          key: key,
          childBuilder: childBuilder,
          exposureStartCallback: (exposureModel) {},
          exposureEndCallback: (exposureModel) {
            Map<String, dynamic> eventAttr =
                exposureEventAttrGetBlock(exposureModel.itemIndex);
            BuriedPointManager().addExposureEventAttr(eventAttr);
          },
        );
}
