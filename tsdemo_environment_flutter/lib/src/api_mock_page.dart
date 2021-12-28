import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

import './actionsheet_footer.dart';

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
      actions: [
        CQTSThemeBGButton(
          title: '添加',
          onPressed: () {
            ApiManager.tryAddApi(
                cqtsRandomString(0, 10, CQRipeStringType.english));
            print('添加后的api个数:${ApiManager().apiModels.length}');
            setState(() {});
          },
        ),
      ],
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
            cancelText: '移除所有mock(暂无)',
            onCancel: () {
              print('移除所有mock(暂无)');
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
      clickApiMockCellCallback: (section, row, bApiModel) {
        print('点击了${bApiModel.name}');
      },
    );
  }
}
