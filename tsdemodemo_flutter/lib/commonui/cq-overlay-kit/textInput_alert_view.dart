import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/textfield.dart';
import 'package:tsdemodemo_flutter/commonui/cq-overlay-kit/alert_buttons.dart';
import 'package:tsdemodemo_flutter/commonui/cq-overlay-kit/alert_container.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/searchbar.dart';

/*
 * '我知道了' AlertView
 */
class IKnowTextInputAlertView extends StatelessWidget {
  final String title;
  final String placeholder;
  final String inputText;

  final String iKnowTitle;
  final Function iKnowHandle;

  IKnowTextInputAlertView({
    Key key,
    this.title,
    this.placeholder,
    this.inputText,
    this.iKnowTitle = '我知道了',
    this.iKnowHandle,
  });

  @override
  Widget build(BuildContext context) {
    return CQAlertContainer(
      contentWidget: AlertTitleTextInputWidget(
        title: this.title,
        placeholder: this.placeholder,
        inputText: this.inputText,
      ),
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
class CancelOKTextInputAlertView extends StatelessWidget {
  final String title;
  final String placeholder;
  final String inputText;

  final String cancelTitle;
  final Function cancelHandle;

  final String okTitle;
  final Function okHandle;

  CancelOKTextInputAlertView({
    Key key,
    this.title,
    this.placeholder,
    this.inputText,
    this.cancelTitle = '取消',
    this.cancelHandle,
    this.okTitle = '确认',
    this.okHandle,
  });

  @override
  Widget build(BuildContext context) {
    return CQAlertContainer(
      contentWidget: AlertTitleTextInputWidget(
        title: this.title,
        placeholder: this.placeholder,
        inputText: this.inputText,
      ),
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

/* Alert 的 title 和 textInput 样式视图 */
class AlertTitleTextInputWidget extends StatelessWidget {
  final String title;
  final String placeholder;
  final String inputText;

  const AlertTitleTextInputWidget({
    Key key,
    this.title = '',
    this.placeholder = '',
    this.inputText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(children: <Widget>[
          SizedBox(height: 20),
          _titleWidget(),
          SizedBox(height: 10),
          _textFieldWidget(),
          SizedBox(height: 10),
        ]),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _textFieldWidget() {
    return CJTextField(
      height: 40,
      text: this.inputText,
      placeholder: this.placeholder,
      backgroundColor: Colors.white,
      borderWidth: 0.6,
      cornerRadius: 10,
    );
  }
}
