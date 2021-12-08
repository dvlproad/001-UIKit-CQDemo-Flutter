// 图片+文字:图片在上，文字显示在图片下边
import 'package:flutter/material.dart';

class StateNodataWidget extends StatefulWidget {
  final ImageProvider image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  final String mainTitle;
  final String subTitle;
  final Function onClick;

  const StateNodataWidget({
    Key key,
    this.image,
    this.mainTitle = '很抱歉，出错啦',
    this.subTitle = '',
    this.onClick,
  }) : super(key: key);

  @override
  _StateNodataWidgetState createState() => _StateNodataWidgetState();
}

class _StateNodataWidgetState extends State<StateNodataWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 290,
          ),
          Image(
            image: widget.image ??
                AssetImage(
                  'assets/empty/empty_aboveText_default.png',
                  package: 'flutter_effect',
                ),
            width: 300,
            fit: BoxFit.cover,
          ),
          Container(
            height: 48,
          ),
          Text(
            widget.mainTitle,
            style: TextStyle(
              color: Color(0xff9a9a9a),
              fontSize: 28,
            ),
          ),
          Container(
            height: 16,
          ),
          Text(
            widget.subTitle,
            style: TextStyle(
              color: Color(0xff9a9a9a),
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
