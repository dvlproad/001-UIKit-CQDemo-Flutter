/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-23 13:07:28
 * @Description: 包含标题文本title，值输入框textInputValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './title_commonValue_cell.dart';
import 'title_commonValueWithHolder_cell.dart';

import '../../flutter_baseui_kit_adapt.dart';

class ImageTitleTextInputValueCell extends StatelessWidget {
  final Color? color;
  final Decoration? decoration;
  final double? height; // cell 的高度(内部已限制最小高度为44,要更改请设置 constraints)
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? leftMaxWidth;
  final double? rightMaxWidth;
  final double? leftRightSpacing;

  // 左侧-图片
  final ImageProvider? imageProvider; // 图片(默认null时候，imageWith大于0时候才有效)
  final double? imageWith; // 图片宽高(默认null，非大于0时候，图片没位置)
  final double? imageTitleSpace; // 图片与标题间距(图片存在时候才有效)
  // 左侧-标题
  final String title; // 标题
  final String? titlePrompt; // 标题的说明语（此值为空时候，视图会自动隐藏）
  final int? titlePromptMaxLines; // 标题的说明语的最大行数(为null时候，默认1)
  final TextStyle? titleTextStyle; // 主文本的 TextStyle
  final TextStyle? titlePromptTextStyle; // 标题的说明语的 TextStyle

  // 右侧-值文本
  final TextEditingController? textValueController; // 值文本控制器（此值为空时候，视图会自动隐藏）
  final int? textValueMaxLines; // 值文本的最大行数(为null时候，默认1)
  final double? textValueFontSize; // 值文本的字体大小(默认30)
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final int? maxLength;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  // 右侧-值文本占位符
  final String? textValuePlaceHodler; // 值文本占位符(默认null，不显示)

  final TableViewCellArrowImageType? arrowImageType; // 箭头类型(默认none)
  final Padding? Function()? arrowImagePaddingWidgetBuilder; // 箭头的自定义视图

  final GestureTapCallback? onTap; // 点击事件

  ImageTitleTextInputValueCell({
    Key? key,
    this.color,
    this.decoration,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.leftMaxWidth, // 限制左侧的最大宽度(左右两侧都未设置最大宽度时候，请自己保证两边不会重叠)
    this.rightMaxWidth, // 限制右侧的最大宽度(左右两侧都未设置最大宽度时候，请自己保证两边不会重叠)
    this.leftRightSpacing, // 左右两侧视图的间距(默认未未设置时候为0)
    this.imageProvider,
    this.imageWith,
    this.imageTitleSpace,
    required this.title,
    this.titlePrompt,
    this.titlePromptMaxLines,
    this.titleTextStyle,
    this.titlePromptTextStyle,
    this.textValueController,
    this.textValueMaxLines,
    this.textValueFontSize,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.textValuePlaceHodler,
    this.onTap,
    this.arrowImageType,
    this.arrowImagePaddingWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ImageTitleCommonValueTableViewCell(
    //   title: this.title,
    //   valueWidgetBuilder: (BuildContext bContext,
    //           {required bool canExpanded}) =>
    //       _textInputValueWidget(bContext, canExpanded: canExpanded),
    //   arrowImageType: TableViewCellArrowImageType.arrowRight,
    //   onTapCell: ({int? section, int? row}) {
    //     if (this.onTap != null) {
    //       this.onTap!();
    //     }
    //   },
    // );
    return ImageTitleCommonValueWithHolderTableViewCell(
      color: this.color,
      decoration: this.decoration,
      height: this.height,
      constraints: this.constraints,
      padding: this.padding,
      margin: this.margin,
      leftMaxWidth: this.leftMaxWidth,
      rightMaxWidth: this.rightMaxWidth,
      leftRightSpacing: this.leftRightSpacing,
      imageProvider: this.imageProvider,
      imageWith: this.imageWith,
      imageTitleSpace: this.imageTitleSpace,
      title: this.title,
      titlePrompt: this.titlePrompt,
      titlePromptMaxLines: this.titlePromptMaxLines,
      titleTextStyle: this.titleTextStyle,
      titlePromptTextStyle: this.titlePromptTextStyle,
      // valuePlaceHodler: this.textValuePlaceHodler, // textInput 自己有 hintText 可使用
      valueWidgetBuilder: (BuildContext bContext, {bool canExpanded = false}) {
        // bool hasContent = this.textValue != null && this.textValue!.isNotEmpty;
        // if (hasContent == false) {
        //   return null;
        // }
        return _textInputValueWidget(bContext, canExpanded: canExpanded);
      },
      arrowImageType: arrowImageType ?? TableViewCellArrowImageType.arrowRight,
      arrowImagePaddingWidgetBuilder: arrowImagePaddingWidgetBuilder,
      onTapCell: ({int? section, int? row}) {
        if (this.onTap != null) {
          this.onTap!();
        }
      },
    );
  }

  Widget? _textInputValueWidget(
    BuildContext bContext, {
    bool canExpanded = false,
  }) {
    List<Widget> widgets = [];
    if (canExpanded == true) {
      widgets.add(Expanded(child: _textField()));
    } else {
      widgets.add(_textField());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  // 输入框
  Widget _textField() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      // color: Colors.red,
      constraints: this.constraints ??
          BoxConstraints(minHeight: cell_constraints_minHeight),
      child: TextField(
        keyboardType: keyboardType,
        textAlign: TextAlign.start,
        textInputAction: textInputAction,
        maxLength: maxLength,
        maxLines: maxLines,
        controller: textValueController,
        style: TextStyle(
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          fontSize: 14.f_pt_cj,
        ),
        autofocus: autofocus,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: this.textValuePlaceHodler,
          // hintStyle: TextStyle(color: Color(0xFF767A7D), fontSize: 13),
          // contentPadding: EdgeInsets.only(left: 1, right: 1, top: 13),
        ),
        inputFormatters: inputFormatters,
        onTap: onTap,
        onChanged: this.onChanged,
        onEditingComplete: this.onEditingComplete,
        onSubmitted: this.onSubmitted,
      ),
    );
  }
}
