import 'package:flutter/material.dart';
import './ts_widget.dart';

class TSAppBarPage extends StatefulWidget {
  TSAppBarPage({
    Key key,
  }) : super(key: key);

  @override
  _TSAppBarPageState createState() => _TSAppBarPageState();
}

class _TSAppBarPageState extends State<TSAppBarPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar(导航栏)"),
      ),
      body: Container(
        //宽高都充满屏幕剩余空间
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFF0F0F0),
        child: _buildWidget,
      ),
    );
  }

  Widget get _buildWidget {
    return Column(
      children: [
        EasyAppBarWidget(
          title: '我是有返回按钮的导航栏标题',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        EasyAppBarWidget(
          title: '我是没有返回按钮的导航栏标题',
        ),
      ],
    );
  }
}
