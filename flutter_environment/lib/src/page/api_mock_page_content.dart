import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './actionsheet_footer.dart';
import '../apimock/apimock_list.dart';
import '../apimock/manager/api_manager.dart';
import '../apimock/manager/api_data_bean.dart';

class ApiMockPageContent extends StatefulWidget {
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
