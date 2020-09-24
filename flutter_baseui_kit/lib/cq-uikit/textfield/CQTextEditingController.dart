import 'package:flutter/material.dart';

TextEditingController editText(view) {
  return TextEditingController.fromValue(
      TextEditingValue(
        // 设置内容
          text: '$view',
          // 保持光标在最后
          selection: TextSelection.fromPosition(
              TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: "$view".length
              )
          )
      )
  );
}