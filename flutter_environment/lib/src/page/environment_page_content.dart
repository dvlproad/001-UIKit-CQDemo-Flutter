import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import '../environment_manager.dart';
import '../environment_data_bean.dart';
import './environment_datas_util.dart';

import '../environment_list.dart';

import 'package:provider/provider.dart';
import '../environment_change_notifiter.dart';

class EnvironmentPageContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnvironmentPageContentState();
  }
}

class _EnvironmentPageContentState extends State<EnvironmentPageContent> {
  String networkTitle = "网络环境";
  List<TSEnvNetworkModel> _networkModels;

  String proxyTitle = "网络代理";
  List<TSEnvProxyModel> _proxyModels;

  TSEnvNetworkModel _selectedNetworkModel;
  TSEnvProxyModel _selectedProxyModel;

  @override
  void initState() {
    super.initState();

    EnvironmentManager().check().then((value) {
      print('。。。。。。。。。。22');
      _networkModels = EnvironmentManager().networkModels;
      _proxyModels = EnvironmentManager().proxyModels;
      _selectedNetworkModel = EnvironmentManager().selectedNetworkModel;
      _selectedProxyModel = EnvironmentManager().selectedProxyModel;

      setState(() {});
    }); // 设置默认的网络、代理环境
  }

  @override
  Widget build(BuildContext context) {
    return _bodyWidget;
  }

  Future<void> showLogWindow() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // await CjMonitorFlutter.showLogSuspendWindow;
    } on PlatformException {}
    if (!mounted) return;
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
            cancelText: '添加/修改代理',
            onCancel: () {
              print('添加/修改代理');

              EnvironmentAddUtil.showAddPage(
                context,
                addCompleteBlock: (bProxyId) {
                  print('proxyId =$bProxyId');
                  EnvironmentManager().addEnvProxyModel(
                    proxyIp: bProxyId,
                  );
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageWidget() {
    return TSEnvironmentList(
      networkTitle: networkTitle,
      networkModels: _networkModels,
      proxyTitle: proxyTitle,
      proxyModels: _proxyModels,
      selectedNetworkModel: _selectedNetworkModel,
      selectedProxyModel: _selectedProxyModel,
      clickEnvNetworkCellCallback: (section, row, bNetworkModel) {
        print('点击了${bNetworkModel.name}');
        _selectedNetworkModel = bNetworkModel;
        EnvironmentManager()
            .updateEnvSelectedModel(selectedNetworkModel: bNetworkModel);
        // 调用 网络域名 的更改接口
        // Service().changeOptions(baseUrl: bNetworkModel.hostName);
        setState(() {});
      },
      clickEnvProxyCellCallback: (section, row, bProxyModel) {
        print('点击了${bProxyModel.name}');
        _selectedProxyModel = bProxyModel;
        EnvironmentManager()
            .updateEnvSelectedModel(selectedProxyModel: bProxyModel);
        this.showLogWindow();
        setState(() {});
      },
    );
  }
}
