import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_all_page.dart';

class GuidePage extends StatefulWidget {
  GuidePage({Key key}) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  var width, height;

  GlobalKey buttonAnchorKey1 = GlobalKey();
  GlobalKey buttonAnchorKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuideOverlayAllPage(
        context: context,
        finishGuideOverlayCallback: () {
          print('到此引导蒙层结束了');
        },
        getOverlayPage6RenderBoxCallback1: () {
          RenderBox renderBox =
              buttonAnchorKey1.currentContext.findRenderObject();
          return renderBox;
        },
        getOverlayPage6RenderBoxCallback2: () {
          RenderBox renderBox =
              buttonAnchorKey2.currentContext.findRenderObject();
          return renderBox;
        },
      ).addGuideOverlayEntrys();
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: _appBar(),
      body: _pageWidget(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('引导模块'),
    );
  }

  Widget _pageWidget() {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      color: Colors.red,
      child: Stack(
        children: <Widget>[
          Container(
            height: 56,
            child: Text(
              '文本一1',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 280,
            child: Container(
              height: 56,
              child: FlatButton(
                key: buttonAnchorKey1,
                color: Colors.green,
                textColor: Colors.yellow,
                onPressed: () {
                  RenderBox renderBox =
                      buttonAnchorKey1.currentContext.findRenderObject();
                  Offset offset = renderBox.localToGlobal(Offset.zero);
                  print('当前控件的横坐标:' + offset.dx.toString());
                  print('当前控件的纵坐标:' + offset.dy.toString());
                },
                child: Text('获取当前坐标'),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 140,
            child: Container(
              height: 56,
              child: FlatButton(
                key: buttonAnchorKey2,
                color: Colors.green,
                textColor: Colors.yellow,
                onPressed: () {
                  RenderBox renderBox =
                      buttonAnchorKey2.currentContext.findRenderObject();
                  Offset offset = renderBox.localToGlobal(Offset.zero);
                  print('当前控件的横坐标:' + offset.dx.toString());
                  print('当前控件的纵坐标:' + offset.dy.toString());
                },
                child: Text('获取当前坐标'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
