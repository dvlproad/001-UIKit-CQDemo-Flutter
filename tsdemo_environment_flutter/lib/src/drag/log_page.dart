import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

// import '../dev_util.dart';

class TSLogPage extends StatefulWidget {
  TSLogPage({Key key}) : super(key: key);

  @override
  _TSLogPageState createState() => new _TSLogPageState();
}

class _TSLogPageState extends State<TSLogPage> {
  List<ApiModel> apiLogModels;

  bool logOpenSelected = false;
  @override
  void initState() {
    super.initState();

    apiLogModels = [];
    for (int i = 0; i < 2; i++) {
      String name = '接口$i';
      String Url = cqtsRandomString(0, 10, CQRipeStringType.english);
      ApiModel apiLogModel = ApiModel(name: name, url: Url, mock: false);
      apiLogModels.add(apiLogModel);
      // ApiManager.tryAddApi(Url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: appBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: contentWidget(),
        ),
      ),
    );
  }

  /// 导航栏
  PreferredSize appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text('测试 Test', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 内容视图
  Widget contentWidget() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double loginIconBottom = screenHeight <= 667 ? 50 : 71;

    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: CQTSThemeStateButton(
            normalBGColorType: CQTSThemeBGType.pink,
            normalTitle: '显示全局log视图',
            selectedTitle: '关闭全局log视图',
            selected: logOpenSelected,
            onPressed: () {
              if (logOpenSelected == false) {
                ///MediaQuery.of(context).size.width  屏幕宽度
                ///MediaQuery.of(context).size.height 屏幕高度
                ApplicationDraggableManager.showLogOverlayEntry(
                  logModels: apiLogModels,
                  clickLogCellCallback: (section, row, bApiModel) {
                    print('点击${bApiModel.url}');
                  },
                  onPressedClear: () {
                    print('点击清空数据');
                    apiLogModels.clear();

                    ApplicationDraggableManager.updateLogOverlayEntry();
                  },
                );
              } else {
                ApplicationDraggableManager.dismissLogOverlayEntry(
                  onlyHideNoSetnull: true,
                );
              }

              logOpenSelected = !logOpenSelected;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CQTSThemeBGButton(
                bgColorType: CQTSThemeBGType.pink,
                title: '添加log',
                onPressed: () {
                  int i = apiLogModels.length;
                  String name = '接口$i';
                  String Url =
                      cqtsRandomString(0, 10, CQRipeStringType.english);
                  ApiModel apiLogModel =
                      ApiModel(name: name, url: Url, mock: false);
                  apiLogModels.add(apiLogModel);
                  print('添加log:$name');
                  ApplicationDraggableManager.updateLogOverlayEntry();
                  // setState(() {});
                },
              ),
              CQTSThemeBGButton(
                bgColorType: CQTSThemeBGType.pink,
                title: '清空log',
                onPressed: () {
                  print('清空log');
                  apiLogModels.clear();

                  ApplicationDraggableManager.updateLogOverlayEntry();
                  // setState(() {});
                },
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 100, left: 25, right: 25),
          child: CQTSThemeBGButton(
            bgColorType: CQTSThemeBGType.pink,
            title: '测试log视图弹出时候的透传',
            onPressed: () {
              CJTSToastUtil.showMessage('测试log视图弹出时候的透传');
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1000, left: 25, right: 25),
          child: Text('我是为了超出视图'),
        ),
      ],
    );
  }
}
