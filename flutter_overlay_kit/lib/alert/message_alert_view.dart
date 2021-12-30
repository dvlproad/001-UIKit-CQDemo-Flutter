import 'package:flutter/material.dart';
import './components/alert_closed_buttons.dart';
import './components/alert_spaced_buttons.dart';
import './components/alert_container.dart';

class CJBaseMessageAlertView extends StatelessWidget {
  final String title;
  final String message;

  CJBaseMessageAlertView({
    Key key,
    this.title,
    this.message,
  });

  Widget renderButtons() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Map allAlertMarginVertical = {
      // alert 竖直上的间距
      "title_buttons": [30.0, 30.0, 20.0, 0.0],
      "title_message_buttons": [20.0, 10.0, 20.0, 20.0],
      "message_buttons": [20.0, 20.0, 0.0, 0.0],
    };

    dynamic alertMarginVerticals = [];
    int titleVerticalIndex = 0;
    int messageVerticalIndex = 0;
    int buttonsVerticalIndex = 0;
    if (this.title != null) {
      if (this.message != null) {
        alertMarginVerticals = allAlertMarginVertical["title_message_buttons"];
        titleVerticalIndex = 0;
        messageVerticalIndex = 1;
        buttonsVerticalIndex = 2;
      } else {
        alertMarginVerticals = allAlertMarginVertical["title_buttons"];
        titleVerticalIndex = 0;
        messageVerticalIndex = -1;
        buttonsVerticalIndex = 1;
      }
    } else {
      if (this.message != null) {
        alertMarginVerticals = allAlertMarginVertical["message_buttons"];
        titleVerticalIndex = -1;
        messageVerticalIndex = 0;
        buttonsVerticalIndex = 1;
      }
    }

    Widget alertTitleComponent = null;
    if (this.title != null) {
      alertTitleComponent = Container(
        margin: EdgeInsets.only(top: alertMarginVerticals[titleVerticalIndex]),
        child: Text(
          this.title ?? '',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    Widget alertMessageComponent = null;
    if (this.message != null) {
      alertMessageComponent = Container(
        margin:
            EdgeInsets.only(top: alertMarginVerticals[messageVerticalIndex]),
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(
          this.message ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    double marginTop = alertMarginVerticals[buttonsVerticalIndex];
    double marginBottom = alertMarginVerticals[buttonsVerticalIndex + 1];

    List<Widget> columnWidgets = [];
    if (alertTitleComponent != null) {
      columnWidgets.add(alertTitleComponent);
    }
    if (alertMessageComponent != null) {
      columnWidgets.add(alertMessageComponent);
    }

    double buttonHeight = 40;
    double buttonsWidgetHeight = marginTop + buttonHeight + marginBottom;

    return CQAlertContainer(
      contentWidget: Column(
        children: columnWidgets,
      ),
      buttonsWidgetHeight: buttonsWidgetHeight,
      buttonsWidget: Container(
        // color: Colors.pink,
        padding: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        child: renderButtons(),
      ),
    );
  }
}

/*
 * '我知道了' AlertView
 */
class IKnowMessageAlertView extends CJBaseMessageAlertView {
  final String iKnowTitle;
  final Function iKnowHandle;

  IKnowMessageAlertView({
    Key key,
    String title,
    String message,
    this.iKnowTitle = '我知道了',
    this.iKnowHandle,
  }) : super(
          key: key,
          title: title,
          message: message,
        );

  @override
  Widget renderButtons() {
    return AlertIKnowCloseButton(
      iKnowTitle: this.iKnowTitle,
      iKnowHandle: () {
        // print("点击Alert按钮:'我知道了'");
        if (this.iKnowHandle != null) {
          this.iKnowHandle();
        }
      },
    );
  }
}

/*
 * '取消' + '确定' AlertView
 */
class CancelOKMessageAlertView extends CJBaseMessageAlertView {
  final String cancelTitle;
  final Function cancelHandle;

  final String okTitle;
  final Function okHandle;

  CancelOKMessageAlertView({
    Key key,
    String title,
    String message,
    this.cancelTitle = '取消',
    this.cancelHandle,
    this.okTitle = '确认',
    this.okHandle,
  }) : super(
          key: key,
          title: title,
          message: message,
        );

  @override
  Widget renderButtons() {
    return AlertdCancelOKSpacedButtons(
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
    );
  }
}
