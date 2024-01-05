/*
 * @Author: dvlproad
 * @Date: 2023-12-18 13:40:09
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-12-18 13:50:23
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_exposure_kit/flutter_exposure_kit.dart';
import './buried_point_manager.dart';

extension ExposureExtension on Widget {
  Widget addExposureEvent({required String name, Map<String, dynamic>? param}) {
    return Exposure(
      onExpose: (DateTime exposureDateTimeStart) {
        //
      },
      onHide: (
        DateTime exposureDateTimeStart,
        DateTime exposureDateTimeEnd,
      ) {
        int duration = exposureDateTimeEnd
            .difference(exposureDateTimeStart)
            .inMilliseconds;
        Map<String, dynamic> eventAttr = {};
        eventAttr.addAll({"duration": duration});
        if (param != null) {
          eventAttr.addAll(param);
        }
        BuriedPointManager().addEvent(name, eventAttr);
      },
      child: this,
    );
  }
}
