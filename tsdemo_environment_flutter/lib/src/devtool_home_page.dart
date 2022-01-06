import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_network/flutter_network.dart';
import './devtool_routes.dart';

import './main_init/main_init.dart';

class TSDevToolHomePage extends CJTSBasePage {
  final String title;

  TSDevToolHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSDevToolHomePage> {
  var sectionModels = [];

  @override
  void initState() {
    super.initState();

    Main_Init.init(); // 初始化数据，正式项目中放在main.dart中处理
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Dev Tool 首页'),
    );
  }

  @override
  Widget contentWidget() {
    // }

    // @override
    // void initState() {
    //   super.initState();

    sectionModels = [
      {
        'theme': "Dev Tool(调试工具)",
        'values': [
          {
            'title': "Environment(环境)",
            'actionBlock': () {
              _goChangeEnvironment(true);
            },
          },
          {
            'title': "ApiMock(模拟)",
            // 'nextPageName': DevToolRouters.apiMockPage,
            'actionBlock': () {
              _goChangeApiMock(true);
            },
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }

  void _goChangeEnvironment(bool showTestApiWidget) {
    EnvironmentUtil.goChangeEnvironment(
      context,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              print('测试切换环境后，网络请求的情况');
              // 我的收货地址
              // Api.getAddressList(
              //     {"accountId": UserInfoManager.instance.userModel.id});
              // HttpManager.getInstance().post(
              //   'user/account/getConsigneeAddresses',
              //   params: {"accountId": UserInfoManager.instance.userModel.id},
              // );
            }
          : null,
      updateNetworkCallback: (apiHost, webHost, gameHost) {
        NetworkChangeUtil.changeOptions(baseUrl: apiHost);
      },
      updateProxyCallback: (proxyIp) {
        NetworkChangeUtil.changeProxy(proxyIp);
      },
    );
  }

  Widget _goChangeApiMock(bool showTestApiWidget) {
    EnvironmentUtil.goChangeApiMock(
      context,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              print('测试 mock api 后，网络请求的情况');
              // 我的收货地址
              // Api.getAddressList(
              //     {"accountId": UserInfoManager.instance.userModel.id});
            }
          : null,
    );
  }
}
