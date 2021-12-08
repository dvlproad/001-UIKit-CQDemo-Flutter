import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateErrorWidget extends StatefulWidget {
  final ImageProvider image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),

  final VoidCallback errorRetry; //错误事件处理

  StateErrorWidget({
    Key key,
    this.image,
    this.errorRetry,
  }) : super(key: key);

  @override
  _StateErrorWidgetState createState() => _StateErrorWidgetState();
}

class _StateErrorWidgetState extends State<StateErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return _errorView;
  }

  ///错误视图
  Widget get _errorView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: InkWell(
        onTap: widget.errorRetry,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: widget.image ??
                  AssetImage(
                    'assets/empty/empty_bgForText_default.png',
                    package: 'flutter_effect',
                  ),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Text(
              "加载失败，请轻触重试!",
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
