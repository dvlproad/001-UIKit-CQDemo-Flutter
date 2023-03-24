import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/base-uikit/textfield/clearButton_textfield.dart';
import 'package:flutter_baseui_kit/base-uikit/textfield/textfield_container.dart';
import './components/alert_closed_buttons.dart';
// import './components/alert_spaced_buttons.dart';
import './components/alert_container.dart';

/*
 * '我知道了' AlertView
 */
class IKnowTextInputAlertView extends StatelessWidget {
  final double? heiht;

  final String? title;
  final String? placeholder;
  final String? inputText;

  final String iKnowTitle;
  final Function? iKnowHandle;

  IKnowTextInputAlertView({
    Key? key,
    this.heiht,
    this.title,
    this.placeholder,
    this.inputText,
    this.iKnowTitle = '我知道了',
    this.iKnowHandle,
  });

  @override
  Widget build(BuildContext context) {
    return CQAlertContainer(
      height: heiht,
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
            this.iKnowHandle!();
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
  final double? heiht;
  final String? title;
  final String? placeholder;
  final String? inputText;

  final String cancelTitle;
  final Function? cancelHandle;

  final String okTitle;
  final Function? okHandle;

  CancelOKTextInputAlertView({
    Key? key,
    this.heiht,
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
      height: heiht,
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
      ),
    );
  }
}

/* Alert 的 title 和 textInput 样式视图 */
class AlertTitleTextInputWidget extends StatelessWidget {
  final String? title;
  final String? placeholder;
  final String? inputText;

  const AlertTitleTextInputWidget({
    Key? key,
    this.title,
    this.placeholder,
    this.inputText,
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
      this.title ?? '',
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _textFieldWidget() {
    return CJTextFieldContainer(
      height: 44,
      backgroundColor: Colors.white,
      cornerRadius: 10,
      borderWidth: 0.6,
      borderColor: Color(0xff323334),
      textFieldWidget: CJClearButtonTextField(
        text: this.inputText,
        placeholder: this.placeholder,
      ),
      // prefixWidget: _prefixIcon(),
      // suffixWidget: SizedBox(width: 5),
    );
  }
}
