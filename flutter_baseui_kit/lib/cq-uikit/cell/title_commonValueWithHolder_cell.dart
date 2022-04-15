// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';
export './title_commonValue_cell.dart' show TableViewCellArrowImageType;
// import '../text/text.dart';

class BJHTitleCommonValueWithHolderTableViewCell
    extends BJHTitleCommonValueTableViewCell {
  String valuePlaceHodler; // 值文本占位符(默认null，不显示)
  Color valuePlaceHodlerColor; // 值文本占位符文字颜色
  double valuePlaceHodlerFontSize; // 值文本的字体大小(默认30)

  BJHTitleCommonValueWithHolderTableViewCell({
    Key key,
    double height, // cell 的高度
    double leftRightPadding, // cell 内容的左右间距(未设置时候，默认20)
    Color color,

    // 左侧-图片
    ImageProvider imageProvider, // 图片(默认null时候，imageWith大于0时候才有效)
    double imageWith, // 图片宽高(默认null，非大于0时候，图片没位置)
    double imageTitleSpace, // 图片与标题间距(图片存在时候才有效)
    // 左侧-文本
    String title, // 主文本
    // 右侧-值视图
    Widget Function(BuildContext context)
        valueWidgetBuilder, // 值视图（此值为空时候，视图会自动隐藏）
    String
        valuePlaceHodler, // 值文本占位符(默认null，不显示)，且此值必须当 valueWidgetBuilder 为null才显示
    Color valuePlaceHodlerColor, // 值文本占位符文字颜色
    double valuePlaceHodlerFontSize, // 值文本的字体大小(默认30)
    // 右侧-箭头
    TableViewCellArrowImageType arrowImageType, // 箭头类型(默认none)

    int section,
    int row,
    ClickCellCallback clickCellCallback, // cell 的点击
  }) : super(
          key: key,
          height: height,
          leftRightPadding: leftRightPadding ?? 0,
          color: color,
          imageProvider: imageProvider,
          imageWith: imageWith ?? 22.w_pt_cj,
          imageTitleSpace: imageTitleSpace ?? 10.w_pt_cj,
          title: title,
          valueWidgetBuilder: (BuildContext bContext) {
            bool existTextValuePlaceHodler =
                valuePlaceHodler != null && valuePlaceHodler.isNotEmpty;

            Widget valueWidget = valueWidgetBuilder(bContext);
            if (valueWidget == null && existTextValuePlaceHodler == true) {
              return BJHTitleCommonValueWithHolderTableViewCell
                  .valuePlaceHodlerWidget(
                valuePlaceHodler: valuePlaceHodler,
                valuePlaceHodlerColor:
                    valuePlaceHodlerColor ?? const Color(0xFFC1C1C1),
                valuePlaceHodlerFontSize: valuePlaceHodlerFontSize,
              );
            } else {
              return valueWidget;
            }
          },
          arrowImageType: arrowImageType,
          section: section,
          row: row,
          clickCellCallback: clickCellCallback,
        );

  // 占位文本
  static Widget valuePlaceHodlerWidget({
    String valuePlaceHodler, // 值文本占位符(默认null，不显示)
    Color valuePlaceHodlerColor, // 值文本占位符文字颜色
    double valuePlaceHodlerFontSize, // 值文本的字体大小(默认30)
  }) {
    String showText;
    Color showTextColor = Color(0xff999999);

    if (valuePlaceHodler != null) {
      showText = valuePlaceHodler;
      showTextColor = valuePlaceHodlerColor ?? Color(0xC1C1C1);
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
        style: TextStyle(
          color: showTextColor,
          fontFamily: 'PingFang SC',
          fontSize: valuePlaceHodlerFontSize ?? 16.f_pt_cj,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    );
  }
}
