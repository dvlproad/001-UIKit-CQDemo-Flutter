import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:provider/provider.dart';

import '../log_cell.dart';
import '../log_change_notifiter.dart';
import '../../bean/log_data_bean.dart';

class LogList extends StatefulWidget {
  final Color? color;
  final List<LogModel> logModels;
  final ClickApiLogCellCallback clickLogCellCallback; // apimockCell 的点击

  final void Function(List<LogModel> bLogModels)
      onPressedCopyAll; // 点击复制所有按钮的事件
  final void Function() onPressedClear; // 点击清空按钮的事件

  const LogList({
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
  late List<LogModel> _logModels;
  final ApiLogChangeNotifier _environmentChangeNotifier =
      ApiLogChangeNotifier();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _logModels = widget.logModels;

    debugPrint("_LogListState initState");

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

  @override
  void didUpdateWidget(LogList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logModels.length != widget.logModels.length) {
      _logModels = widget.logModels;
      _handleSearchTextChanged(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '成功执行 overlay 的 child 视图内部的 build 方法..._logModels的个数为${_logModels.length}');

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

    // ignore: avoid_unnecessary_containers
    return Container(
      // constraints: BoxConstraints(
      //   minWidth: double.infinity,
      //   minHeight: double.infinity,
      // ),
      // width: mediaQuery.size.width,
      // height: mediaQuery.size.height - 300,
      child: Column(
        children: <Widget>[
          // ignore: avoid_unnecessary_containers
          Container(
            // color: Colors.cyan,
            // height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: TextField(
                      controller: _controller,
                      // focusNode: _focusNode,
                      autofocus: false,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '搜索',
                        hintStyle: TextStyle(fontSize: 16),
                        isDense: true,
                      ),
                      onChanged: (String value) {
                        _handleSearchTextChanged(value);
                        // _environmentChangeNotifier.searchText = value;
                      },
                    ),
                  ),
                ),
                _buildButton('清空', onPressed: () {
                  _logModels = [];
                  widget.onPressedClear();
                }),
                // _buildButton(
                //   _reverse ? '正序' : '逆序',
                //   onPressed: () {
                //     setState(() {
                //       _reverse = !_reverse;
                //     });
                //   },
                // ),
                // _buildButton(
                //   '复制所有',
                //   onPressed: () {
                //     widget.onPressedCopyAll(_logModels);
                //   },
                // ),
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
            style: const TextStyle(
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
    var length = _logModels.toList().length;
    return SectionTableView(
      // controller: _controller,
      // reverse: _reverse,
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        return length;
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

            widget.clickLogCellCallback(
              context: context,
              section: section,
              row: row,
              bLogModel: bLogModel,
            );
          },
        );
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }

  void _handleSearchTextChanged(String value) {
    if (value.isEmpty) {
      _logModels = widget.logModels;
      setState(() {});
      return;
    }
    var list = _logModels
        .toList()
        .where((element) => element.shortMap.values
            .join()
            .toLowerCase()
            .contains(value.toLowerCase()))
        .toList();
    _logModels = list;
    setState(() {});
  }
}
