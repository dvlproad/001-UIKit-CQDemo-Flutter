import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay2/guide_overlay_all_page.dart';

class GuideOverlayTestPage5 extends StatefulWidget {
  GuideOverlayTestPage5({Key key}) : super(key: key);

  @override
  _GuideOverlayTestPage5State createState() => _GuideOverlayTestPage5State();
}

class _GuideOverlayTestPage5State extends State<GuideOverlayTestPage5> {
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
                  this.getLikeButtonRenderBox();
                },
                child: Text('获取当前坐标1'),
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
                  this.getPhotoButtonRenderBox();
                },
                child: Text('获取当前坐标2'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
