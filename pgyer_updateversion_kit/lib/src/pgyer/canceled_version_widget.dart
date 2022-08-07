/*
 * @Author: dvlproad
 * @Date: 2022-07-08 11:28:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-09 23:20:48
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

class CanceledVersionWidget extends StatefulWidget {
  CanceledVersionWidget({Key? key}) : super(key: key);

  @override
  State<CanceledVersionWidget> createState() => _CanceledVersionWidgetState();
}

class _CanceledVersionWidgetState extends State<CanceledVersionWidget> {
  List<String> _cancelShowVersions = [];

  @override
  void initState() {
    super.initState();

    _getCancelShowVersions();
  }

  @override
  Widget build(BuildContext context) {
    return ImageTitleTextValueCell(
      title: "不再提示更新的版本",
      textValue: '已跳过:${_cancelShowVersions.length}个',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CancelVersionPage(),
          ),
        ).then((value) {
          // setState(() {});
          _getCancelShowVersions();
        });
      },
    );
  }

  // 获取被跳过的版本个数
  _getCancelShowVersions() {
    CheckVersionCommonUtil.getCancelShowVersion()
        .then((List<String> bCancelShowVersions) {
      setState(() {
        _cancelShowVersions = bCancelShowVersions;
      });
    });
  }
}
