import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_routes.dart';

class TSArcHomePage extends CJTSBasePage {
  final String title;

  TSArcHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSArcHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? '设计模式首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Provider 的使用方式",
        'values': [
          {
            'title': "Provider 的使用方式综合(正确+错误)",
            'nextPageName': ArcRouters.arcProviderUsePage1,
          },
          {
            'title': "Provider为局部变量：取值与设置均使用Provider.of<T>(context)",
            'nextPageName': ArcRouters.arcProviderUsePage1,
          },
          {
            'title': "Provider为全局变量：取值可直接使用全局变量，但设置使用Provider.of<T>(context)",
            'nextPageName': ArcRouters.arcProviderUsePage2,
          },
          {
            'title': "Provider为全局变量：取值可直接使用全局变量，但设置使用Consumer",
            'nextPageName': ArcRouters.arcProviderUsePage3,
          },
          {
            'title': "Provider 测试 Consumer2 中 互相更新会不会导致死循环",
            'nextPageName': ArcRouters.arcProviderUsePage4,
          },
        ]
      },
      {
        'theme': "数据通信模块",
        'values': [
          {
            'title': "SetState 正常设计模式",
            'nextPageName': ArcRouters.arc0SetStatePage,
          },
          {
            'title': "Provider 设计模式（不跨页面，待验证）",
            'nextPageName': ArcRouters.arc1ProviderPage,
          },
          {
            'title': "Provider 设计模式2",
            'nextPageName': ArcRouters.arc1ProviderSharePage,
          },
          // {
          //   'title': "BloC 正常设计模式",
          //   'nextPageName': ArcRouters.arc2BlockPage,
          // },
          // {
          //   'title': "BloC_Provider 正常设计模式",
          //   'nextPageName': ArcRouters.arc2BlockProviderPage,
          // },
          // {
          //   'title': "Redux 正常设计模式",
          //   'nextPageName': ArcRouters.arc3ReduxPage,
          // },
        ]
      },
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: CJTSSectionTableView(
            context: context,
            sectionModels: sectionModels,
          ),
        ),
      ],
    );
  }
}
