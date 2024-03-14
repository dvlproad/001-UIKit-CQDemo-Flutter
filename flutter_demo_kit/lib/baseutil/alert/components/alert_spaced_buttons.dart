import 'package:flutter/material.dart';

import '../../../flutter_demo_kit_adapt.dart';

/*
 * 有间隔的'取消'+'确定' Buttons
 */
class AlertdCancelOKSpacedButtons extends StatelessWidget {
  final double? height;

  final String cancelTitle;
  final void Function() cancelHandle;
  // final Void Function(Void) cancelHandle;

  final String okTitle;
  final void Function() okHandle;

  AlertdCancelOKSpacedButtons({
    Key? key,
    this.height,
    this.cancelTitle = '取消',
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
    double buttonHeight = this.height ?? 36.w_pt_demo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: cancelHandle,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(18.h_pt_demo),
            ),
            width: 116.w_pt_demo,
            height: buttonHeight,
            child: Text(
              cancelTitle,
              style: TextStyle(fontSize: 14.f_pt_demo),
            ),
          ),
        ),
        Container(width: 10.w_pt_demo),
        TextButton(
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.okHandle();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(18.h_pt_demo),
            ),
            width: 116.w_pt_demo,
            height: buttonHeight,
            child: Text(
              okTitle,
              style: TextStyle(fontSize: 14.f_pt_demo),
            ),
          ),
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
        TextButton(
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.iKnowHandle();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20.h_pt_demo),
            ),
            width: 240,
            height: 40,
            child: Text(
              iKnowTitle,
              style: TextStyle(fontSize: 14.f_pt_demo),
            ),
          ),
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
