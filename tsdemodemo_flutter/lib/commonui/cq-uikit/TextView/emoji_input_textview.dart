import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textview/emoji_lengthLimiting_textInputFormatter.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textview/input_textview.dart';

class CQEmojiInputTextView extends CQInputTextView {
  // final String text;
  // final String placeholder;
  // final int maxLength;
  // // final int Function(String) maxLengthAlgorithm;
  // // final List<TextInputFormatter> inputFormatters;
  // final int maxLines;
  // final double minHeight; // 文本框的最小高度
  // final double maxHeight; // 文本框的最大高度
  // final TextChangeCallback textChangeCallback;

  CQEmojiInputTextView({
    Key key,
    String text,
    String placeholder,
    int maxLength,
    int maxLines,
    double minHeight,
    double maxHeight,
    @required TextChangeCallback textChangeCallback,
  }) : super(
          key: key,
          text: text,
          placeholder: placeholder,
          maxLength: maxLength,
          maxLines: maxLines,
          minHeight: minHeight,
          maxHeight: maxHeight,
          textChangeCallback: textChangeCallback,
          maxLengthAlgorithm: (String currentText) {
            int showTextLength = currentText.characters.length;
            return showTextLength;
          },
          inputFormatters: <TextInputFormatter>[
            CQEmojiLengthLimitingTextInputFormatter(maxLength),
          ],
        );
}
