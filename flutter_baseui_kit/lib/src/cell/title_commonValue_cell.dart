// 包含标题文本title，值视图valueWidget、箭头类型 的视图
import 'package:flutter/material.dart';

import '../../flutter_baseui_kit_adapt.dart';

typedef ClickCellCallback = void Function({int? section, int? row});

enum TableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

// ignore: non_constant_identifier_names
double cell_constraints_minHeight =
    44.h_pt_cj; // cell的最小高度，如果未设置默认44pt，如果cell内容过长，则高度会自动增加

class ImageTitleCommonValueTableViewCell extends StatelessWidget {
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;

  final double? leftMaxWidth;
  final double? rightMaxWidth;
  final double? leftRightSpacing;

  // 左侧-图片
  final ImageProvider? imageProvider; // 图片(默认null时候，imageWith大于0时候才有效)
  final double? imageWith; // 图片宽高(默认null，非大于0时候，图片没位置)
  final double? imageTitleSpace; // 图片与标题间距(图片存在时候才有效)
  // 左侧-文本
  final String title; // 主文本
  final String? titlePrompt; // 标题的说明语（此值为空时候，视图会自动隐藏）
  final int? titlePromptMaxLines; // 标题的说明语的最大行数(为null时候，默认1)
  final TextStyle? titleTextStyle; // 主文本的 TextStyle
  final TextStyle? titlePromptTextStyle; // 标题的说明语的 TextStyle
  // 右侧-值视图
  final Widget? Function(BuildContext context, {required bool canExpanded})
      valueWidgetBuilder; // 值视图（此值为空时候，视图会自动隐藏）
  // 右侧-箭头
  final TableViewCellArrowImageType? arrowImageType; // 箭头类型(默认none)
  final Padding? Function()? arrowImagePaddingWidgetBuilder; // 箭头的自定义视图

  final int? section;
  final int? row;
  final ClickCellCallback? onTapCell; // cell 的点击
  final ClickCellCallback? onDoubleTapCell; // cell 的双击
  final ClickCellCallback? onLongPressCell; // cell 的长按

