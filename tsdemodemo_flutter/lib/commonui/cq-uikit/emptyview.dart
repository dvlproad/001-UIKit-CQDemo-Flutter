import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullEmptyView extends StatelessWidget {
  final String text;
  const FullEmptyView({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: 446,
          child: PartEmptyView(text: text),
        )
      ],
    );
  }
}

class PartEmptyView extends StatelessWidget {
  final String text;
  PartEmptyView({Key key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/commonui/cq-uikit/images/pic_搜索为空页面.png'),
          // image: NetworkImage(
          //     'https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
