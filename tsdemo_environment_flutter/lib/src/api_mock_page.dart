import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import './environment_datas_util.dart';

import 'dart:math';

class TSApiMockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TSApiMockPageState();
  }
}

class _TSApiMockPageState extends State<TSApiMockPage> {
  List<ApiModel> _apiModels;

  @override
  void initState() {
    super.initState();

    _apiModels = ApiManager().apiModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _bodyWidget,
    );
  }

  Future<void> showLogWindow() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // await CjMonitorFlutter.showLogSuspendWindow;
    } on PlatformException {}
    if (!mounted) return;
  }

  Widget _appBar() {
    return AppBar(
      title: Text('切换Mock'),
    );
  }

  Widget get _bodyWidget {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Expanded(
            child: _pageWidget(),
          ),
          BottomButtonsWidget(
            cancelText: '移除所有mock',
            onCancel: () {
              print('移除所有mock');

              ApiManager.tryAddApi(getRandomString(10));
              print('添加后的api个数:${ApiManager().apiModels.length}');
              setState(() {});
              // EnvironmentAddUtil.showAddPage(
              //   context,
              //   addCompleteBlock: (bProxyId) {
              //     print('proxyId =$bProxyId');
              //     EnvironmentManager().addEnvProxyModel(
              //       proxyIp: bProxyId,
              //     );
              //     setState(() {});
              //   },
              // );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageWidget() {
    if (_apiModels == null) {
      return Container();
    }
    return TSApiList(
      apiMockModels: _apiModels,
      clickApiMockCellCallback: (section, row, bNetworkModel) {
        print('点击了${bNetworkModel.name}');
        // EnvironmentManager()
        //     .updateEnvSelectedModel(selectedNetworkModel: bNetworkModel);
        // 调用 网络域名 的更改接口
        // Service().changeOptions(baseUrl: bNetworkModel.hostName);
      },
      // clickEnvProxyCellCallback: (section, row, bProxyModel) {
      //   print('点击了${bProxyModel.name}');
      //   // EnvironmentManager()
      //   //     .updateEnvSelectedModel(selectedProxyModel: bProxyModel);
      //   this.showLogWindow();
      // },
    );
  }
}

// 需要 import 'dart:math';
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
