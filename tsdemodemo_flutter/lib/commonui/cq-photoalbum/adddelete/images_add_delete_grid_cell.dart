import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_base_grid_cell.dart';

class CQImageDeleteGridCell extends StatelessWidget {
  final ImageProvider image;
  final String message; // 相册的辅助信息，如视频 video 长度等，可为 null

  final int index;
  final VoidCallback onPressed;
  final VoidCallback onPressedDelete;

  const CQImageDeleteGridCell({
    Key key,
    @required this.image,
    this.message,
    @required this.index,
    @required this.onPressed,
    @required this.onPressedDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CQImageBaseGridCell(
          image: this.image,
          index: this.index,
          message: this.message,
          onPressed: this.onPressed,
        ),
        Positioned(
          right: 5,
          bottom: 5,
          // child: Icon(C1440Icon.icon_correct,
          //     size: 20, color: Color(0xFF1FFD92)),
          child: GestureDetector(
            onTap: this.onPressedDelete,
            child: Image(
              image: AssetImage('lib/Resources/report/arrow_right.png'),
              width: 40,
              height: 40,
            ),
          ),
        ),
      ],
    );
  }
}
