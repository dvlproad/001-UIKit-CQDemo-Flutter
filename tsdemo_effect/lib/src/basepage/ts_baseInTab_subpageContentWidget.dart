import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class TSBasePageContentWidget extends StatefulWidget {
  TSBasePageContentWidget({Key key}) : super(key: key);

  @override
  _TSBasePageContentWidgetState createState() =>
      _TSBasePageContentWidgetState();
}

// 1 实现 SingleTickerProviderStateMixin
class _TSBasePageContentWidgetState extends State<TSBasePageContentWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Column(
        // 改为 ListView 会偏移
        children: <Widget>[
          CQTSRipeButton.tsRipeButtonIndex(1),
          CQTSRipeButton.tsRipeButtonIndex(2),
          ListTile(
            onTap: () {
              print('点击按钮1-2');
            },
            title: Text('diyigezuixin  推荐'),
          ),
        ],
      ),
    );
  }
}
