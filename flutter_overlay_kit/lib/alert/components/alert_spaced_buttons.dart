import 'package:flutter/material.dart';
// import 'package:flutter_button_base/flutter_button_base.dart';
// import 'package:flutter_button_base/flutter_button_base_adapt.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'; // 为了取button
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';

/*
 * 有间隔的'取消'+'确定' Buttons
 */
class AlertdCancelOKSpacedButtons extends StatelessWidget {
  final double? height;

  final String cancelTitle;
  final ThemeStateBGType cancelStyleType;
  final void Function() cancelHandle;
  // final Void Function(Void) cancelHandle;

  final String okTitle;
  final void Function() okHandle;

  AlertdCancelOKSpacedButtons({
    Key? key,
    this.height,
    this.cancelTitle = '取消',
    this.cancelStyleType = ThemeStateBGType.theme_gray,
    required this.cancelHandle,
    this.okTitle = '确认',
    required this.okHandle,
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
    double buttonHeight = this.height ?? 36.w_pt_cj;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ThemeBorderButton(
          width: 116.w_pt_cj,
          height: buttonHeight,
          borderColorType: this.cancelStyleType,
          title: this.cancelTitle,
          titleStyle: ButtonBoldTextStyle(fontSize: 14.w_pt_cj),
          cornerRadius: 18.w_pt_cj,
          enable: true, // 不设置,默认true
          onPressed: this.cancelHandle,
        ),
        Container(width: 10.w_pt_cj),
        ThemeBGButton(
          width: 116.w_pt_cj,
          height: buttonHeight,
          bgColorType: ThemeBGType.theme,
          title: this.okTitle,
          titleStyle: ButtonBoldTextStyle(fontSize: 14.w_pt_cj),
          cornerRadius: 18.w_pt_cj,
          enable: true, // 不设置,默认true
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.okHandle();
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
    Key? key,
    this.iKnowTitle = '我知道了',
    required this.iKnowHandle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // Divider(color: Colors.grey, height: 1),
          Container(height: 40, child: _row())
        ],
      ),
    );
  }

  Widget _row() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ThemeBGButton(
          title: this.iKnowTitle,
          bgColorType: ThemeBGType.theme,
          height: 40,
          width: 240,
          cornerRadius: 20,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.iKnowHandle();
            });
          },
        ),
        // FlatButton(
        //   // color: color,
        //   // shape: StadiumBorder(),
        //   onPressed: () {
        //     Future.delayed(Duration(milliseconds: 100), () {
        //       if (this.iKnowTitle != null) {
        //         this.iKnowHandle();
        //       }
        //     });
        //   },
        //   child: Text(
        //     this.iKnowTitle,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 16.0, color: Colors.white),
        //   ),
        // )
      ],
    );
  }
}
