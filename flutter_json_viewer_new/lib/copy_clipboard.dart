/*
 * @Author: dvlproad
 * @Date: 2023-04-03 13:48:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 15:51:21
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_foundation_base/flutter_foundation_base.dart';

///复制到粘贴板
copyClipboard(BuildContext context, String? value) {
  var snackBar =
      SnackBar(content: Text('$value\n\n copy success to clipboard'));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Clipboard.setData(ClipboardData(text: value ?? 'null'));
}

clipboardValue({BuildContext? context, dynamic value}) {
  String valueString = FormatterUtil.convert(value, 0, isObject: true);

  Clipboard.setData(ClipboardData(text: valueString));
  ToastUtil.showMessage('json信息拷贝成功');
}
