import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/router/router.dart';

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
            'nextPageName': Routers.arcProviderUsePage1,
          },
          {
            'title': "Provider 的使用方式1(正确)",
            'nextPageName': Routers.arcProviderUsePage1,
          },
          {
            'title': "Provider 的使用方式2(错误)",
            'nextPageName': Routers.arcProviderUsePage2,
          },
          {
            'title': "Provider 的使用方式3(正确)",
            'nextPageName': Routers.arcProviderUsePage3,
          },
        ]
      },
      {
        'theme': "数据通信模块",
        'values': [
          {
            'title': "SetState 正常设计模式",
            'nextPageName': Routers.arc0SetStatePage,
          },
          {
            'title': "Provider 设计模式（不跨页面，待验证）",
            'nextPageName': Routers.arc1ProviderPage,
          },
          {
            'title': "Provider 设计模式2",
            'nextPageName': Routers.arc1ProviderSharePage,
          },
          // {
          //   'title': "BloC 正常设计模式",
          //   'nextPageName': Routers.arc2BlockPage,
          // },
          // {
          //   'title': "BloC_Provider 正常设计模式",
          //   'nextPageName': Routers.arc2BlockProviderPage,
          // },
          // {
          //   'title': "Redux 正常设计模式",
          //   'nextPageName': Routers.arc3ReduxPage,
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
