import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 源码参考：[Flutter TextField 中只允许输入合法的小数](https://www.cnblogs.com/yangyxd/p/9639588.html)
// 更多参考：[Flutter限定TextField输入内容](https://www.jianshu.com/p/627a7acde6e3)
// class CQEmojiLengthLimitingTextInputFormatter extends TextInputFormatter {
//   final int maxLength;

//   CQEmojiLengthLimitingTextInputFormatter(this.maxLength)
//       : assert(maxLength == null || maxLength == -1 || maxLength > 0);

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     String newText = newValue.text;
//     int newSelectionIndex = newValue.selection.end;

//     int oldTextLength = oldValue.text.runes.length;
//     if (oldTextLength > this.maxLength) {
//       newText = oldValue.text;
//       newSelectionIndex = oldValue.selection.end;
//     } else {
//       int newTextLength = newText.runes.length;
//       if (newTextLength <= this.maxLength) {
//         newText = newValue.text;
//         newSelectionIndex = newValue.selection.end;
//       } else {
//         // 新文本大于最大长度，进行截取
//         newText = newValue.text.substring(0, this.maxLength);
//         newSelectionIndex = max(newValue.selection.end, this.maxLength);
//       }
//     }

//     return new TextEditingValue(
//       text: newText,
//       // selection: new TextSelection.collapsed(offset: newSelectionIndex),
//       // 保持光标在最后
//       selection: new TextSelection.fromPosition(
//         TextPosition(
//           affinity: TextAffinity.downstream,
//           offset: newSelectionIndex,
//         ),
//       ),
//     );
//   }
// }

class CQEmojiLengthLimitingTextInputFormatter
    extends LengthLimitingTextInputFormatter {
  CQEmojiLengthLimitingTextInputFormatter(int maxLength) : super(maxLength);

  // final int maxLength;

  // CQEmojiLengthLimitingTextInputFormatter(this.maxLength)
  //     : assert(maxLength == null || maxLength == -1 || maxLength > 0);

  // @visibleForTesting
  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    final CharacterRange iterator = CharacterRange(value.text);
    if (value.text.runes.length > maxLength) {
      iterator.expandNext(maxLength);
    }
    final String truncated = iterator.current;
    return TextEditingValue(
      text: truncated,
      selection: value.selection.copyWith(
        baseOffset: math.min(value.selection.start, truncated.length),
        extentOffset: math.min(value.selection.end, truncated.length),
      ),
      composing: TextRange.empty,
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    if (maxLength != null &&
        maxLength > 0 &&
        newValue.text.runes.length > maxLength) {
      // If already at the maximum and tried to enter even more, keep the old
      // value.
      if (oldValue.text.runes.length == maxLength) {
        return oldValue;
      }
      return truncate(newValue, maxLength);
    }
    return newValue;
  }
}
