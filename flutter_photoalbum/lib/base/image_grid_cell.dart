/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 16:45:25
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_baseui_kit/base-uikit/bg_border_widget.dart';

class CQImageBaseGridCell extends StatelessWidget {
  final ImageProvider imageProvider;
  final String message; // 相册的辅助信息，如视频 video 长度等，可为 null

  final int index;
  final VoidCallback onPressed;

  const CQImageBaseGridCell({
    Key key,
    @required this.imageProvider,
    this.message,
    @required this.index,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CJBGImageWidget(
      onPressed: this.onPressed,
      backgroundImage: this.imageProvider,
      cornerRadius: 10,
      child: Stack(
        children: [
          if (this.message != null && this.message.isNotEmpty)
            Positioned(
              right: 5,
              top: 5,
              child: _messageLabel(this.message),
            ),
        ],
      ),
    );
  }

  Widget _messageLabel(message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.end,
        style: TextStyle(fontSize: 10.0),
      ),
    );
  }
}
