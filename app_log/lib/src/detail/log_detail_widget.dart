import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reuse_view/flutter_reuse_view.dart';

import 'package:flutter_log_base/flutter_log_base.dart';
// import '../evvironment_header.dart';
// import '../log_change_notifiter.dart';

import './log_detail_cell.dart';

class LogDetailWidget extends StatefulWidget {
  final Color? color;
  final LogModel apiLogModel;
  final Function({
    required BuildContext context,
    int? section,
    int? row,
    required LogModel bLogModel,
  }) clickApiLogCellCallback; // apimockCell 的点击

  final void Function(List<LogModel> bLogModels)?
      onPressedCopyAll; // 点击复制所有按钮的事件
  final void Function()? onPressedClear; // 点击清空按钮的事件
  final void Function() onPressedClose; // 点击关闭按钮的事件

  LogDetailWidget({
    Key? key,
    this.color,
    required this.apiLogModel,
    required this.clickApiLogCellCallback,
    this.onPressedCopyAll,
    this.onPressedClear,
    required this.onPressedClose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogDetailWidgetState();
  }
}

class _LogDetailWidgetState extends State<LogDetailWidget> {
  ScrollController _controller = new ScrollController();
  bool _reverse = false;

  late LogModel _logModel;

  @override
  void initState() {
    super.initState();

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

    _logModel = widget.apiLogModel; // 写在这里用来临时修复外部传进来的数据改变的情况
  }

  void updateLogModel(LogModel logModel) {
    _logModel = logModel;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '成功执行 overlay 的 child 视图内部的 build 方法..._logModels的个数为${_logModels.length}');
    _logModel = widget.apiLogModel; // 写在这里用来临时修复外部传进来的数据改变的情况

    return Container(
      color: widget.color,
      child: Column(
        children: [
          Container(height: 80),
          _headerWidget,
          Expanded(child: Container(child: _pageWidget(context))),
        ],
      ),
    );
  }

  Widget get _headerWidget {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      //color: Colors.green,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  '日志系统(单击可复制)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: Center(
              child: _buildButton('关闭', onPressed: widget.onPressedClose),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required void Function() onPressed,
  }) {
    return IconButton(
      icon: Image(
        image: AssetImage(
          'assets/log_close.png',
          package: 'flutter_log_base',
        ),
        width: 34,
        height: 34,
        fit: BoxFit.scaleDown,
      ),
      onPressed: onPressed,
    );
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
              children: [],
            ),
          ),
          Expanded(child: _searchResultWidget(context)),
          Container(height: bottomHeight)
        ],
      ),
    );
  }

  Widget _searchResultWidget(BuildContext context) {
    int sectionCount = 1;

    int numOfRowInSection(section) {
      return _logModel != null ? 1 : 0;
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
        return ApiLogDetailCell(
          maxLines: 100,
          apiLogModel: _logModel,
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

            if (widget.clickApiLogCellCallback != null) {
              widget.clickApiLogCellCallback(
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
