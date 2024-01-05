/*
 * @Author: dvlproad
 * @Date: 2023-12-06 11:34:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:11:58
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum ScrollState {
  outOfViewPortStart,
  inViewPort,
  outOfViewPortEnd,
}

typedef OnHide = Function(
  DateTime exposureDateTimeStart,
  DateTime exposureDateTimeEnd,
);

// 控制曝光
class Exposure extends StatefulWidget {
  final void Function(DateTime exposureDateTimeStart) onExpose;
  final OnHide? onHide;
  final Widget child;
  final double exposeFactor;

  const Exposure({
    Key? key,
    required this.onExpose,
    required this.child,
    this.onHide,
    this.exposeFactor = 0.5,
  }) : super(key: key);

  @override
  State<Exposure> createState() => _ExposureState();
}

class _ExposureState extends State<Exposure> {
  bool show = false;
  ScrollState? state;
  DateTime? _exposeDate;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('exposure_$hashCode'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        var inScreen = visiblePercentage >= widget.exposeFactor;
        if (inScreen != show) {
          if (inScreen) {
            _onExpose();
          } else {
            _onHide();
          }
        }
      },
      child: widget.child,
    );
  }

  _onExpose() {
    show = true;
    _exposeDate = DateTime.now();
    widget.onExpose.call(_exposeDate!);
  }

  _onHide() {
    show = false;
    // Duration duration = DateTime.now().difference(_exposeDate!);
    widget.onHide?.call(_exposeDate!, DateTime.now());
  }
}
