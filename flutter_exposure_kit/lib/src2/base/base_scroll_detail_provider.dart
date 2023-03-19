/*
 * @Author: dvlproad
 * @Date: 2022-06-01 18:40:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-16 22:04:10
 * @Description: 
 */
import 'package:flutter/material.dart';
import './scroll_notification_publisher.dart';

abstract class BaseScrollDetailProvider extends StatefulWidget {
  const BaseScrollDetailProvider({
    Key? key,
    this.child,
    this.notificationChildBuilder,
    this.lazy = false,
  }) : super(key: key);

  final Widget? child;
  final Widget Function()? notificationChildBuilder;
  final bool lazy;

  // @override
  // BaseScrollDetailProviderState createState() => BaseScrollDetailProviderState();
}

abstract class BaseScrollDetailProviderState<V extends BaseScrollDetailProvider>
    extends State<V> with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollNotificationPublisher(
      child: Builder(builder: (context) {
        postStartPosition(context);
        return buildNotificationWidget(context, notificationChild);
      }),
    );
  }

  Widget get notificationChild {
    if (widget.child != null) {
      return widget.child!;
    }
    return widget.notificationChildBuilder!();
  }

  Widget buildNotificationWidget(BuildContext context, Widget child) {
    if (widget.lazy) {
      return NotificationListener<ScrollEndNotification>(
        onNotification: (scrollNotification) {
          return postNotification(scrollNotification, context);
        },
        child: child,
      );
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          return postNotification(scrollNotification, context);
        },
        child: child,
      );
    }
  }

  bool postNotification(ScrollNotification notification, BuildContext context) {
    ScrollNotificationPublisher.of(context).add(notification);
    return false;
  }

  // 首次展现需要单独发一个 Notification
  // pixels 为 0
  // 为了避免 listener 还没有监听上从而丢失第一次消息，延迟 500 ms
  void postStartPosition(BuildContext context) async {
    await Future.delayed(const Duration(microseconds: 500));
    final fakeScrollNotification = ScrollStartNotification(
      context: context,
      metrics: FixedScrollMetrics(
        minScrollExtent: 0.0,
        maxScrollExtent: 0.0,
        pixels: 0.0,
        viewportDimension: 0.0,
        axisDirection: AxisDirection.down,
      ),
    );
    ScrollNotificationPublisher.of(context).add(fakeScrollNotification);
  }

  @override
  bool get wantKeepAlive => true;
}
