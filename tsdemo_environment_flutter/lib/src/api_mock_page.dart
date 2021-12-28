import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

class TSApiMockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TSApiMockPageState();
  }
}

class _TSApiMockPageState extends State<TSApiMockPage> {
  @override
  void initState() {
    super.initState();
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
    return ApiMockPageContent();
  }
}
