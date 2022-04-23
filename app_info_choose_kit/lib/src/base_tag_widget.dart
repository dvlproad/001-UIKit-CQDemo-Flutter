import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import '../app_info_choose_kit_adapt.dart';

class BaseTagWidget extends StatelessWidget {
  final Color backgroundColor;

  ImageProvider buttonImageProvider;
  String buttonText;
  void Function() onTap;

  bool showDeleteIcon; // 是否显示删除按钮
  Widget Function() customDeleteIconBuilder; // 自定义删除按钮(默认null,null时候有默认图片)
  GestureTapCallback onTapDelete; // 点击删除按钮执行的操作(如果有显示删除按钮的情况下)
  Widget
      contentWidgetWhenShowDelete; // 显示删除按钮情况下的 contentWidget 样式(默认null,即使用buttonText)

  BaseTagWidget({
    Key key,
    this.backgroundColor,
    this.buttonImageProvider,
    this.buttonText,
    this.onTap,
    this.showDeleteIcon,
    this.customDeleteIconBuilder,
    this.onTapDelete,
    this.contentWidgetWhenShowDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textLabel = Text(
      buttonText,
      maxLines: 1,
      style: TextStyle(
        fontSize: 12.w_pt_cj,
        color: const Color(0xFFFFA54C),
        fontWeight: FontWeight.w400,
      ),
    );
    if (showDeleteIcon == true) {
      textLabel = contentWidgetWhenShowDelete;
    }
    return LeftImageTextDeleteButton(
      key: key,
      onTap: onTap,
      bgColor: backgroundColor ?? Colors.blue,
      cornerRadius: 24.w_pt_cj,
      height: 30.h_pt_cj,
      padding: EdgeInsets.only(left: 10.w_pt_cj, right: 10.w_pt_cj),
      iconHeight: 22.w_pt_cj,
      imageView: Image(
        image: buttonImageProvider,
        width: 22.w_pt_cj,
        height: 22.h_pt_cj,
        // color: Colors.red,
      ),
      iconTitleSpace: 5.w_pt_cj,
      textLabel: textLabel,
      showDeleteIcon: showDeleteIcon,
      customDeleteIconBuilder: customDeleteIconBuilder,
      onTapDelete: onTapDelete,
    );
  }
}
