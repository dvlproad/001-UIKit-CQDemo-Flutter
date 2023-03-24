import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import '../proxy_page_data_manager.dart';

import '../proxy_list.dart';

// import '../environment_change_notifiter.dart';
// export '../environment_change_notifiter.dart';

// import '../environment_util.dart';

class ProxyPageContent extends StatefulWidget {
  final String currentApiHost;
  final Function()? onPressTestApiCallback;

  final Function(TSEnvProxyModel bProxyModel) updateProxyCallback;

  ProxyPageContent({
    Key? key,
    required this.currentApiHost, // 当前api请求域名
    this.onPressTestApiCallback, // 为空时候，不显示视图
    required this.updateProxyCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProxyPageContentState();
  }
}

class _ProxyPageContentState extends State<ProxyPageContent> {
  String proxyTitle = "网络代理(点击可切换,长按可修改)";
  List<TSEnvProxyModel>? _proxyModels;
  TSEnvProxyModel? _selectedProxyModel;

  late String _currentApiHost;

  @override
  void initState() {
    super.initState();

    _currentApiHost = widget.currentApiHost;

    _requesetData();
  }

  _requesetData() async {
    _proxyModels = await ProxyPageDataManager().proxyModels;
    _selectedProxyModel = ProxyPageDataManager().selectedProxyModel;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _bodyWidget,
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text('添加代理'),
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
          Text(
            '当前api环境:$_currentApiHost',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),
          ),
          Expanded(
            child: _pageWidget(),
          ),
          widget.onPressTestApiCallback == null
              ? Container()
              : BottomButtonsWidget(
                  cancelText: '测试请求',
                  onCancel: () {
                    print('测试请求');
                    widget.onPressTestApiCallback!();
                  },
                ),
          _bottomAddProxyWidget,
        ],
      ),
    );
  }

  Widget get _bottomAddProxyWidget {
    return BottomButtonsWidget(
      cancelText: '添加/修改代理',
      onCancel: () {
        print('添加/修改代理');
        _addOrUpdateCustomEnvProxyIp();
      },
    );
  }

  void _addOrUpdateCustomEnvProxyIp() {
    EnvironmentAddUtil.showAddOrUpdateProxyPage(
      context,
      proxyName: '自定义代理',
      proxyIp: null,
      addCompleteBlock: ({required String bProxyName, String? bProxyIp}) {
        print('proxyIp =$bProxyIp');
        ProxyPageDataManager().addOrUpdateCustomEnvProxyIp(
          proxyName: bProxyName,
          proxyIp: bProxyIp,
        );

        setState(() {});
      },
    );
  }

  Widget _pageWidget() {
    return ProxyList(
      proxyTitle: proxyTitle,
      proxyModels: _proxyModels ?? [],
      selectedProxyModel: _selectedProxyModel,
      clickEnvProxyCellCallback: (section, row, bProxyModel, {isLongPress}) {
        print('点击了${bProxyModel.name}');
        if (isLongPress == true) {
          if (bProxyModel.proxyId == TSEnvProxyModel.noneProxykId) {
            // 无代理不支持修改
            return;
          }
          _tryUpdateProxyModel(bProxyModel);
        } else {
          if (bProxyModel == _selectedProxyModel) {
            return;
          }
          _tryUpdateToProxyModel(bProxyModel);
        }
      },
    );
  }

  /// 尝试修改代理
  void _tryUpdateProxyModel(TSEnvProxyModel bProxyModel) {
    EnvironmentAddUtil.showAddOrUpdateProxyPage(
      context,
      proxyName: bProxyModel.name,
      proxyIp: bProxyModel.proxyIp,
      addCompleteBlock: ({required String bProxyName, String? bProxyIp}) {
        print("proxyName=$bProxyName, proxyIp =${bProxyIp ?? 'null'}");
        bProxyModel.name = bProxyName;
        bProxyModel.proxyIp = bProxyIp;
        ProxyPageDataManager().addOrUpdateEnvProxyModel(
          newProxyModel: bProxyModel,
        );

        setState(() {});
      },
    );
  }

  /// 尝试切换代理
  void _tryUpdateToProxyModel(TSEnvProxyModel bProxyModel) {
    // String oldProxy = _selectedProxyModel?.name ?? 'null';
    String newProxy = bProxyModel.name;

    String message = '';
    if (bProxyModel.proxyId == TSEnvProxyModel.noneProxykId) {
      message = '温馨提示:你将切换为不使用代理';
    } else {
      message = '温馨提示:你将切换为使用代理，请确认该代理正常，否则所有接口都将失败';
    }
    AlertUtil.showCancelOKAlert(
      context: context,
      title: '使用"$newProxy"',
      message: message,
      okHandle: () {
        _confirmUpdateToProxyModel(bProxyModel);
      },
    );
  }

  /// 确认切换代理
  void _confirmUpdateToProxyModel(TSEnvProxyModel bProxyModel) {
    _selectedProxyModel = bProxyModel;

    widget.updateProxyCallback(bProxyModel);

    setState(() {});
  }
}
