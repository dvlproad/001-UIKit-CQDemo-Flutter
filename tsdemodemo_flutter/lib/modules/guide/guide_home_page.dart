import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/guide/GuideOverlayEntryFactory.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_all_page.dart';

class GuidePage extends StatefulWidget {
  GuidePage({Key key}) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  var width, height;

  GlobalKey buttonAnchorKey1 = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuideOverlayEntryFactory2(
        context: context,
        getButtonAnchorKeyCallback1: () => buttonAnchorKey1,
        getRenderBoxCallback1: () {
          RenderBox renderBox =
              buttonAnchorKey1.currentContext.findRenderObject();
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
          Text(
            '文本一1',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 180,
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
          )
        ],
      ),
    );
  }
}
