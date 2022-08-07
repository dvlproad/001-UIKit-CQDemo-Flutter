import 'package:flutter/material.dart';

/*
 * 紧邻的'取消'+'确定' Buttons
 */
class AlertCancelOKCloseButtons extends StatelessWidget {
  final String cancelTitle;
  final Function? cancelHandle;
  // final Void Function(Void) cancelHandle;

  final String okTitle;
  final Function? okHandle;

  AlertCancelOKCloseButtons({
    Key? key,
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
          Divider(color: Colors.grey, height: 1),
          Container(height: 50, child: _row())
        ],
      ),
    );
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: FlatButton(
            color: Colors.transparent,
            // shape: StadiumBorder(side: BorderSide(color: Colors.black)),
            onPressed: () {
              if (this.cancelHandle != null) {
                this.cancelHandle!();
              }
            },
            child: Text(
              this.cancelTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ),
        ),
        VerticalDivider(
          color: Colors.grey[300],
          width: 1,
          thickness: 1,
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            // color: color,
            // shape: StadiumBorder(),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 100), () {
                if (this.okHandle != null) {
                  this.okHandle!();
                }
              });
            },
            child: Text(
              this.okTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ),
        )
      ],
    );
  }
}

/*
 * '我知道了' Button
 */
class AlertIKnowCloseButton extends StatelessWidget {
  final String iKnowTitle;
  final Function iKnowHandle;

  AlertIKnowCloseButton({
    Key? key,
    this.iKnowTitle = '我知道了',
    required this.iKnowHandle,
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
