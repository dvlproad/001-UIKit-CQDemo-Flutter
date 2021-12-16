import 'package:flutter/material.dart';
import 'dart:ui';

class PickerFooter extends StatefulWidget {
  final String cancelText;
  final void Function() onCancel;

  PickerFooter({
    Key key,
    this.cancelText,
    this.onCancel,
  }) : super(key: key);

  @override
  _PickerHeaderState createState() => _PickerHeaderState();
}

class _PickerHeaderState extends State<PickerFooter> {
  double greyGayHeight = 5; // 灰色隔离带的视图高度
  double cancelTextHeight = 40; // 取消文本所占的高度(不包含底部的视图)

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCancel,
      child: Container(
        height: getSelfViewHeight(),
        color: Colors.transparent,
        padding: EdgeInsets.only(top: 0, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: greyGayHeight, color: Color(0xFFF0F0F0)),
            _cancelWidget,
          ],
        ),
      ),
    );
  }

  /// 获取本视图的高度
  double getSelfViewHeight() {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double bottomHeight = mediaQuery.padding.bottom; //这个就是底部的高度
    // double bottomHeight = MediaQuery.of(context).padding.bottom;

    double selfviewHeight = greyGayHeight + cancelTextHeight + bottomHeight;
    return selfviewHeight;
  }

  Widget get _cancelWidget {
    return Container(
      color: Colors.transparent,
      height: cancelTextHeight,
      child: Center(
        child: Text(
          widget.cancelText ?? '取消',
          style: TextStyle(
            color: Color(0xFF999999),
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
