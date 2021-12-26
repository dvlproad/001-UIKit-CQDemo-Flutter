import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'; // 为了取button

/*
 * 有间隔的'取消'+'确定' Buttons
 */
class AlertdCancelOKSpacedButtons extends StatelessWidget {
  final String cancelTitle;
  final Function cancelHandle;
  // final Void Function(Void) cancelHandle;

  final String okTitle;
  final Function okHandle;

  AlertdCancelOKSpacedButtons({
    Key key,
    this.cancelTitle = '取消',
    this.cancelHandle,
    this.okTitle = '确认',
    this.okHandle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: _row(),
          ),
        ],
      ),
    );
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ThemeBorderButton(
          width: 100,
          height: 40,
          borderColorType: ThemeBGType.pink,
          title: this.cancelTitle,
          titleStyle: ButtonBoldTextStyle(fontSize: 15.0),
          cornerRadius: 20,
          enable: true, // 不设置,默认true
          onPressed: this.cancelHandle,
        ),
        ThemeBGButton(
          width: 100,
          height: 40,
          bgColorType: ThemeBGType.pink,
          title: this.okTitle,
          titleStyle: ButtonBoldTextStyle(fontSize: 15.0),
          cornerRadius: 20,
          enable: true, // 不设置,默认true
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              if (this.okHandle != null) {
                this.okHandle();
              }
            });
          },
        ),
      ],
    );
  }
}

/*
 * '我知道了' Button
 */
class AlertIKnowSpacedButton extends StatelessWidget {
  final String iKnowTitle;
  final Function iKnowHandle;

  AlertIKnowSpacedButton({
    Key key,
    this.iKnowTitle = '我知道了',
    this.iKnowHandle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(color: Colors.grey, height: 1),
          Container(height: 50, child: _row())
        ],
      ),
    );
  }

  Widget _row() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
          // color: color,
          // shape: StadiumBorder(),
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              if (this.iKnowTitle != null) {
                this.iKnowHandle();
              }
            });
          },
          child: Text(
            this.iKnowTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: Colors.red),
          ),
        )
      ],
    );
  }
}
