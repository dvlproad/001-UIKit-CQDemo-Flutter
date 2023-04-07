/*
 * @Author: dvlproad
 * @Date: 2023-03-21 17:53:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:39:52
 * @Description: 图片+文字:图片作为背景，文字显示在图片上
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

class CQFullEmptyView extends StatelessWidget {
  final String text;
  const CQFullEmptyView({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: 446,
          child: CQPartEmptyView(text: text),
        )
      ],
    );
  }
}

class CQPartEmptyView extends StatelessWidget {
  final String text;
  CQPartEmptyView({
    Key? key,
    this.text = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CJBGImageWidget(
      backgroundImage: AssetImage(
        'assets/empty/empty_bgForText_default.png',
        package: 'flutter_effect',
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
