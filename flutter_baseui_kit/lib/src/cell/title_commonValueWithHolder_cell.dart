// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import './title_commonValue_cell.dart';
export './title_commonValue_cell.dart' show TableViewCellArrowImageType;

import '../../flutter_baseui_kit_adapt.dart';

class ImageTitleCommonValueWithHolderTableViewCell
    extends ImageTitleCommonValueTableViewCell {
  final String? valuePlaceHodler; // 值文本占位符(默认null，不显示)
  final TextStyle? valuePlaceHodlerTextStyle; // 值文本的style(默认字体大小16)

  ImageTitleCommonValueWithHolderTableViewCell({
    Key? key,
    double? height, // cell 的高度(内部已限制最小高度为44,要更改请设置 constraints)
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Decoration? decoration,
    double? leftMaxWidth,
    double? rightMaxWidth,
    double? leftRightSpacing,

    // 左侧-图片
    ImageProvider? imageProvider, // 图片(默认null时候，imageWith大于0时候才有效)
    double? imageWith, // 图片宽高(默认null，非大于0时候，图片没位置)
    double? imageTitleSpace, // 图片与标题间距(图片存在时候才有效)
    // 左侧-文本
    required String title, // 主文本
    String? titlePrompt, // 标题的说明语（此值为空时候，视图会自动隐藏）
    int? titlePromptMaxLines, // 标题的说明语的最大行数(为null时候，默认1)
    TextStyle? titleTextStyle, // 主文本的 TextStyle
    TextStyle? titlePromptTextStyle, // 标题的说明语的 TextStyle
    // 右侧-值视图
    required Widget? Function(BuildContext context, {required bool canExpanded})
        valueWidgetBuilder, // 值视图（此值为空时候，视图会自动隐藏）
    this.valuePlaceHodler, // 值文本占位符(默认null，不显示)，且此值必须当 valueWidgetBuilder 为null才显示
    this.valuePlaceHodlerTextStyle, // 值文本的style(默认字体大小16)
    // 右侧-箭头
    TableViewCellArrowImageType? arrowImageType, // 箭头类型(默认none)
    Padding? Function()? arrowImagePaddingWidgetBuilder, // 箭头的自定义视图

    int? section,
    int? row,
    ClickCellCallback? onTapCell, // cell 的点击
    ClickCellCallback? onDoubleTapCell, // cell 的双击
    ClickCellCallback? onLongPressCell, // cell 的长按
  }) : super(
          key: key,
          height: height,
          constraints: constraints,
          padding: padding,
          margin: margin,
          color: color,
          decoration: decoration,
          leftMaxWidth: leftMaxWidth,
          rightMaxWidth: rightMaxWidth,
          leftRightSpacing: leftRightSpacing,
          imageProvider: imageProvider,
          imageWith: imageWith ?? 22.w_pt_cj,
          imageTitleSpace: imageTitleSpace ?? 10.w_pt_cj,
          title: title,
          titlePrompt: titlePrompt,
          titlePromptMaxLines: titlePromptMaxLines,
          titleTextStyle: titleTextStyle,
          titlePromptTextStyle: titlePromptTextStyle,
          valueWidgetBuilder: (BuildContext bContext,
              {required bool canExpanded}) {
            bool existTextValuePlaceHodler =
                valuePlaceHodler != null && valuePlaceHodler.isNotEmpty;

            Widget? valueWidget =
                valueWidgetBuilder(bContext, canExpanded: canExpanded);
            if (valueWidget == null && existTextValuePlaceHodler == true) {
              return HolderTableViewCellHolderWidget(
                valuePlaceHodler: valuePlaceHodler,
                valuePlaceHodlerTextStyle: valuePlaceHodlerTextStyle,
              );
            } else {
              return valueWidget;
            }
          },
          arrowImageType: arrowImageType,
          arrowImagePaddingWidgetBuilder: arrowImagePaddingWidgetBuilder,
          section: section,
          row: row,
          onTapCell: onTapCell,
          onDoubleTapCell: onDoubleTapCell,
          onLongPressCell: onLongPressCell,
        );
}

// ignore: must_be_immutable
class HolderTableViewCellHolderWidget extends StatelessWidget {
  final String? valuePlaceHodler; // 值文本占位符(默认null，不显示)
  TextStyle? valuePlaceHodlerTextStyle;

  HolderTableViewCellHolderWidget({
    Key? key,
    this.valuePlaceHodler,
    this.valuePlaceHodlerTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String showText;

    if (valuePlaceHodler != null) {
      showText = valuePlaceHodler!;

      if (valuePlaceHodlerTextStyle == null) {
        valuePlaceHodlerTextStyle = TextStyle(
          color: Color(0xff8b8b8b),
          fontSize: 13.f_pt_cj,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          //height: 1,
        );
      }
    } else {
      showText = "";
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: BoxConstraints(maxWidth: 180),
      color: Colors.transparent,
      child: Text(
        showText,
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: valuePlaceHodlerTextStyle,
      ),
    );
  }
}
