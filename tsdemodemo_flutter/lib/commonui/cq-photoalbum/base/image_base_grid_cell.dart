import 'package:flutter/material.dart';

class CQImageBaseGridCell extends StatelessWidget {
  final ImageProvider image;
  final String message; // 相册的辅助信息，如视频 video 长度等，可为 null

  final int index;
  final VoidCallback onPressed;

  const CQImageBaseGridCell({
    Key key,
    @required this.image,
    this.message,
    @required this.index,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(),
            image: DecorationImage(
              image: this.image,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if (this.message != null)
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
