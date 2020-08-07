import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_all_page.dart';
import 'package:tsdemodemo_flutter/router/router.dart';

class GuideOverlayTestPage1 extends StatefulWidget {
  GuideOverlayTestPage1({Key key}) : super(key: key);

  @override
  _GuideOverlayTestPage1State createState() => _GuideOverlayTestPage1State();
}

class _GuideOverlayTestPage1State extends State<GuideOverlayTestPage1> {
  var width, height;

  GlobalKey buttonAnchorKey1 = GlobalKey();
  GlobalKey buttonAnchorKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.startAddGuideOverlay();
    });
  }

  /// 开始加载引导蒙层
  void startAddGuideOverlay() {
    GuideOverlayAllPage(
      context: context,
      finishGuideOverlayCallback: () {
        print('到此引导蒙层结束了...1');
        Navigator.pushReplacementNamed(context, Routers.reportUploadPage);
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
  }

  // 获取'喜欢'按钮的 RenderBox
  RenderBox getLikeButtonRenderBox() {
    if (buttonAnchorKey1 != null) {
      RenderBox renderBox = buttonAnchorKey1.currentContext.findRenderObject();

      Offset offset = renderBox.localToGlobal(Offset.zero);
      print('当前控件1的横坐标:' + offset.dx.toString());
      print('当前控件1的纵坐标:' + offset.dy.toString());

      return renderBox;
    } else {
      return null;
    }
  }

  // 获取'跟拍'按钮的 RenderBox
  RenderBox getPhotoButtonRenderBox() {
    if (buttonAnchorKey2 != null) {
      RenderBox renderBox = buttonAnchorKey2.currentContext.findRenderObject();

      Offset offset = renderBox.localToGlobal(Offset.zero);
      print('当前控件2的横坐标:' + offset.dx.toString());
      print('当前控件2的纵坐标:' + offset.dy.toString());
      return renderBox;
    } else {
      return null;
    }
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
      title: Text('需要获取坐标的组件位于*当前组件*中'),
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
          ConstrainedBox(
            child: Image(
              image: AssetImage(
                  'lib/commonui/cq-guide-overlay/Resources/bg_背景遮罩.png'),
              fit: BoxFit.fill,
            ),
            constraints: new BoxConstraints.expand(),
          ),
          // Image(
          //   image: AssetImage(
          //       'lib/commonui/cq-guide-overlay/Resources/bg_背景遮罩.png'),
          //   fit: BoxFit.fill,
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          // ),

          Positioned(
            right: 20,
            bottom: 280,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 56,
                  child: FlatButton(
                    key: buttonAnchorKey1,
                    onPressed: this.getLikeButtonRenderBox,
                    child: Image.asset(
                      'lib/commonui/cq-guide-overlay/Resources/pic_按钮_上.png',
                      width: 201,
                      height: 56,
                    ),
                  ),
                ),
                Text(
                  "131313",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 140,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 56,
                  child: FlatButton(
                    key: buttonAnchorKey2,
                    onPressed: this.getLikeButtonRenderBox,
                    child: Image.asset(
                      'lib/commonui/cq-guide-overlay/Resources/pic_按钮_下.png',
                      width: 201,
                      height: 56,
                    ),
                  ),
                ),
                Text(
                  "跟拍我",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
