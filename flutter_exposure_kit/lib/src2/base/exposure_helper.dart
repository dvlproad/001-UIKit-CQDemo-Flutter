/*
 * @Author: dvlproad
 * @Date: 2022-06-01 18:40:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:12:12
 * @Description: 
 */
import 'package:flutter/material.dart';
import './exposure_widget.dart';

import '../../src/model/exposure_model.dart';

// 控制曝光
class ExposureHelper {
  static Widget itemBuilder(
    BuildContext context,
    int index, {
    ExposureStartCallback? exposureStartCallback,
    ExposureEndCallback? exposureEndCallback,
  }) {
    return Exposure(
      exposeFactor: 0,
      onExpose: (DateTime exposureDateTimeStart) {
        ExposureStartIndex exposureModel = ExposureStartIndex(
          parentIndex: 0,
          itemIndex: index,
          startExposureTimeStamp: exposureDateTimeStart.millisecondsSinceEpoch,
        );
        debugPrint('onExpose ${exposureModel.message}');
        exposureStartCallback?.call(exposureModel);
      },
      onHide: (DateTime exposureDateTimeStart, DateTime exposureDateTimeEnd) {
        ExposureEndIndex exposureModel = ExposureEndIndex(
          parentIndex: 0,
          itemIndex: index,
          startExposureTimeStamp: exposureDateTimeStart.millisecondsSinceEpoch,
          endExposureTimeStamp: exposureDateTimeEnd.millisecondsSinceEpoch,
        );
        debugPrint('end exposure ${exposureModel.message}');
        exposureEndCallback?.call(exposureModel);
      },
      child: itemBuilder(context, index),
    );
  }
}
