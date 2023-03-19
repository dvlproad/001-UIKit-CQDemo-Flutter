import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'scroll_notification_publisher.dart';

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

  StreamSubscription? _streamSubscription;

  @override
  void dispose() {
    // debugPrint("this.hashCode = ${this.hashCode}  dispose");
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // debugPrint("this.hashCode = ${this.hashCode} addPostFrameCallback");
      subscribeScrollNotification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void subscribeScrollNotification() {
    if (!mounted) return; // fix

    final StreamController<ScrollNotification> publisher =
        ScrollNotificationPublisher.of(context);
    _streamSubscription = publisher.stream.listen((scrollNotification) {
      trackWidgetPosition(
        scrollNotification.metrics.pixels,
        scrollNotification.metrics.axis,
      );
    });
  }

  void trackWidgetPosition(double scrollOffset, Axis direction) {
    // debugPrint("_ExposureState scrollOffset=$scrollOffset");
    if (!mounted) {
      return;
    }
    final exposureOffset = getExposureOffset(context);
    final exposurePitSize = (context.findRenderObject() as RenderBox).size;
    final viewPortSize = getViewPortSize(context) ?? const Size(1, 1);
    if (direction == Axis.vertical) {
      checkExposure(exposureOffset, scrollOffset, exposurePitSize.height,
          viewPortSize.height);
    } else {
      checkExposure(exposureOffset, scrollOffset, exposurePitSize.width,
          viewPortSize.width);
    }
  }

  Size? getViewPortSize(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(box);
    final Size? size = viewport?.paintBounds.size;
    return size;
  }

  double getExposureOffset(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(box);

    if (viewport == null || box == null || !box.attached) {
      return 0.0;
    }

    final RevealedOffset offsetRevealToTop =
        viewport.getOffsetToReveal(box, 0.0, rect: Rect.zero);
    return offsetRevealToTop.offset;
  }

  void initScrollState(double exposureOffset, double scrollOffset,
      double currentSize, double viewPortSize) {
    bool scrollOutEnd = (exposureOffset - scrollOffset) > viewPortSize;
    bool scrollOutStart = (scrollOffset - exposureOffset) > currentSize;
    if (scrollOutEnd) {
      state = ScrollState.outOfViewPortEnd;
    }
    if (scrollOutStart) {
      state = ScrollState.outOfViewPortStart;
    }
    state ??= ScrollState.inViewPort;
  }

  void checkExposure(double exposureOffset, double scrollOffset,
      double currentSize, double viewPortSize) {
    if (state == null) {
      initScrollState(exposureOffset, scrollOffset, currentSize, viewPortSize);
    }
    if (!show && state == ScrollState.inViewPort) {
      _onExpose();
      return;
    }

    bool scrollInEnd = (exposureOffset + currentSize * widget.exposeFactor) <
        (scrollOffset + viewPortSize);
    bool scrollInStart = scrollOffset <
        (exposureOffset + (currentSize * (1 - widget.exposeFactor)));

    bool scrollOutEnd = (exposureOffset - scrollOffset) > viewPortSize;
    bool scrollOutStart = (scrollOffset - exposureOffset) > currentSize;

    if (state == ScrollState.outOfViewPortEnd) {
      if (scrollInEnd) {
        state = ScrollState.inViewPort;
        _onExpose();
        return;
      }
    }
    if (state == ScrollState.outOfViewPortStart) {
      if (scrollInStart) {
        state = ScrollState.inViewPort;
        _onExpose();
        return;
      }
    }
    if (state == ScrollState.inViewPort) {
      if (scrollOutStart) {
        state = ScrollState.outOfViewPortStart;
        _onHide();
        return;
      }

      if (scrollOutEnd) {
        state = ScrollState.outOfViewPortEnd;

        _onHide();
        return;
      }
    }
  }

  _onExpose() {
    show = true;
    _exposeDate = DateTime.now();
    widget.onExpose.call(_exposeDate!);
  }

  _onHide() {
    // Duration duration = DateTime.now().difference(_exposeDate!);
    widget.onHide?.call(_exposeDate!, DateTime.now());
  }
}
