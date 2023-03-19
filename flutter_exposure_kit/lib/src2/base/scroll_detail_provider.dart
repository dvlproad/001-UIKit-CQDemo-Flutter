/*
 * @Author: dvlproad
 * @Date: 2022-06-01 18:40:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-16 19:49:45
 * @Description: 
 */
import 'package:flutter/material.dart';
import './scroll_notification_publisher.dart';

class ScrollDetailProvider extends StatefulWidget {
  final Widget child;
  final bool lazy;

  const ScrollDetailProvider({
    Key? key,
    required this.child,
    this.lazy = false,
  }) : super(key: key);

  @override
  _ScrollDetailProviderState createState() => _ScrollDetailProviderState();
}

class _ScrollDetailProviderState extends State<ScrollDetailProvider>
    with AutomaticKeepAliveClientMixin {
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
    return widget.child;
  }

  Widget buildNotificationWidget(BuildContext context, Widget child) {
    if (widget.lazy) {
      return NotificationListener<ScrollEndNotification>(
        onNotification: (scrollNotification) {
          return postNotification(scrollNotification, context);
        },
        child: notificationChild,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        return postNotification(scrollNotification, context);
      },
      child: child,
    );
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
    if (!mounted) return; //fix：添加愿望单商品页面 tabIndex快速切换
    ScrollNotificationPublisher.of(context).add(fakeScrollNotification);
  }

  @override
  bool get wantKeepAlive => true;
}
