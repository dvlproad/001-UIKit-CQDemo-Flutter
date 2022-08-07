/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 14:56:00
 * @Description: 图片列表添加Cell
 */
import 'package:flutter/material.dart';

enum AddCellType {
  defalut_add, // ➕图片
  image_only_default, // 拍照图片(使用于愿望单创建)
  image_text_default, // 图片+"添加照片"文字(使用于愿望单创建)
  image_text_for_user_photos, // 图片+"添加照片"文字(使用于个人主页照片墙)
  image_text_for_refund, //申请退款样式
}

class AddCell extends StatelessWidget {
  AddCellType addCellType;

  AddCell({
    Key? key,
    required this.addCellType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (addCellType == AddCellType.image_text_for_user_photos) {
      return _image_text_for_user_photos_cell(context);
    } else if (addCellType == AddCellType.image_only_default) {
      return _image_only_default_cell(
        context,
        packageImageName: 'assets/icon_add_photo.png',
      );
    } else if (addCellType == AddCellType.defalut_add) {
      return _image_only_default_cell(
        context,
        packageImageName: 'assets/icon_add_default.png',
      );
    } else if (addCellType == AddCellType.image_text_for_refund) {
      return _image_text_for_refund_cell(context);
    } else {
      return _image_text_for_wish_create_cell(context);
    }
  }

  // 纯图片
  Widget _image_only_default_cell(
    BuildContext context, {
    required String packageImageName,
  }) {
    Widget childWidget = Image(
      image: AssetImage(
        packageImageName,
        package: 'app_images_action_image_pickers',
      ),
      width: 32,
      height: 32,
    );
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Color(0xFFBBBBBB), width: 0.5),
      ),
      child: childWidget,
    );
  }

  // 图片+"添加照片"文字(使用于愿望单创建)
  Widget _image_text_for_wish_create_cell(BuildContext context) {
    Widget childWidget = Column(
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

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Color(0xFFBBBBBB), width: 0.5),
      ),
      child: childWidget,
    );
  }

  // 图片+"添加照片"文字(使用于个人主页照片墙)
  Widget _image_text_for_user_photos_cell(
    BuildContext context,
  ) {
    Widget childWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(
            'assets/space_publish_plus.png',
            package: 'app_images_action_image_pickers',
          ),
          width: 15,
          height: 15,
        ),
        Container(height: 10),
        Center(
          child: Text(
            "丰富照片墙",
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8c8c8c),
              height: 1,
            ),
          ),
        )
      ],
    );
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x4cffffff),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Color(0xFFBBBBBB), width: 0.0),
      ),
      child: childWidget,
    );
  }

  //图片+文字（使用于申请退款）
  Widget _image_text_for_refund_cell(BuildContext context) {
    Widget childWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xfff3f3f3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/order/photo_icon.png",
            width: 19,
            height: 17,
          ),
          SizedBox(height: 3),
          Text(
            "上传凭证",
            style: TextStyle(
              color: const Color(0xff999999),
              height: 1.5,
              fontSize: 9,
            ),
          ),
          Text(
            "（最多3张）",
            style: TextStyle(
              color: const Color(0xff999999),
              height: 1.5,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xfff3f3f3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Color(0xFFBBBBBB), width: 0.0),
      ),
      child: childWidget,
    );
  }
}
