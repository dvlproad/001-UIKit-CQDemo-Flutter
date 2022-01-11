import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show CreateSectionTableView2, IndexPath;

import './evvironment_header.dart';
import './log_cell.dart';

import './log_change_notifiter.dart';
import './api_data_bean.dart';
export './api_data_bean.dart';

import 'dart:ui';

class LogList extends StatefulWidget {
  final Color color;
  final List logModels;
  final ClickApiLogCellCallback clickLogCellCallback; // apimockCell 的点击

  final void Function() onPressedClear; // 点击清空按钮的事件
  final void Function() onPressedClose; // 点击关闭按钮的事件

  LogList({
    Key key,
    this.color,
    @required this.logModels,
    @required this.clickLogCellCallback,
    @required this.onPressedClear,
    @required this.onPressedClose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogListState();
  }
}

class _LogListState extends State<LogList> {
  ScrollController _controller = new ScrollController();
  bool _reverse = false;

  List<ApiModel> _logModels = [];
  ApiLogChangeNotifier _environmentChangeNotifier = ApiLogChangeNotifier();

  @override
  void initState() {
    super.initState();

    _logModels = widget.logModels ?? [];

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
  Widget build(BuildContext context) {
    print(
        '成功执行 overlay 的 child 视图内部的 build 方法..._logModels的个数为${_logModels.length}');
    return Container(
      color: widget.color,
      child: ChangeNotifierProvider<ApiLogChangeNotifier>.value(
        value: _environmentChangeNotifier,
        child: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    return Container(
      // constraints: BoxConstraints(
      //   minWidth: double.infinity,
      //   minHeight: double.infinity,
      // ),
      width: mediaQuery.size.width,
      height: mediaQuery.size.height - 300,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildButton('清空', onPressed: widget.onPressedClear),
              _buildButton('关闭', onPressed: widget.onPressedClose),
            ],
          ),
          SizedBox(height: 6),
          Consumer<ApiLogChangeNotifier>(
            builder: (context, environmentChangeNotifier, child) {
              return Expanded(
                child: _searchResultWidget(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, {void Function() onPressed}) {
    return TextButton(
      child: Container(
        color: Colors.pink,
        width: 100,
        height: 44,
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

  Widget _searchResultWidget() {
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
        return EnvironmentTableViewHeader(title: 'api log');
      },
      cellAtIndexPath: (section, row) {
        ApiModel logModel = _logModels[row];
        return ApiLogTableViewCell(
          apiModel: logModel,
          section: section,
          row: row,
          clickApiLogCellCallback: (int section, int row, ApiModel bApiModel) {
            // print('点击选中 log');
            // setState(() {}); // 请在外部执行

            if (widget.clickLogCellCallback != null) {
              widget.clickLogCellCallback(section, row, bApiModel);
            }
          },
        );
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
