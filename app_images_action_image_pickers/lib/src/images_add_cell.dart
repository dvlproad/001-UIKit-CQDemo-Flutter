/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 16:31:56
 * @Description: 图片列表添加Cell
 */
import 'package:flutter/material.dart';

enum AddCellType {
  defalut_add,
  image_text, // 图片+"添加照片"
}

class AddCell extends StatelessWidget {
  AddCellType addCellType;

  AddCell({
    Key key,
    this.addCellType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget childWidget;
    if (addCellType == AddCellType.image_text) {
      childWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              'assets/icon_add_photo.png',
              package: 'app_images_action_image_pickers',
            ),
            width: 32,
            height: 32,
          ),
          Container(height: 10),
          Center(
            child: Text(
              "添加图片",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFB2B2B2),
                height: 1,
              ),
            ),
          )
        ],
      );
    } else {
      childWidget = Image(
        image: AssetImage(
          'assets/icon_add_default.png',
          package: 'app_images_action_image_pickers',
        ),
        width: 32,
        height: 32,
      );
    }
    return bulidAddCell(context, childWidget);
  }

  Widget bulidAddCell(BuildContext context, Widget childWidget) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Color(0xFFBBBBBB), width: 0.5),
        ),
        child: childWidget);
  }
}
