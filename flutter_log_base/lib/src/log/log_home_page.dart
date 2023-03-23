import 'package:flutter/material.dart';
import './log_list.dart';

class LogHomePage extends StatefulWidget {
  final Color? color;
  final List<LogModel> logModels;
  final ClickApiLogCellCallback clickLogCellCallback; // apimockCell 的点击

  final void Function(List<LogModel> bLogModels)
      onPressedCopyAll; // 点击复制所有按钮的事件
  final void Function(
      {required LogObjectType logType,
      required LogCategory bLogCategory}) onPressedClear; // 点击清空按钮的事件
  final void Function() onPressedClose; // 点击关闭按钮的事件

  const LogHomePage({
    Key? key,
    this.color,
    required this.logModels,
    required this.clickLogCellCallback,
    required this.onPressedCopyAll,
    required this.onPressedClear,
    required this.onPressedClose,
  }) : super(key: key);

  @override
  _LogHomePageState createState() => _LogHomePageState();
}

// 1 实现 SingleTickerProviderStateMixin
class _LogHomePageState extends State<LogHomePage>
    with SingleTickerProviderStateMixin {
  // 2 定义 TabController 变量
  late TabController _tabController;

  List<LogModel> _logModels = [];
  // ignore: non_constant_identifier_names
  List<LogModel> _success_warning_error_logModels = []; // 所有的请求结果(包含成功、警告、失败)
  List<LogModel> _warningLogModels = [];
  List<LogModel> _errorLogModels = [];
  List<LogModel> _apiBuriedPointLogModels = []; // 埋点
  List<LogModel> _routeLogModels = []; // 路由
  List<LogModel> _monitorLogModels = []; // 监控(网络类型变化等)

  /*
  static String pageKey(LogCategory logType) {
    return 'apiLogPageKey_${logType.toString()}';
  }
  */

  // 3 覆盖重写 initState，实例化 _tabController
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 7, vsync: this);

    _tabController.addListener(() {
      debugPrint("点击tabIndex:${_tabController.index}");
    });

    _logModels = widget.logModels;
  }

  @override
  Widget build(BuildContext context) {
    int allCount = _logModels.length;
    _errorLogModels = [];
    _warningLogModels = [];
    _success_warning_error_logModels = [];
    _apiBuriedPointLogModels = [];
    _routeLogModels = [];
    _monitorLogModels = [];
    for (var i = 0; i < allCount; i++) {
      LogModel logModel = _logModels[i];
      if (logModel.logType == LogObjectType.route) {
        _routeLogModels.add(logModel);
      } else if (logModel.logType == LogObjectType.monitor_network) {
        _monitorLogModels.add(logModel);
      } else if (logModel.logType == LogObjectType.api_buriedPoint) {
        _apiBuriedPointLogModels.add(logModel);
      } else {
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
    }

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          _headerWidget,
          Container(child: _tabbar),
          Expanded(child: Container(child: _tabBarView)),
        ],
      ),
    );
  }

  Widget get _headerWidget {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      //color: Colors.green,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  '日志系统(单击查看详情)',
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
              child: _buildButton(onPressed: widget.onPressedClose),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required void Function() onPressed,
  }) {
    return IconButton(
      icon: const Image(
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
  }

  TabBar get _tabbar {
    return TabBar(
      controller: _tabController, // 4 需要配置 controller！！！
      isScrollable: true,
      tabs: [
        tab('全部(${_logModels.length})'),
        tab('结果(${_success_warning_error_logModels.length})'),
        tab('警告(${_warningLogModels.length})'),
        tab('错误(${_errorLogModels.length})'),
        tab('路由(${_routeLogModels.length})'),
        tab('埋点(${_apiBuriedPointLogModels.length})'),
        tab('监控(${_monitorLogModels.length})'), // 监控(网络类型变化等)
      ],
    );
  }

  Tab tab(String text) {
    //创建随机颜色
    /*
    Color randomColor = Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
    */
    return Tab(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.pink,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TabBarView get _tabBarView {
    return TabBarView(
      controller: _tabController, // 4 需要配置 controller！！！
      children: [
        page(
          _logModels,
          logObjectType: LogObjectType.api_app,
          logCategory: LogCategory.all,
        ),
        page(
          _success_warning_error_logModels,
          logObjectType: LogObjectType.api_app,
          logCategory: LogCategory.success_warning_error,
        ),
        page(
          _warningLogModels,
          logObjectType: LogObjectType.api_app,
          logCategory: LogCategory.warning,
        ),
        page(
          _errorLogModels,
          logObjectType: LogObjectType.api_app,
          logCategory: LogCategory.error,
        ),
        page(
          _routeLogModels,
          logObjectType: LogObjectType.route,
          logCategory: LogCategory.all,
        ),
        page(
          _apiBuriedPointLogModels,
          logObjectType: LogObjectType.api_buriedPoint,
          logCategory: LogCategory.all,
        ),
        page(
          _monitorLogModels,
          logObjectType: LogObjectType.monitor_network,
          logCategory: LogCategory.all,
        ),
      ],
    );
  }

  Widget page(
    List<LogModel> logModels, {
    required LogObjectType logObjectType,
    required LogCategory logCategory,
  }) {
    return LogList(
      // key: pageKey(logType),
      color: const Color(0xFFF2F2F2),
      logModels: logModels,
      clickLogCellCallback: widget.clickLogCellCallback,
      onPressedClear: () {
        widget.onPressedClear(
          bLogCategory: logCategory,
          logType: logObjectType,
        );
      },
      onPressedCopyAll: widget.onPressedCopyAll,
    );
  }
}
