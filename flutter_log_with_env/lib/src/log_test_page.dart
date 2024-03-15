// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 12:19:37
 * @Description: 日志功能的测试页面
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_optimize_interacte/flutter_optimize_interacte.dart';
import 'package:flutter_robot_base/flutter_robot_base.dart';

import './log_util.dart';

class LogTestPage extends StatefulWidget {
  const LogTestPage({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _LogTestPageState();
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
        title: const Text('日志测试页'),
      ),
      body: GestureDetector(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              CJTSImageTitleTextValueCell(
                height: 40,
                title: "log信息",
                textValue: '',
                arrowImageType: CJTSTableViewCellArrowImageType.none,
              ),
              _robotUrl_cell(),
              _logTitle_cell(),
              _logCustomMessage_cell(),
              _logRobot_cell(),
              Container(height: 40),
              Container(
                height: 44,
                color: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: throttle(() async {
                    _sendLog();
                  }),
                  child: const Text(
                    "发送",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
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
    CJTSToastUtil.showMessage(message);
  }

  Widget _robotUrl_cell() {
    return CJTSImageTitleTextValueCell(
      title: "企业微信地址",
      textValue: _logRobotKey,
      textValueMaxLines: 4,
      textValueFontSize: 12,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logRobotKey));
        CJTSToastUtil.showMessage('企业微信地址拷贝成功');
      },
    );
  }

  Widget _logTitle_cell() {
    return CJTSImageTitleTextValueCell(
      title: "日志标题",
      textValue: _logTitle,
      textValueMaxLines: 4,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logTitle));
        CJTSToastUtil.showMessage('日志标题拷贝成功');
      },
    );
  }

  Widget _logCustomMessage_cell() {
    return CJTSImageTitleTextValueCell(
      title: "日志正文",
      textValue: _logCustomMessage,
      textValueMaxLines: 30,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logCustomMessage));
        CJTSToastUtil.showMessage('日志正文拷贝成功');
      },
    );
  }

  Widget _logRobot_cell() {
    return CJTSImageTitleTextValueCell(
      title: "日志接收地址",
      textValue: _logRobotKey,
      textValueMaxLines: 30,
      onTap: () {},
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _logRobotKey));
        CJTSToastUtil.showMessage('日志接收地址拷贝成功');
      },
    );
  }
}
