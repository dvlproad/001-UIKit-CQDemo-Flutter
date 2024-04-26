import 'package:flutter/material.dart';

// import './components/alert_closed_buttons.dart';
import './components/alert_spaced_buttons.dart';
import './components/flex_width_buttons.dart';
import './components/alert_container.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';

class CJBaseMessageAlertView extends StatelessWidget {
  final double? height;

  final String? title;
  final String? message;
  final RichText? richTextWidget;
  final TextAlign? messageAlign;
  final bool isCloseButton; // button按钮是否是紧密的，如果是的话底部间隔是0
  final Function? closeHandle;
  final bool? scrollable;
  final bool barrierDismissible;
  final bool showCloseButton;

  CJBaseMessageAlertView({
    Key? key,
    this.height,
    this.title,
    this.message,
    this.richTextWidget,
    this.messageAlign,
    this.isCloseButton = false,
    this.closeHandle,
    this.scrollable,
    this.barrierDismissible = true,
    this.showCloseButton = true,
  });

  Widget renderButtons() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    double buttonToBottomDistance = isCloseButton ? 0 : 20.0;
    Map allAlertMarginVertical = {
      // alert 竖直上的间距
      "title_buttons": [30.0, 30.0, 20.0, buttonToBottomDistance],
      "title_message_buttons": [30.0, 20.0, 20.0, buttonToBottomDistance],
      "message_buttons": [20.0, 20.0, 0.0, buttonToBottomDistance],
    };

    dynamic alertMarginVerticals = [];
    int titleVerticalIndex = 0;
    int messageVerticalIndex = 0;
    int buttonsVerticalIndex = 0;
    if (this.title != null) {
      if (this.message != null || this.richTextWidget != null) {
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
      if (this.message != null || this.richTextWidget != null) {
        alertMarginVerticals = allAlertMarginVertical["message_buttons"];
        titleVerticalIndex = -1;
        messageVerticalIndex = 0;
        buttonsVerticalIndex = 1;
      }
    }

    Widget? alertTitleComponent;
    if (this.title != null) {
      alertTitleComponent = Container(
        margin: EdgeInsets.only(top: alertMarginVerticals[titleVerticalIndex]),
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(
          this.title ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.bold,
            fontSize: 16.f_pt_cj,
            color: Color(0xff333333),
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    Widget? alertMessageComponent;
    if (this.message != null) {
      alertMessageComponent = Container(
          margin:
              EdgeInsets.only(top: alertMarginVerticals[messageVerticalIndex]),
          padding: EdgeInsets.only(left: 20.w_pt_cj, right: 20.w_pt_cj),
          child: scrollable == true
              ? Container(
                  height: 350.h_pt_cj,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _getMessageWidget(this.message, messageAlign),
                  ),
                )
              : _getMessageWidget(this.message, this.messageAlign));
    } else if (this.richTextWidget != null) {
      alertMessageComponent = Container(
          margin:
              EdgeInsets.only(top: alertMarginVerticals[messageVerticalIndex]),
          padding: EdgeInsets.only(left: 20.w_pt_cj, right: 20.w_pt_cj),
          child: scrollable == true
              ? Container(
                  height: 350.h_pt_cj,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: richTextWidget,
                  ),
                )
              : richTextWidget);
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
      height: height,
      contentWidget: Column(children: columnWidgets),
      buttonsWidgetHeight: buttonsWidgetHeight,
      buttonsWidget: Container(
        padding: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        child: renderButtons(),
      ),
      closeHandle: closeHandle,
      barrierDismissible: barrierDismissible,
      showCloseButton: showCloseButton,
    );
  }

  Widget _getMessageWidget(String? msg, TextAlign? align) {
    return Text(
      msg ?? '',
      textAlign: align,
      style: TextStyle(
        fontSize: 13.f_pt_cj,
        color: const Color(0xff8b8b8b),
        decoration: TextDecoration.none,
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

  IKnowMessageAlertView(
      {Key? key,
      double? height,
      String? title,
      String? message,
      RichText? richTextWidget,
      TextAlign? messageAlign,
      Function? closeHandle,
      bool showCloseButton = true,
      bool barrierDismissible = true,
      this.iKnowTitle = '我知道了',
      required this.iKnowHandle,
      bool? scrollable})
      : super(
          key: key,
          height: height,
          title: title,
          message: message,
          richTextWidget: richTextWidget,
          messageAlign: messageAlign,
          scrollable: scrollable,
          closeHandle: closeHandle,
          barrierDismissible: barrierDismissible,
          showCloseButton: showCloseButton,
        );

  @override
  Widget renderButtons() {
    return AlertIKnowSpacedButton(
      iKnowTitle: this.iKnowTitle,
      iKnowHandle: () {
        // print("点击Alert按钮:'我知道了'");
        this.iKnowHandle();
      },
    );
  }
}

/*
 * '取消' + '确定' AlertView
 */
class CancelOKMessageAlertView extends CJBaseMessageAlertView {
  final String cancelTitle;
  final Function? cancelHandle;

  final String okTitle;
  final Function? okHandle;
  final Function? closeHandle;

  CancelOKMessageAlertView({
    Key? key,
    double? heiht,
    String? title,
    String? message,
    RichText? richTextWidget,
    TextAlign? messageAlign,
    this.cancelTitle = '取消',
    this.cancelHandle,
    this.closeHandle,
    this.okTitle = '确认',
    this.okHandle,
  })  : assert(title != null || message != null),
        // 不同同时为空
        super(
          key: key,
          height: heiht,
          title: title,
          message: message,
          messageAlign: messageAlign,
        );

  @override
  Widget renderButtons() {
    return AlertdCancelOKSpacedButtons(
      cancelTitle: this.cancelTitle,
      cancelHandle: () {
        // print("点击Alert按钮:'取消'");
        if (this.cancelHandle != null) {
          this.cancelHandle!();
        }
      },
      okTitle: this.okTitle,
      okHandle: () {
        // print("点击Alert按钮:'确认'");
        if (this.okHandle != null) {
          this.okHandle!();
        }
      },
    );
  }
}

/*
 * '等宽均分的 Buttons' AlertView
 */
class FlexWidthButtonsMessageAlertView extends CJBaseMessageAlertView {
  final List<String> buttonTitles;
  final void Function(int buttonIndex) onPressedButton;

  FlexWidthButtonsMessageAlertView({
    Key? key,
    String? title,
    String? message,
    TextAlign? messageAlign,
    required this.buttonTitles,
    required this.onPressedButton,
  }) : super(
          key: key,
          title: title,
          message: message,
          messageAlign: messageAlign,
          isCloseButton: true,
        );

  @override
  Widget renderButtons() {
    return FlexWidthButtons(
      height: 50,
      titles: buttonTitles,
      onPressed: onPressedButton,
    );
  }
}
