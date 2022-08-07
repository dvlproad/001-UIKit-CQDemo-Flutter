/*
 * @Author: dvlproad
 * @Date: 2022-04-13 19:32:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-22 16:48:55
 * @Description: 可对child进行下拉刷新/上拉加载的视图
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './refresh_header_gif.dart';
import './refresh_footer_gif.dart';

class AppRefreshContainer extends StatelessWidget {
  /// Refresh Content
  ///
  /// notice that: If child is  extends ScrollView,It will help you get the internal slivers and add footer and header in it.
  /// else it will put child into SliverToBoxAdapter and add footer and header
  final Widget? child;

  // This bool will affect whether or not to have the function of drop-up load.
  final bool enablePullUp;

  /// This bool will affect whether or not to have the function of drop-down refresh.
  final bool enablePullDown;

  /// callback when header refresh
  ///
  /// when the callback is happening,you should use [RefreshController]
  /// to end refreshing state,else it will keep refreshing state
  final VoidCallback? onRefresh;

  /// callback when footer loading more data
  ///
  /// when the callback is happening,you should use [RefreshController]
  /// to end loading state,else it will keep loading state
  final VoidCallback? onLoading;

  /// Controll inner state
  final AppRefreshController controller;

  AppRefreshContainer({
    Key? key,
    this.child,
    this.enablePullDown = true,
    this.enablePullUp = false,
    required this.controller,
    this.onRefresh,
    this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: RefreshHeaderGif(),
      footer: RefreshFooterGif(),
      controller: controller._refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

class AppRefreshController {
  late RefreshController _refreshController;

  /// initialRefresh:When SmartRefresher is init,it will call requestRefresh at once
  ///
  /// initialRefreshStatus: headerMode default value
  ///
  /// initialLoadStatus: footerMode default value
  AppRefreshController({initialRefresh: false}) {
    _refreshController = RefreshController(initialRefresh: initialRefresh);
  }

  /// request complete,the header will enter complete state,
  ///
  /// resetFooterState : it will set the footer state from noData to idle
  void refreshCompleted({bool resetFooterState: false}) {
    if (_refreshController == null) {
      print('Error:友情提示请先执行初始化动作');
      return;
    }
    _refreshController.refreshCompleted(resetFooterState: resetFooterState);
  }

  /// after data returned,set the footer state to idle
  void loadComplete() {
    if (_refreshController == null) {
      print('Error:友情提示请先执行初始化动作');
      return;
    }
    _refreshController.loadComplete();
  }

  /// load more success without error,but no data returned
  void loadNoData() {
    if (_refreshController == null) {
      print('Error:友情提示请先执行初始化动作');
      return;
    }
    _refreshController.loadNoData();
  }
}
