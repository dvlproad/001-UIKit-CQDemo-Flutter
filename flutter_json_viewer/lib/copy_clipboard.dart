import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_log_base/src/string_format_util/formatter_object_util.dart';

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
