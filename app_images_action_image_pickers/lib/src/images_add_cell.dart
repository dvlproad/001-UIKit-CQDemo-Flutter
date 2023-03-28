// ignore_for_file: constant_identifier_names, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-17 19:41:23
 * @Description: 图片列表添加Cell
 */
import 'package:flutter/material.dart';

enum AddCellType {
  defalut_add, // ➕图片
  image_only_default, // 拍照图片(使用于愿望单创建)
  image_text_default, // 图片+"添加照片"文字(使用于愿望单创建)
  image_text_for_user_photos, // 图片+"添加照片"文字(使用于个人主页照片墙)
  image_text_for_refund, //申请退款样式
  image_text_for_evaluate, //商品评价
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
        backgroundColor: Color(0xFFF0F0F0),
        packageImageName: 'assets/icon_add_default.png',
        packageImageColor: Colors.white,
        packageBorderColor: Color(0xFFF0F0F0),
        packageBorderWidth: 1.0,
      );
    } else if (addCellType == AddCellType.defalut_add) {
      return _image_only_default_cell(
        context,
        packageImageName: 'assets/icon_add_default.png',
      );
    } else if (addCellType == AddCellType.image_text_for_refund) {
      return _image_text_for_refund_cell(context);
    } else if (addCellType == AddCellType.image_text_for_evaluate) {
      return _image_text_for_evaluate_cell(context);
    } else {
      return _image_text_for_wish_create_cell(context);
    }
  }

  // 纯图片
  Widget _image_only_default_cell(
    BuildContext context, {
    Color backgroundColor = Colors.white,
    required String packageImageName,
    Color? packageImageColor,
    Color packageBorderColor = const Color(0xFFBBBBBB),
    double packageBorderWidth = 0.5,
  }) {
    Widget childWidget = Image(
      image: AssetImage(
        packageImageName,
        package: 'app_images_action_image_pickers',
      ),
      color: packageImageColor,
      width: 32,
      height: 32,
    );
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: packageBorderColor,
          width: packageBorderWidth,
        ),
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
        const Image(
          image: AssetImage(
            'assets/icon_add_photo.png',
            package: 'app_images_action_image_pickers',
          ),
          width: 32,
          height: 32,
        ),
        Container(height: 10),
        const Center(
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
      children: const [
        Image(
          image: AssetImage(
            'assets/user_photo_publish.png',
            package: 'app_images_action_image_pickers',
          ),
          width: 16,
          height: 16,
        ),
        // Container(height: 10),
        // Center(
        //   child: Text(
        //     "丰富照片墙",
        //     style: TextStyle(
        //       fontSize: 11,
        //       color: Color(0xFF8c8c8c),
        //       height: 1,
        //     ),
        //   ),
        // )
      ],
    );
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xfff0f0f0),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: const Color(0xfff0f0f0), width: 0.0),
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
          const SizedBox(height: 3),
          const Text(
            "上传凭证",
            style: TextStyle(
              color: Color(0xff999999),
              height: 1.5,
              fontSize: 9,
            ),
          ),
          const Text(
            "（最多3张）",
            style: TextStyle(
              color: Color(0xff999999),
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
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: const Color(0xFFBBBBBB), width: 0.0),
      ),
      child: childWidget,
    );
  }

  Widget _image_text_for_evaluate_cell(BuildContext context) {
    Widget childWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xfff3f3f3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage(
              'assets/icon_add_photo.png',
              package: 'app_images_action_image_pickers',
            ),
            width: 32,
            height: 32,
          ),
          // Container(height: 10),
          // Center(
          //   child: Text(
          //     "添加照片/视频",
          //     style: TextStyle(
          //       fontSize: 12,
          //       color: Color(0xFFB2B2B2),
          //       height: 1,
          //     ),
          //   ),
          // )
        ],
      ),
    );
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xfff3f3f3),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: const Color(0xFFBBBBBB), width: 0.0),
      ),
      child: childWidget,
    );
  }
}
