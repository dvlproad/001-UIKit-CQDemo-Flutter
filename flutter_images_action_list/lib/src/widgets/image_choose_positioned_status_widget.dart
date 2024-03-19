/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-19 15:34:49
 * @Description: 图片选择器的单元视图上的其他视图
 */
import 'package:flutter/material.dart';

class PositionedImageChooseStatusWidget extends StatelessWidget {
  final ImageProvider? imageProvider;
  final String? flagText;
  final VoidCallback onPressed;

  const PositionedImageChooseStatusWidget({
    Key? key,
    this.imageProvider,
    this.flagText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: buildPositioned(context),
    );
  }

  Widget buildPositioned(BuildContext context) {
    bool visible = flagText != null && flagText!.isNotEmpty;

    return Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          gradient: _imageCellTextGradient,
        ),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageProvider == null
                ? Container()
                : Image(image: imageProvider!, width: 30, height: 30),
            (flagText == null || flagText!.isEmpty)
                ? Container()
                : Container(
                    // color: Colors.amber,
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(maxHeight: 20),
                    child: Text(
                      flagText!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  LinearGradient get _imageCellTextGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xff404040).withOpacity(0.0),
        const Color(0xff404040).withOpacity(1.0),
      ],
    );
  }
}
