/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:22:54
 * @Description: 
 */
import 'package:flutter/material.dart';

import '../model/exposure_model.dart';
import './exposure_mixin.dart';

/// Scrollable中仅包含一个SliverList或SliverGrid等元素时使用
/// 返回滑动中可见元素下标范围和ScrollNotification
typedef SingleScrollCallback = void Function(
    IndexRange? range, ScrollNotification scrollNotification);

class SingleExposureScrollView extends StatefulWidget {
  final SingleScrollCallback? scrollCallback;
  final ExposureReferee? exposureReferee;
  final ExposureStartCallback? exposureStartCallback;
  final ExposureEndCallback? exposureEndCallback;
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? scrollController;

  const SingleExposureScrollView({
    Key? key,
    this.scrollCallback,
    this.exposureReferee,
    this.exposureStartCallback,
    this.exposureEndCallback,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SingleExposureScrollView();
  }
}

class _SingleExposureScrollView extends State<SingleExposureScrollView>
    with ExposureMixin {
  int _firstExposureIndex = -1;
  int _lastExposureIndex = -1;
  Map<int, int> visibleMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController != null) {
        widget.scrollController!.position.didStartScroll();
        widget.scrollController!.position.didEndScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: widget.child,
    );
  }

  bool _onNotification(ScrollNotification notice) {
    final int exposureTime = DateTime.now().millisecondsSinceEpoch;

    final element = findElementByType<SliverMultiBoxAdaptorElement>(
        notice.context as Element);
    if (element != null) {
      final indexRange = visitSliverMultiBoxAdaptorElement(
        sliverMultiBoxAdaptorElement: element,
        portF: notice.metrics.pixels,
        portE: notice.metrics.pixels + notice.metrics.viewportDimension,
        axis: widget.scrollDirection,
        exposureReferee: widget.exposureReferee,
        exposureTime: exposureTime,
        parentIndex: 0,
      );
      if (indexRange != null) {
        // print('indexRange_willFullShow:${indexRange.firstIndex}-${indexRange.lastIndex}');
      }

      widget.scrollCallback?.call(indexRange, notice);
      _dispatchExposureEvent(indexRange, exposureTime);
    }
    return false;
  }

  void _dispatchExposureEvent(IndexRange? indexRange, int exposureTime) {
    if (indexRange == null) {
      return;
    }
    if (indexRange.firstIndex <= indexRange.lastIndex) {
      for (int i = indexRange.firstIndex; i <= indexRange.lastIndex; i++) {
        if (_firstExposureIndex == -1 ||
            i < _firstExposureIndex ||
            i > _lastExposureIndex) {
          ExposureStartIndex exposureModel = ExposureStartIndex(
            parentIndex: 0,
            itemIndex: i,
            startExposureTimeStamp: exposureTime,
          );
          // debugPrint('start exposure ${exposureModel.message}');
          widget.exposureStartCallback?.call(exposureModel);
          visibleMap[i] = exposureTime;
        }
      }
    }
    _dispatchExposureEnd(exposureTime,
        firstIndex: indexRange.firstIndex, lastIndex: indexRange.lastIndex);

    _firstExposureIndex = indexRange.firstIndex <= indexRange.lastIndex
        ? indexRange.firstIndex
        : -1;
    _lastExposureIndex = indexRange.lastIndex;
  }

  @override
  void dispose() {
    _dispatchExposureEnd(DateTime.now().millisecondsSinceEpoch, dispose: true);
    super.dispose();
  }

  void _dispatchExposureEnd(
    int exposureTime, {
    int firstIndex = -1,
    int lastIndex = -1,
    bool dispose = false,
  }) {
    if (_firstExposureIndex != -1)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = _firstExposureIndex; i <= _lastExposureIndex; i++) {
        if (dispose ||
            firstIndex > lastIndex ||
            i < firstIndex ||
            i > lastIndex) {
          final startTime = visibleMap.remove(i) ?? 0;
          ExposureEndIndex exposureModel = ExposureEndIndex(
            parentIndex: 0,
            itemIndex: i,
            endExposureTimeStamp: exposureTime,
            startExposureTimeStamp: startTime,
          );
          debugPrint('end exposure ${exposureModel.message}');
          widget.exposureEndCallback?.call(exposureModel);
        }
      }
  }
}
