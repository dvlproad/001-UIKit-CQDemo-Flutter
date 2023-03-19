import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../model/exposure_model.dart';
import './exposure_mixin.dart';

/// Scrollable中包含多个Sliver元素时使用
/// 返回滑动中可见元素下标范围和ScrollNotification
/// 因为支持多section，所以返回的是List<IndexRange>
typedef SliverScrollCallback = void Function(
    List<IndexRange>, ScrollNotification scrollNotification);

class SliverExposureScrollView extends StatefulWidget {
  final SliverScrollCallback? scrollCallback;
  final ExposureReferee? exposureReferee;
  final ExposureStartCallback? exposureStartCallback;
  final ExposureEndCallback? exposureEndCallback;
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? scrollController;

  const SliverExposureScrollView({
    Key? key,
    this.scrollCallback,
    this.exposureReferee,
    required this.child,
    this.scrollDirection: Axis.vertical,
    this.exposureStartCallback,
    this.exposureEndCallback,
    this.scrollController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SliverExposureScrollViewState();
  }
}

class _SliverExposureScrollViewState extends State<SliverExposureScrollView>
    with ExposureMixin {
  Set<_Point> visibleSet = Set();
  Set<_Point> oldSet = Set();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController != null) {
        if (widget.scrollController!.hasClients == true) {
          widget.scrollController!.position.didStartScroll();
          widget.scrollController!.position.didEndScroll();
        } else {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            _scroll();
          });
        }
      }
    });
  }

  _scroll() {
    if (widget.scrollController != null) {
      if (widget.scrollController!.hasClients == true) {
        widget.scrollController!.position.didStartScroll();
        widget.scrollController!.position.didEndScroll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: widget.child,
      onNotification: _onNotification,
    );
  }

  bool _onNotification(ScrollNotification notice) {
    // 记录当前曝光时间，可作为开始曝光元素的曝光开始时间点和结束曝光节点的结束曝光时间点
    final int exposureTime = DateTime.now().millisecondsSinceEpoch;
    // 查找对应的Viewport节点MultiChildRenderObjectElement
    final viewPortElement = findElementByType<MultiChildRenderObjectElement>(
        notice.context! as Element);
    assert(viewPortElement != null);
    // 定义parentIndex 用于确定外层节点位置，也作为SliverList或SlierGrid的parentIndex
    int parentIndex = 0;
    final indexRanges = <IndexRange>[];
    // 保存上次完全可见的集合用于之后的结束曝光通知
    oldSet = Set.from(visibleSet);
    // 每个节点前面所有节点所占的范围，用于SliverList或SliverGrid确定
    // 自身在viewport中的可见区域
    double totalScrollExtent = 0;
    viewPortElement!.visitChildElements((itemElement) {
      assert(itemElement.renderObject is RenderSliver);
      final geometry = (itemElement.renderObject as RenderSliver).geometry;
      // 判断当前子节点时是否可见，不可见无须处理曝光
      if (geometry != null && geometry.visible) {
        if (itemElement is SliverMultiBoxAdaptorElement) {
          // SliverList和SliverGrid进行子节点曝光判断
          final indexRange = visitSliverMultiBoxAdaptorElement(
            sliverMultiBoxAdaptorElement: itemElement,
            portF: notice.metrics.pixels - totalScrollExtent,
            portE: notice.metrics.pixels -
                totalScrollExtent +
                geometry.paintExtent,
            axis: widget.scrollDirection,
            exposureReferee: widget.exposureReferee,
            exposureTime: exposureTime,
            parentIndex: parentIndex,
          );
          if (indexRange != null) {
            indexRanges.add(indexRange);
          }
          _dispatchExposureStartEventByIndexRange(indexRange, exposureTime);
        } else {
          // 单一RenderSlider直接判断外层节点是否曝光即可
          bool isExposure = widget.exposureReferee != null
              ? widget.exposureReferee!(
                  ExposureStartIndex(
                    parentIndex: parentIndex,
                    itemIndex: 0,
                    startExposureTimeStamp: exposureTime,
                  ),
                  geometry.paintExtent,
                  geometry.maxPaintExtent,
                )
              : geometry.paintExtent == geometry.maxPaintExtent;
          if (isExposure) {
            final indexRange = IndexRange(
              parentIndex: parentIndex,
              firstIndex: 0,
              lastIndex: 0,
            );
            indexRanges.add(indexRange);
            _dispatchExposureStartEvent(parentIndex, 0, exposureTime);
          }
        }
      }
      if (geometry != null) {
        totalScrollExtent += geometry.scrollExtent;
      }

      parentIndex++;
    });
    // 根据上次曝光的元素集合找出当前已不可见的元素，进行曝光结束事件通过
    _dispatchExposureEndEvent(oldSet, exposureTime);
    // 调用scrollCallback返回当前可见元素位置
    if (indexRanges != null) {
      String indexRangesString = '';
      for (IndexRange indexRange in indexRanges) {
        indexRangesString += '${indexRange.firstIndex}-${indexRange.lastIndex}';
      }
      print('indexRange_willFullShow:$indexRangesString');
    }
    widget.scrollCallback?.call(indexRanges, notice);
    return false;
  }

  void _dispatchExposureStartEventByIndexRange(
    IndexRange? indexRange,
    int exposureTime,
  ) {
    if (indexRange == null) {
      return;
    }
    if (indexRange.firstIndex > indexRange.lastIndex) {
      return;
    }
    for (int i = indexRange.firstIndex; i <= indexRange.lastIndex; i++) {
      _dispatchExposureStartEvent(indexRange.parentIndex, i, exposureTime);
    }
  }

  void _dispatchExposureStartEvent(
      int parentIndex, int itemIndex, int exposureTime) {
    final point = _Point(parentIndex, itemIndex, exposureTime);
    if (!visibleSet.contains(point)) {
      visibleSet.add(point);

      ExposureStartIndex exposureModel = ExposureStartIndex(
        parentIndex: parentIndex,
        itemIndex: itemIndex,
        startExposureTimeStamp: exposureTime,
      );
      debugPrint('start exposure ${exposureModel.message}');
      widget.exposureStartCallback?.call(exposureModel);
    } else {
      oldSet.remove(point);
    }
  }

  void _dispatchExposureEndEvent(Set<_Point> set, int exposureTime) {
    if (widget.exposureEndCallback == null) return;
    set.forEach((item) {
      ExposureEndIndex exposureModel = ExposureEndIndex(
        parentIndex: item.parentIndex,
        itemIndex: item.itemIndex,
        endExposureTimeStamp: exposureTime,
        startExposureTimeStamp: item.time,
      );
      debugPrint('end exposure ${exposureModel.message}');

      widget.exposureEndCallback!(exposureModel);
    });
    if (visibleSet == set) {
      visibleSet.clear();
    } else {
      visibleSet.removeAll(set);
    }
  }

  @override
  void dispose() {
    _dispatchExposureEndEvent(
        visibleSet, DateTime.now().millisecondsSinceEpoch);
    super.dispose();
  }
}

class _Point {
  final int parentIndex;
  final int itemIndex;
  final int time;

  _Point(this.parentIndex, this.itemIndex, this.time);

  @override
  bool operator ==(other) {
    if (other is! _Point) {
      return false;
    }
    return this.parentIndex == other.parentIndex &&
        this.itemIndex == other.itemIndex;
  }

  @override
  int get hashCode => hashValues(parentIndex, itemIndex);
}
