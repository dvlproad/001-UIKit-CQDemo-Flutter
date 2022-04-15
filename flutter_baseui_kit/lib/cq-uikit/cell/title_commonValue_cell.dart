// 包含标题文本title，值视图valueWidget、箭头类型 的视图
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';

typedef ClickCellCallback = void Function(int section, int row,
    {bool bIsLongPress});

enum TableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

class BJHTitleCommonValueTableViewCell extends StatelessWidget {
  final double height; // cell 的高度
  final double leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  final Color color;

  // 左侧-图片
  final ImageProvider imageProvider; // 图片(默认null时候，imageWith大于0时候才有效)
  final double imageWith; // 图片宽高(默认null，非大于0时候，图片没位置)
  final double imageTitleSpace; // 图片与标题间距(图片存在时候才有效)
  // 左侧-文本
  final String title; // 主文本
  // 右侧-值视图
  final Widget Function(BuildContext context)
      valueWidgetBuilder; // 值视图（此值为空时候，视图会自动隐藏）
  // 右侧-箭头
  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback; // cell 的点击

  const BJHTitleCommonValueTableViewCell({
    Key key,
    this.height,
    this.leftRightPadding,
    this.color,
    this.imageProvider,
    this.imageWith,
    this.imageTitleSpace,
    @required this.title,
    this.valueWidgetBuilder,
    this.arrowImageType = TableViewCellArrowImageType.none,
    this.section,
    this.row,
    this.clickCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cellWidget(context);
  }

  Widget cellWidget(BuildContext context) {
    return GestureDetector(
      child: _cellContainer(context),
      onTap: () {
        _onTapCell(isLongPress: false);
      },
      onLongPress: () {
        _onTapCell(isLongPress: true);
      },
    );
  }

  void _onTapCell({bool isLongPress}) {
    if (null != this.clickCellCallback) {
      this.clickCellCallback(
        this.section,
        this.row,
        bIsLongPress: isLongPress,
      );
    }
  }

  Widget get _leftRowWidget {
    List<Widget> leftRowWidgets = [];

    // 添加valueWidget到rowWidgets中
    // 判断是否添加图片，存在则添加到rowWidgets中
    if (imageWith != null && imageWith > 0 && imageProvider != null) {
      Image image = Image(
        image: imageProvider,
        width: imageWith,
        height: imageWith,
      );
      leftRowWidgets.add(image);
      leftRowWidgets.add(Container(width: imageTitleSpace ?? 0));
    }

    leftRowWidgets.add(_mainText());

    return Row(children: leftRowWidgets);
  }

  Widget _rightRowWidget(BuildContext context) {
    List<Widget> rightRowWidgets = [];

    // 添加valueWidget到rowWidgets中

    if (null != this.valueWidgetBuilder) {
      Widget valueWidget = this.valueWidgetBuilder(context);
      rightRowWidgets.add(SizedBox(width: 5.w_pt_cj));
      rightRowWidgets.add(valueWidget);
    }

    // 判断是否添加箭头，存在则添加到rowWidgets中
    if (this.arrowImageType != TableViewCellArrowImageType.none) {
      rightRowWidgets.add(SizedBox(width: 15.w_pt_cj));
      rightRowWidgets.add(_arrowImage());
    }
    if (rightRowWidgets.length == 0) {
      rightRowWidgets.add(Container());
    }
    return Row(children: rightRowWidgets);
  }

  Widget _cellContainer(BuildContext context) {
    double leftRightPadding = this.leftRightPadding ?? 20.w_pt_cj;

    return Container(
      height: this.height ?? 44.w_pt_cj,
      padding: EdgeInsets.only(left: leftRightPadding, right: leftRightPadding),
      color: this.color ?? Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _leftRowWidget,
          // Expanded(
          //   child: Container(
          //     color: Colors.orange,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Row(
          //             children: [
          //               Expanded(child: Text('砥砺奋进代理费林德洛夫冻死了发动机')),
          //               Text('1'),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          _rightRowWidget(context),
        ],
      ),
    );
  }

  // 主文本
  Widget _mainText() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.title ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'PingFang SC',
          color: Color(0xff333333),
          fontSize: 16.f_pt_cj,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    );
  }

  // 箭头
  Widget _arrowImage() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Image(
        image:
            AssetImage('assets/arrow_right.png', package: 'flutter_baseui_kit'),
        width: 8.w_pt_cj,
        height: 16.h_pt_cj,
      ),
    );
  }
}
