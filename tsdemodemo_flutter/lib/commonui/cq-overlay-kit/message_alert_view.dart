import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-overlay-kit/alert_buttons.dart';

/*
 * '我知道了' AlertView
 */
class IKnowMessageAlertView extends StatelessWidget {
  final String title;
  final String message;

  final String iKnowTitle;
  final Function iKnowHandle;

  IKnowMessageAlertView({
    Key key,
    this.title,
    this.message,
    this.iKnowTitle = '我知道了',
    this.iKnowHandle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseMessageAlertView(
      title: this.title,
      message: this.message,
      buttonsWidget: AlertIKnowCloseButton(
        iKnowTitle: this.iKnowTitle,
        iKnowHandle: () {
          // print("点击Alert按钮:'我知道了'");
          if (this.iKnowHandle != null) {
            this.iKnowHandle();
          }
        },
      ),
    );
  }
}

/*
 * '取消' + '确定' AlertView
 */
class CancelOKMessageAlertView extends StatelessWidget {
  final String title;
  final String message;

  final String cancelTitle;
  final Function cancelHandle;

  final String okTitle;
  final Function okHandle;

  CancelOKMessageAlertView({
    Key key,
    this.title,
    this.message,
    this.cancelTitle = '取消',
    this.cancelHandle,
    this.okTitle = '确认',
    this.okHandle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseMessageAlertView(
      title: this.title,
      message: this.message,
      buttonsWidget: AlertCancelOKCloseButtons(
        cancelTitle: this.cancelTitle,
        cancelHandle: () {
          // print("点击Alert按钮:'取消'");
          if (this.cancelHandle != null) {
            this.cancelHandle();
          }
        },
        okTitle: this.okTitle,
        okHandle: () {
          // print("点击Alert按钮:'确认'");
          if (this.okHandle != null) {
            this.okHandle();
          }
        },
      ),
    );
  }
}

/*  基础的 MessageAlert 部分 */
class BaseMessageAlertView extends StatelessWidget {
  final String title;
  final String message;
  final Widget buttonsWidget;

  BaseMessageAlertView({
    Key key,
    this.title,
    this.message,
    this.buttonsWidget,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(color: Color(0x33000000)),
      child: Center(
        child: Container(
          width: width - 100,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: AlertTitleContentWidget(
                  title: this.title,
                  message: this.message,
                ),
              ),
              this.buttonsWidget,
            ],
          ),
        ),
      ),
    );
  }
}

/* Alert 的 title 和 message 样式视图 */
class AlertTitleContentWidget extends StatelessWidget {
  final String title;
  final String message;

  const AlertTitleContentWidget({
    Key key,
    this.title = '',
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(children: <Widget>[
          _titleWidget(),
          _messageWidget(),
        ]),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _messageWidget() {
    return Text(
      this.message,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
        decoration: TextDecoration.none,
      ),
    );
  }
}
