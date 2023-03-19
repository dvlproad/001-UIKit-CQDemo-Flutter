/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-16 19:35:00
 * @Description: tag 视图的基类
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import '../app_info_choose_kit_adapt.dart';

/*
class BaseTextTagWidget extends BaseTagWidget {
  BaseTextTagWidget({
    Key key,
    double width,
    BoxConstraints constraints,
    Color backgroundColor,
    ImageProvider buttonImageProvider,
    String buttonText,
    bool shouldExpandedButtonText = false,
    void Function() onTap,
    bool showDeleteIcon = false,
    GestureTapCallback onTapDelete,
    this.contentWidgetWhenShowDelete,
  }) : super(
          key: key,
          width: width,
          shouldExpandedButtonText: shouldExpandedButtonText,
          constraints: constraints,
          buttonText: buttonText,
          buttonImageProvider: buttonImageProvider,
          contentWidgetWhenShowDelete: BaseTagText(buttonText),
          onTap: onTap,
          showDeleteIcon: showDeleteIcon,
          onTapDelete: onTapDelete,
        );
}
*/

class BaseTagText extends StatelessWidget {
  static double height = 24.h_pt_cj;

  final String data;

  const BaseTagText(
    this.data, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'PingFang SC',
        fontSize: 11.w_pt_cj,
        color: const Color(0xFF8B8B8B),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class BaseTagWidget extends StatelessWidget {
  final double width;
  final BoxConstraints constraints;
  final Color backgroundColor;

  ImageProvider buttonImageProvider;
  String buttonText;
  final bool shouldExpandedButtonText;
  void Function() onTap;

  bool showDeleteIcon; // 是否显示删除按钮
  Widget Function() customDeleteIconBuilder; // 自定义删除按钮(默认null,null时候有默认图片)
  GestureTapCallback onTapDelete; // 点击删除按钮执行的操作(如果有显示删除按钮的情况下)
  Widget
      contentWidgetWhenShowDelete; // 显示删除按钮情况下的 contentWidget 样式(默认null,即使用buttonText)

  BaseTagWidget({
    Key key,
    this.width,
    this.constraints,
    this.backgroundColor,
    this.buttonImageProvider,
    this.buttonText,
    this.shouldExpandedButtonText = false,
    this.onTap,
    this.showDeleteIcon,
    this.customDeleteIconBuilder,
    this.onTapDelete,
    this.contentWidgetWhenShowDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
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
    */

    Widget textLabel = contentWidgetWhenShowDelete;
    double height = BaseTagText.height;
    double iconHeight = 16.w_pt_cj;
    double iconEdge = 8.w_pt_cj;

    return LeftImageTextDeleteButton(
      key: key,
      width: width,
      constraints: constraints,
      onTap: onTap,
      bgColor: backgroundColor,
      cornerRadius: height / 2.0,
      height: height,
      padding: EdgeInsets.only(left: iconEdge, right: iconEdge),
      iconHeight: iconHeight,
      imageView: Image(
        image: buttonImageProvider,
        width: iconHeight,
        height: iconHeight,
        // color: Colors.red,
      ),
      iconTitleSpace: 2.w_pt_cj,
      textLabel: textLabel,
      shouldExpandedTextLabel: shouldExpandedButtonText,
      showDeleteIcon: showDeleteIcon,
      customDeleteIconBuilder: customDeleteIconBuilder,
      onTapDelete: onTapDelete,
    );
  }
}
