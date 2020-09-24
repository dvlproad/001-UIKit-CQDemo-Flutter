import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/devtool/devtool_routes.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_datas_util.dart';

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

    // 设置默认的网络、代理环境
    TSEnvironmentDataUtil().completeInternal(
      defaultNetworkId: TSEnvironmentDataUtil.mockNetworkId,
      defaultProxykId: TSEnvironmentDataUtil.noneProxykId,
    );
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
            'nextPageName': DevToolRouters.environmentPage,
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