  const ImageTitleCommonValueTableViewCell({
    Key? key,
    this.height, // cell 的高度(内部已限制最小高度为44,要更改请设置 constraints)
    this.constraints,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.leftMaxWidth, // 限制左侧的最大宽度(左右两侧都未设置最大宽度时候，默认左边给完，剩下全给右边)
    this.rightMaxWidth, // 限制右侧的最大宽度(左右两侧都未设置最大宽度时候，默认左边给完，剩下全给右边)
    this.leftRightSpacing, // 左右两侧视图的间距(默认未未设置时候为0)
    this.imageProvider,
    this.imageWith,
    this.imageTitleSpace,
    required this.title,
    this.titlePrompt,
    this.titlePromptMaxLines,
    this.titleTextStyle,
    this.titlePromptTextStyle,
    required this.valueWidgetBuilder,
    this.arrowImageType = TableViewCellArrowImageType.none,
    this.arrowImagePaddingWidgetBuilder,
    this.section,
    this.row,
    this.onTapCell,
    this.onDoubleTapCell,
    this.onLongPressCell,
  }) : //assert(leftMaxWidth > 0 || rightMaxWidth > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return cellWidget(context);
  }

  Widget cellWidget(BuildContext context) {
    return GestureDetector(
      child: _cellContainer(context),
      onTap: () {
        if (null != this.onTapCell) {
          this.onTapCell!(section: this.section, row: this.row);
        }
      },
      onLongPress: () {
        if (null != this.onLongPressCell) {
          this.onLongPressCell!(section: this.section, row: this.row);
        }
      },
      onDoubleTap: () {
        if (null != this.onDoubleTapCell) {
          this.onDoubleTapCell!(section: this.section, row: this.row);
        }
      },
    );
  }

  Widget _leftWidget(BuildContext context, {bool canExpanded = false}) {
    List<Widget> leftRowWidgets = [];

    // 添加valueWidget到rowWidgets中
    // 判断是否添加图片，存在则添加到rowWidgets中
    if (imageWith != null && imageWith! > 0 && imageProvider != null) {
      Image image = Image(
        image: imageProvider!,
        width: imageWith,
        height: imageWith,
        fit: BoxFit.contain,
      );
      leftRowWidgets.add(image);
      leftRowWidgets.add(Container(width: imageTitleSpace ?? 0));
    }

    if (canExpanded == true) {
      leftRowWidgets.add(Expanded(child: _titleAndTitlePromptWidget()));
    } else {
      leftRowWidgets.add(_titleAndTitlePromptWidget());
    }

    return Container(
      // color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: leftRowWidgets,
      ),
    );
  }

  Widget _rightWidget(BuildContext context, {bool canExpanded = false}) {
    List<Widget> rightRowWidgets = [];

    // 添加valueWidget到rowWidgets中

    if (this.valueWidgetBuilder(context, canExpanded: canExpanded) != null) {
      Widget valueWidget =
          this.valueWidgetBuilder(context, canExpanded: canExpanded)!;
      if (canExpanded == true) {
        rightRowWidgets.add(Expanded(child: valueWidget));
      } else {
        rightRowWidgets.add(valueWidget);
      }
      // rightRowWidgets.add(Expanded(child: valueWidget));
      // rightRowWidgets.add(
      //   Expanded(
      //     child: Container(
      //       color: Colors.red,
      //       width: 100,
      //       height: 30,
      //       // child: valueWidget,
      //     ),
      //   ),
      // );
      // rightRowWidgets.add(
      //   Container(
      //     color: Colors.red,
      //     width: 100,
      //     height: 30,
      //   ),
      // );
    }

    // 判断是否添加箭头，存在则添加到rowWidgets中
    if (this.arrowImageType != TableViewCellArrowImageType.none) {
      rightRowWidgets.add(_arrowImagePaddingWidget(this.arrowImageType));
    }
    if (rightRowWidgets.length == 0) {
      rightRowWidgets.add(Container());
    }
    return Container(
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rightRowWidgets,
      ),
    );
  }

  Widget _cellContainer(BuildContext context) {
    List<Widget> children = [];
    if (leftMaxWidth != null && leftMaxWidth! > 0) {
      children = [
        Container(
          width: leftMaxWidth,
          child: _leftWidget(context, canExpanded: true),
        ),
        Container(width: leftRightSpacing ?? 0),
        Expanded(child: _rightWidget(context, canExpanded: true)),
      ];
    } else if (rightMaxWidth != null && rightMaxWidth! > 0) {
      children = [
        Expanded(child: _leftWidget(context, canExpanded: true)),
        Container(width: leftRightSpacing ?? 0),
        Container(
          width: rightMaxWidth,
          child: _rightWidget(context, canExpanded: true),
        ),
      ];
    } else {
      // 左右两侧都未设置最大宽度时候，默认左边给完，剩下全给右边
      children = [
        _leftWidget(context, canExpanded: false),
        Container(width: leftRightSpacing ?? 0),
        Expanded(child: _rightWidget(context, canExpanded: true)),
      ];
    }

    return Container(
      height: this.height,
      constraints: this.constraints ??
          BoxConstraints(minHeight: cell_constraints_minHeight),
      padding: this.padding,
      margin: this.margin,
      decoration: this.decoration ??
          BoxDecoration(
            color: this.color ?? Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  // 主文本及其下方的主文本的副文本
  Widget _titleAndTitlePromptWidget() {
    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左边文本的上面主文本
          _mainText(),
          // 左边文本的下面副文本
          _titlePromptWidget(),
        ],
      ),
    );
  }

  // 标题
  Widget _mainText() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: titleTextStyle ??
            TextStyle(
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w400,
              color: Color(0xff404040),
              fontSize: 13.f_pt_cj,
              // height: 1,
            ),
      ),
    );
  }

  // 标题的说明语
  Widget _titlePromptWidget() {
    if (titlePrompt == null || titlePrompt!.isEmpty) {
      return Container();
    }

    // 注意：如果发现此视图超出边界，一般情况是因为未设置 leftMaxWidth, 也未设置 rightMaxWidth,导致在左边不会自动伸缩的情况下，左边右超出长度。解决方法，设置 leftMaxWidth 或 rightMaxWidth 之一即可。
    return Text(
      titlePrompt!,
      textAlign: TextAlign.left,
      maxLines: titlePromptMaxLines ?? 1,
      overflow: TextOverflow.ellipsis,
      style: titlePromptTextStyle ??
          TextStyle(
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w400,
            color: Color(0xff404040),
            fontSize: 13.f_pt_cj,
            // height: 1,
          ),
    );
  }

  // 箭头
  Padding _arrowImagePaddingWidget(
      TableViewCellArrowImageType? arrowImageType) {
    Padding? customPadding = this.arrowImagePaddingWidgetBuilder?.call();
    if (customPadding != null) {
      return customPadding;
    }
    return arrwoImageWidget(arrowImageType: arrowImageType);
  }

  static Padding arrwoImageWidget({
    TableViewCellArrowImageType? arrowImageType,
    Color? imageColor,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w_pt_cj, 0, 0, 0),
      child: Image(
        image: AssetImage(
          'assets/arrow_right.png',
          package: 'flutter_baseui_kit',
        ),
        width: 5.w_pt_cj,
        height: 18.h_pt_cj,
        fit: BoxFit.contain,
        color: imageColor,
      ),
    );
    // return Container(
    //   // color: Colors.blue,
    //   child: Image(
    //     image: const AssetImage(
    //       'assets/arrow_right.png',
    //       package: 'flutter_baseui_kit',
    //     ),
    //     width: 6.w_bj,
    //     height: 18.h_bj,
    //     fit: BoxFit.contain,
    //   ),
    // );
  }
}
