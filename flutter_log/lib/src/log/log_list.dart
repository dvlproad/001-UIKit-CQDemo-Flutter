import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show CreateSectionTableView2, IndexPath;

import './evvironment_header.dart';
import './log_cell.dart';
export './log_cell.dart' show ClickApiLogCellCallback;

import './log_change_notifiter.dart';
import './log_data_bean.dart';
export './log_data_bean.dart';

class LogList extends StatefulWidget {
  final Color? color;
  final List<LogModel> logModels;
  final ClickApiLogCellCallback clickLogCellCallback; // apimockCell 的点击

  final void Function(List<LogModel> bLogModels)
      onPressedCopyAll; // 点击复制所有按钮的事件
  final void Function() onPressedClear; // 点击清空按钮的事件

  LogList({
    Key? key,
    this.color,
    required this.logModels,
    required this.clickLogCellCallback,
    required this.onPressedCopyAll,
    required this.onPressedClear,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogListState();
  }
}

class _LogListState extends State<LogList> {
  ScrollController _controller = new ScrollController();
  bool _reverse = false;

  List<LogModel> _logModels = [];
  ApiLogChangeNotifier _environmentChangeNotifier = ApiLogChangeNotifier();

  @override
  void initState() {
    super.initState();

    print("_LogListState initState");

    // _logModels = widget.logModels ?? [];

    ///WidgetsBinding.instance.addPostFrameCallback 这个作用是界面绘制完成的监听回调  必须在绘制完成后添加OverlayEntry
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // if (_apiMockModels_selected.length > 0 ||
        //     _logModels.length > 0) {
        // Future.delayed(Duration(milliseconds: 500), () {
        //   double maxOffset = _controller.position.maxScrollExtent;
        //   maxOffset = 10000;
        //   // jumpTo(double offset)、animateTo(double offset,...)：这两个方法用于跳转到指定的位置，它们不同之处在于，后者在跳转时会执行一个动画，而前者不会。

        //   // _controller.jumpTo(maxOffset);

        //   _controller.animateTo(
        //     maxOffset, //滚动位置
        //     curve: Curves.easeOut, //动画效果
        //     duration: const Duration(milliseconds: 100), //动画时间
        //   );
        // });
        // }
      },
    );
  }

  void updateLogModels(List<LogModel> logModels) {
    _logModels = logModels;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '成功执行 overlay 的 child 视图内部的 build 方法..._logModels的个数为${_logModels.length}');
    _logModels = widget.logModels; // 写在这里用来临时修复外部传进来的数据改变的情况

    return Container(
      color: widget.color,
      child: ChangeNotifierProvider<ApiLogChangeNotifier>.value(
        value: _environmentChangeNotifier,
        child: _pageWidget(context),
      ),
    );
  }

  Widget _pageWidget(BuildContext context) {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    EdgeInsets padding = mediaQuery.padding;
    padding = padding.copyWith(bottom: mediaQuery.viewPadding.top);
    double bottomHeight = padding.top;
    // [flutter-获取刘海屏头部高度，以及没有home键时底部高度](https://www.jianshu.com/p/27603ac09b36)

    return Container(
      // constraints: BoxConstraints(
      //   minWidth: double.infinity,
      //   minHeight: double.infinity,
      // ),
      // width: mediaQuery.size.width,
      // height: mediaQuery.size.height - 300,
      child: Column(
        children: <Widget>[
          Container(
            // color: Colors.cyan,
            // height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildButton('清空', onPressed: widget.onPressedClear),
                _buildButton(
                  _reverse ? '正序' : '逆序',
                  onPressed: () {
                    setState(() {
                      _reverse = !_reverse;
                    });
                  },
                ),
                _buildButton(
                  '复制所有',
                  onPressed: () {
                    if (widget.onPressedCopyAll != null) {
                      widget.onPressedCopyAll(_logModels);
                    }
                  },
                ),
              ],
            ),
          ),
          Consumer<ApiLogChangeNotifier>(
            builder: (context, environmentChangeNotifier, child) {
              return Expanded(
                child: _searchResultWidget(context),
              );
            },
          ),
          Container(height: bottomHeight)
        ],
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required void Function() onPressed,
  }) {
    return TextButton(
      child: Container(
        color: Colors.pink,
        width: 80,
        height: 30,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _searchResultWidget(BuildContext context) {
    int sectionCount = 1;

    int numOfRowInSection(section) {
      return _logModels.length;
    }

    return CreateSectionTableView2(
      controller: _controller,
      reverse: _reverse,
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        return numOfRowInSection(section);
      },
      headerInSection: (section) {
        // return EnvironmentTableViewHeader(title: 'api log');
        return Container();
      },
      cellAtIndexPath: (section, row) {
        LogModel logModel = _logModels[row];
        return ApiLogTableViewCell(
          maxLines: 5,
          apiLogModel: logModel,
          section: section,
          row: row,
          clickApiLogCellCallback: ({
            required BuildContext context,
            int? section,
            int? row,
            required LogModel bLogModel,
          }) {
            // print('点击选中 log');
            // setState(() {}); // 请在外部执行

            if (widget.clickLogCellCallback != null) {
              widget.clickLogCellCallback(
                context: context,
                section: section,
                row: row,
                bLogModel: bLogModel,
              );
            }
          },
        );
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
