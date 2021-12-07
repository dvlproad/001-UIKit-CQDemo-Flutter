// 包含标题文本title，值视图valueWidget、箭头类型 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './utils.dart';

typedef ClickCellCallback = void Function(int section, int row);

enum TableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

class BJHTitleCommonValueTableViewCell extends StatelessWidget {
  final String title; // 主文本
  final Widget valueWidget; // 值视图（此值为空时候，视图会自动隐藏）
  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback; // cell 的点击

  BJHTitleCommonValueTableViewCell({
    Key key,
    this.title,
    this.valueWidget,
    this.arrowImageType = TableViewCellArrowImageType.none,
    this.section,
    this.row,
    this.clickCellCallback,
  }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _MainSubArrowTableViewCellState();
//   }
// }

// class _MainSubArrowTableViewCellState extends State<MainSubArrowTableViewCell> {
  @override
  Widget build(BuildContext context) {
    return cellWidget();
  }

  Widget cellWidget() {
    return GestureDetector(
      child: _cellContainer(),
      onTap: _onTapCell,
    );
  }

  void _onTapCell() {
    if (null != this.clickCellCallback) {
      this.clickCellCallback(this.section, this.row);
    }
  }

  Widget _cellContainer() {
    List<Widget> rowWidgets = [];

    // 添加主文本到rowWidgets中(肯定存在主文本)
    rowWidgets.add(
      Expanded(
        child: _mainText(),
      ),
    );

    // 添加valueWidget到rowWidgets中
    if (null != this.valueWidget) {
      rowWidgets.add(this.valueWidget);
    }

    // 判断是否添加箭头，存在则添加到rowWidgets中
    if (this.arrowImageType != TableViewCellArrowImageType.none) {
      rowWidgets.add(SizedBox(width: Adapt.px(30)));
      rowWidgets.add(_arrowImage());
    }

    return Container(
      width: Adapt.screenW(),
      height: Adapt.px(100),
      padding: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowWidgets,
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
          color: Color(0xff222222),
          fontSize: Adapt.px(30),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 箭头
  Widget _arrowImage() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      // child: Image(
      //   image: AssetImage('images/mine/arrow_right.png'),
      //   width: Adapt.px(17),
      //   height: Adapt.px(32),
      // ),
      child: Text('箭头'),
    );
  }
}

class RoundImage extends StatelessWidget {
  final double size;

  final String networkSrc;

  RoundImage({
    Key key,
    this.size,
    this.networkSrc =
        'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        this.networkSrc,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
      // child: CachedNetworkImage(
      //   imageUrl: this.networkSrc,
      //   errorWidget: (context, url, error) => Container(),
      //   width: Adapt.px(size),
      //   height: Adapt.px(size),
      //   fit: BoxFit.cover,
      // ),
    );
  }
}

// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
class BJHTitleTextValueCell extends StatelessWidget {
  final String title; // 标题
  final String textValue; // 值文本（此值为空时候，视图会自动隐藏）
  bool textThemeIsRed = false; // 值文本是否是红色主题(不设置即默认灰色)
  bool addDotForValue = false; // 是否在value前添加·点(不设置即默认不添加，如果添加则点的颜色和文本颜色一直)
  void Function() onTap; // 点击事件

  BJHTitleTextValueCell({
    Key key,
    this.title,
    this.textValue,
    this.textThemeIsRed,
    this.addDotForValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      title: this.title,
      valueWidget: _textValueWidget(),
      arrowImageType: TableViewCellArrowImageType.arrowRight,
      clickCellCallback: (section, row) {
        this.onTap();
      },
    );
  }

  Widget _textValueWidget() {
    List<Widget> widgets = [];

    if (this.addDotForValue == true) {
      widgets.add(_dot());
      widgets.add(SizedBox(width: Adapt.px(20)));
    }

    Color textColor =
        this.textThemeIsRed == true ? Color(0xffCD3F49) : Color(0xff999999);
    if (_subText(textColor) != null) {
      widgets.add(_subText(textColor));
    }

    return Row(
      children: widgets,
    );
  }

  // 文本前面的点(一般不添加)
  Widget _dot() {
    return Container(
      width: Adapt.px(14),
      height: Adapt.px(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(7))),
          border: Border.all(
            color: const Color(0xffCD3F49),
            width: Adapt.px(7),
            style: BorderStyle.solid,
          )),
    );
  }

  // 副文本
  Widget _subText(Color textColor) {
    // 判断是否添加副文本，存在才构建视图
    if (null == this.textValue || this.textValue.length == 0) {
      return null;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.textValue ?? '',
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: Adapt.px(30),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// 包含标题文本title，值输入框textInputValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
class BJHTitleTextInputValueCell extends StatelessWidget {
  final String title; // 标题
  final String textInputValue; // 值文本（此值为空时候，视图会自动隐藏）
  final TextEditingController controller;
  void Function() onTap; // 点击事件

  BJHTitleTextInputValueCell({
    Key key,
    this.title,
    this.textInputValue,
    this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      title: this.title,
      valueWidget: _textInputValueWidget(),
      arrowImageType: TableViewCellArrowImageType.arrowRight,
      clickCellCallback: (section, row) {
        this.onTap();
      },
    );
  }

  Widget _textInputValueWidget() {
    return TextField(
      // controller: controller,
      textAlign: TextAlign.start,
      maxLength: 100,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: "小区楼栋/乡村名称",
        contentPadding: EdgeInsets.only(left: 1, right: 1, top: 13),
        border: InputBorder.none,
        hintStyle: TextStyle(color: Color(0xFF767A7D), fontSize: 13),
      ),
    );
    // return Row(
    //   children: [_textField()],
    // );
  }

  // 输入框
  Widget _textField() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      height: 44,
      // child: Text(
      //   this.textInputValue ?? 'textInputValue',
      //   textAlign: TextAlign.right,
      //   overflow: TextOverflow.ellipsis,
      //   style: TextStyle(
      //     color: Colors.red,
      //     fontSize: Adapt.px(30),
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
      child: TextField(),
      //   child: TextField(
      //     // controller: controller,
      //     textAlign: TextAlign.start,
      //     // maxLength: 100,
      //     // maxLines: 5,
      //     // decoration: const InputDecoration(
      //     //   hintText: "小区楼栋/乡村名称",
      //     //   contentPadding: EdgeInsets.only(left: 1, right: 1, top: 13),
      //     //   border: InputBorder.none,
      //     //   hintStyle: TextStyle(color: Color(0xFF767A7D), fontSize: 13),
      //     // ),
      //   ),
    );
  }
}

// 包含标题文本title，值图片imageValue、箭头类型固定为向右 的视图
class BJHTitleImageValueCell extends StatelessWidget {
  final String title; // 标题
  final String imageValue; // 值图片（此值为空时候，视图会自动隐藏）
  void Function() onTap; // 点击事件

  BJHTitleImageValueCell({
    Key key,
    this.title,
    this.imageValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      title: this.title,
      valueWidget: _imageValueWidget(),
      arrowImageType: TableViewCellArrowImageType.arrowRight,
      clickCellCallback: (section, row) {
        this.onTap();
      },
    );
  }

  // 图片视图
  Widget _imageValueWidget() {
    if (null == this.imageValue || this.imageValue.length == 0) {
      return null;
    }

    //bool isNetworkImage = this.imageValue.startsWith(RegExp(r'https?:')); // 是否是网络图片

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      // child: Image.asset("images/mine/qrcode.png", width: 34, height: 34),
      child: Text('图片'),
      // child: RoundImage(
      //   size: 34,
      //   networkSrc: this.imageValue,
      // ),
    );
  }
}
