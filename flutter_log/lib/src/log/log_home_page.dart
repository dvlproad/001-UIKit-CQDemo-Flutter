import 'package:flutter/material.dart';
import './log_list.dart';
export './log_list.dart' show LogModel;

// log类型
enum LogType {
  all, // 所有 (LogLevel.normal + LogLevel.success + LogLevel.warning + LogLevel.error)
  success_warning_error, // 所有的请求结果(包含成功、警告、失败) (LogLevel.success + LogLevel.warning + LogLevel.error)
  warning, // 警告信息 (LogLevel.warning)
  error, // 错误日志(LogLevel.error)
}

class LogHomePage extends StatefulWidget {
  final Color color;
  final List<LogModel> logModels;
  final ClickApiLogCellCallback clickLogCellCallback; // apimockCell 的点击

  final void Function(List<LogModel> bLogModels)
      onPressedCopyAll; // 点击复制所有按钮的事件
  final void Function(LogType bLogType) onPressedClear; // 点击清空按钮的事件
  final void Function() onPressedClose; // 点击关闭按钮的事件

  LogHomePage({
    Key key,
    this.color,
    @required this.logModels,
    @required this.clickLogCellCallback,
    @required this.onPressedCopyAll,
    @required this.onPressedClear,
    @required this.onPressedClose,
  }) : super(key: key);

  @override
  _LogHomePageState createState() => _LogHomePageState();
}

// 1 实现 SingleTickerProviderStateMixin
class _LogHomePageState extends State<LogHomePage>
    with SingleTickerProviderStateMixin {
  // 2 定义 TabController 变量
  TabController _tabController;

  List<LogModel> _logModels = [];
  List<LogModel> _success_warning_error_logModels = []; // 所有的请求结果(包含成功、警告、失败)
  List<LogModel> _warningLogModels = [];
  List<LogModel> _errorLogModels = [];

  static String pageKey(LogType logType) {
    return 'apiLogPageKey_${logType.toString()}';
  }

  // 3 覆盖重写 initState，实例化 _tabController
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = new TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      print(_tabController.index);
    });

    _logModels = widget.logModels ?? [];
  }

  @override
  Widget build(BuildContext context) {
    int allCount = _logModels.length;
    _errorLogModels = [];
    _warningLogModels = [];
    _success_warning_error_logModels = [];
    for (var i = 0; i < allCount; i++) {
      LogModel logModel = _logModels[i];
      if (logModel.logLevel == LogLevel.error) {
        _errorLogModels.add(logModel);
        _success_warning_error_logModels.add(logModel);
      } else if (logModel.logLevel == LogLevel.warning) {
        _warningLogModels.add(logModel);
        _success_warning_error_logModels.add(logModel);
      } else if (logModel.logLevel == LogLevel.success) {
        _success_warning_error_logModels.add(logModel);
      } else {
        // normal(目前用于请求开始)
      }
    }

    return Container(
      child: Column(
        children: [
          _headerWidget,
          Container(height: 30, child: _tabbar),
          Expanded(child: Container(child: _tabBarView)),
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

  Widget _buildButton(String text, {void Function() onPressed}) {
    return IconButton(
      icon: Image(
        image: AssetImage(
          'assets/log_close.png',
          package: 'flutter_log',
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

  TabBar get _tabbar {
    return TabBar(
      controller: _tabController, // 4 需要配置 controller！！！
      // isScrollable: true,
      tabs: [
        tab('全部(${_logModels.length})'),
        tab('结果(${_success_warning_error_logModels.length})'),
        tab('警告(${_warningLogModels.length})'),
        tab('错误(${_errorLogModels.length})'),
      ],
    );
  }

  Tab tab(String text) {
    return Tab(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.pink,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget page(
    List<LogModel> logModels, {
    LogType logType,
  }) {
    return LogList(
      // key: pageKey(logType),
      color: Color(0xFFF2F2F2),
      logModels: logModels,
      clickLogCellCallback: widget.clickLogCellCallback,
      onPressedClear: () {
        if (widget.onPressedClear != null) {
          widget.onPressedClear(logType);
        }
      },
      onPressedCopyAll: widget.onPressedCopyAll,
    );
  }

  TabBarView get _tabBarView {
    return TabBarView(
      controller: _tabController, // 4 需要配置 controller！！！
      children: [
        page(_logModels, logType: LogType.all),
        page(_success_warning_error_logModels,
            logType: LogType.success_warning_error),
        page(_warningLogModels, logType: LogType.warning),
        page(_errorLogModels, logType: LogType.error),
      ],
    );
  }
}
