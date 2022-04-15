import 'package:flutter/material.dart';
import './bg_border_widget.dart';

class CQImageBaseGridCell extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget customImageWidget;
  final double cornerRadius;
  final String message; // 相册的辅助信息，如视频 video 长度等，可为 null

  final int index;
  final VoidCallback onPressed;

  const CQImageBaseGridCell({
    Key key,
    this.imageProvider,
    this.customImageWidget,
    this.cornerRadius,
    this.message,
    @required this.index,
    this.onPressed,
  })  : assert(imageProvider != null || customImageWidget != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (customImageWidget != null) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(this.cornerRadius ?? 8)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: this.onPressed,
          child: Container(
            color: Colors.red,
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: double.infinity,
            ),
            child: Stack(
              children: [
                customImageWidget,
                if (this.message != null && this.message.isNotEmpty)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: _messageLabel(this.message),
                  ),
              ],
            ),
          ),
        ),
      );
    }

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
