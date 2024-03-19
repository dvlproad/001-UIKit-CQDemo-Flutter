/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-18 11:42:17
 * @Description: 图片集合视图单元的基类
 */
import 'package:flutter/material.dart';
import '../components/bg_border_widget.dart';

class CQImageBaseGridCell extends StatelessWidget {
  final double? width;
  final double? height;
  final ImageProvider? imageProvider;
  final Widget? customImageWidget;
  final double? cornerRadius;
  final String? message; // 相册的辅助信息，如视频 video 长度等，可为 null

  final int index;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const CQImageBaseGridCell({
    Key? key,
    this.width,
    this.height,
    this.imageProvider,
    this.customImageWidget,
    this.cornerRadius,
    this.message,
    required this.index,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  })  : assert(imageProvider != null || customImageWidget != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (customImageWidget != null) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(this.cornerRadius ?? 0)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: this.onTap,
          onDoubleTap: this.onDoubleTap,
          onLongPress: this.onLongPress,
          child: Container(
            width: width,
            height: height,
            // color: Colors.red,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: Image.file(File(imagePath)).image,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // constraints: BoxConstraints(
            //   minWidth: double.infinity,
            //   minHeight: double.infinity,
            // ),
            child: Stack(
              children: [
                customImageWidget!,
                if (this.message != null && this.message!.isNotEmpty)
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
      onTap: this.onTap,
      onDoubleTap: this.onDoubleTap,
      onLongPress: this.onLongPress,
      backgroundImage: this.imageProvider!,
      cornerRadius: 10,
      child: Stack(
        children: [
          if (this.message != null && this.message!.isNotEmpty)
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
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.end,
        style: TextStyle(fontSize: 10.0, color: Colors.green),
      ),
    );
  }
}
