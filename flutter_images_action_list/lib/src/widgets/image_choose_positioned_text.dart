/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-19 15:39:10
 * @Description: 图片选择器的单元视图上的其他视图
 */
import 'package:flutter/material.dart';

class PositionedImageChooseText extends StatelessWidget {
  final String? flagText;

  const PositionedImageChooseText({
    Key? key,
    this.flagText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool visible = flagText != null && flagText!.isNotEmpty;

    return Visibility(
      visible: visible,
      child: Container(
        height: 20,
        decoration: BoxDecoration(
            gradient: _imageCellTextGradient,
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.bottomCenter,
        child: Text(
          flagText ?? '',
          style: const TextStyle(
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w400,
            fontSize: 13,
            overflow: TextOverflow.ellipsis,
            color: Colors.white,
          ),
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
