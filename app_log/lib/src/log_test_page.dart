/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 17:18:27
 * @Description: 日志功能的测试页面
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import 'package:app_environment/app_environment.dart';

class LogTestPage extends StatefulWidget {
  const LogTestPage({
    Key? key,
  }) : super(key: key);

  @override
  _LogTestPageState createState() => _LogTestPageState();
}

class _LogTestPageState extends State<LogTestPage> {
  late String _logRobotKey;
  late String _logTitle;
  late String _logCustomMessage;
  // List<String> _logMentionedList;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    String myRobotKey = CommonErrorRobot.myRobotKey; // 单个人测试用的

    _logRobotKey = myRobotKey;
    _logTitle = '我只是个测试标题';
    _logCustomMessage = '我只是测试信息';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日志测试页'),
      ),
      body: GestureDetector(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              ImageTitleTextValueCell(
                height: 40,
                title: "log信息",
                textValue: '',
                arrowImageType: TableViewCellArrowImageType.none,
              ),
              _robotUrl_cell(),
              _logTitle_cell(),
              _logCustomMessage_cell(),
              _logRobot_cell(),
              Container(height: 40),
              RowPaddingButton(
                height: 44,
                leftRightPadding: 20,
                title: '发送',
                bgColorType: ThemeBGType.theme,
                onPressed: throttle(() async {
                  _sendLog();
                }),
              ),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }

  _sendLog() async {
    bool sendSuccess = await LogUtil.postError(
      _logRobotKey,
      _logTitle,
      _logCustomMessage,
      ['lichaoqian'],
    );

    String message = sendSuccess ? "日志上报成功" : "日志上报失败";
    ToastUtil.showMessage(message);
  }

  Widget _robotUrl_cell() {
    return ImageTitleTextValueCell(
      title: "企业微信地址",
      textValue: _logRobotKey,
      textValueMaxLines: 4,
      textValueFontSize: 12,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logRobotKey));
        ToastUtil.showMessage('企业微信地址拷贝成功');
      },
    );
  }

  Widget _logTitle_cell() {
    return ImageTitleTextValueCell(
      title: "日志标题",
      textValue: _logTitle,
      textValueMaxLines: 4,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logTitle));
        ToastUtil.showMessage('日志标题拷贝成功');
      },
    );
  }

  Widget _logCustomMessage_cell() {
    return ImageTitleTextValueCell(
      title: "日志正文",
      textValue: _logCustomMessage,
      textValueMaxLines: 30,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logCustomMessage));
        ToastUtil.showMessage('日志正文拷贝成功');
      },
    );
  }

  Widget _logRobot_cell() {
    return ImageTitleTextValueCell(
      title: "日志接收地址",
      textValue: _logRobotKey,
      textValueMaxLines: 30,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logRobotKey));
        ToastUtil.showMessage('日志接收地址拷贝成功');
      },
    );
  }
}
