import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../section_table_view_method2.dart';
import '../components/evvironment_header.dart';
import '../components/environment_network_cell.dart';
import './apimock_cell.dart';

import '../environment_change_notifiter.dart';
import './manager/api_data_bean.dart';

import 'dart:ui';

class LogList extends StatefulWidget {
  final List logModels;
  final ClickApiMockCellCallback clickLogCellCallback; // apimockCell 的点击

  LogList({
    Key key,
    @required this.logModels,
    @required this.clickLogCellCallback,
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
  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();

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
    return Container(
      child: ChangeNotifierProvider<EnvironmentChangeNotifier>.value(
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
      color: Colors.red.withOpacity(0.2),
      child: Column(
        children: <Widget>[
          SizedBox(height: 6),
          Consumer<EnvironmentChangeNotifier>(
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
        return ApiMockTableViewCell(
          apiModel: logModel,
          section: section,
          row: row,
          clickApiMockCellCallback: (int section, int row, ApiModel bApiModel) {
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
