/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-05-17 14:08:35
 * @Description: 
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../model/exposure_model.dart';

mixin ExposureMixin {
  IndexRange? visitSliverMultiBoxAdaptorElement({
    SliverMultiBoxAdaptorElement? sliverMultiBoxAdaptorElement,
    required double portF,
    required double portE,
    required Axis axis,
    ExposureReferee? exposureReferee,
    required int exposureTime,
    required int parentIndex,
  }) {
    if (sliverMultiBoxAdaptorElement == null) {
      return null;
    }
    int firstIndex = sliverMultiBoxAdaptorElement.childCount;
    int endIndex = -1;
    void onVisitChildren(Element element) {
      final SliverMultiBoxAdaptorParentData? parentData =
          element.renderObject?.parentData as SliverMultiBoxAdaptorParentData?;
      if (parentData != null) {
        double boundF = parentData.layoutOffset ?? 0;
        double itemLength = axis == Axis.vertical
            ? element.renderObject!.paintBounds.height
            : element.renderObject!.paintBounds.width;
        double boundE = itemLength + boundF;
        double paintExtent = max(min(boundE, portE) - max(boundF, portF), 0);
        double maxPaintExtent = itemLength;
        bool isExposure = exposureReferee != null && parentData.index != null
            ? exposureReferee(
                ExposureStartIndex(
                  parentIndex: parentIndex,
                  itemIndex: parentData.index!,
                  startExposureTimeStamp: exposureTime,
                ),
                paintExtent,
                maxPaintExtent,
              )
            : paintExtent == maxPaintExtent;

        if (isExposure) {
          firstIndex = min(firstIndex, parentData.index ?? -1);

          endIndex = max(endIndex, parentData.index ?? -1);
        }
      }
    }

    sliverMultiBoxAdaptorElement.visitChildren(onVisitChildren);

    if (firstIndex > endIndex) {
      // 整个页面都没有一个完全展示的视图的时候，会是此情况
      return null;
    }
    return IndexRange(
      parentIndex: parentIndex,
      firstIndex: firstIndex,
      lastIndex: endIndex,
    );
  }

  T? findElementByType<T extends Element>(Element element) {
    if (element is T) {
      return element;
    }
    T? target;
    element.visitChildElements((child) {
      target ??= findElementByType<T>(child);
    });
    return target;
  }
}
