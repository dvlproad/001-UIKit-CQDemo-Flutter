import 'package:flutter/material.dart';

class TSLayoutPage extends StatefulWidget {
  TSLayoutPage({
    Key key,
  }) : super(key: key);

  @override
  _TSLayoutPageState createState() => _TSLayoutPageState();
}

class _TSLayoutPageState extends State<TSLayoutPage> {
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
      children: [_appbar1],
    );
  }

  Widget get _appbar1 {
    return Container(
      color: Colors.orange,
      width: double.infinity,
      height: 44,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.pink,
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.only(left: 80, right: 80),
                  child: Text('我是个固定居中的标题 '),
                ),
              )
            ],
          ),
          Positioned(
            left: 20,
            child: Container(
              color: Colors.purple,
              child: Text('返回 '),
            ),
          ),
        ],
      ),
    );
  }
}
