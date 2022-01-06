import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './actionsheet_footer.dart';
import '../apimock/apimock_list.dart';
import '../apimock/manager/api_manager.dart';
import '../apimock/manager/api_data_bean.dart';

class ApiMockPageContent extends StatefulWidget {
  final String mockApiHost;
  final String normalApiHost;
  final List<Widget> navbarActions;
  final Function() onPressTestApiCallback;

  ApiMockPageContent({
    Key key,
    this.mockApiHost, // mock 后该 api 请求的 host
    this.normalApiHost, // 正常 api 请求的 host
    this.navbarActions, // 导航栏上右侧的按钮视图及事件
    this.onPressTestApiCallback, // 为空时候，不显示视图
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ApiMockPageContentState();
  }
}

class _ApiMockPageContentState extends State<ApiMockPageContent> {
  List<ApiModel> _apiModels;

  @override
  void initState() {
    super.initState();

    _apiModels = ApiManager().apiModels;
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
      actions: widget.navbarActions,
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
          widget.onPressTestApiCallback == null
              ? Container()
              : BottomButtonsWidget(
                  cancelText: '测试请求',
                  onCancel: () {
                    print('测试请求');
                    widget.onPressTestApiCallback();
                  },
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
      mockApiHost: widget.mockApiHost,
      normalApiHost: widget.normalApiHost,
      apiMockModels: _apiModels,
      clickApiMockCellCallback: (section, row, bApiModel) {
        print('点击了${bApiModel.name}');
      },
    );
  }
}
