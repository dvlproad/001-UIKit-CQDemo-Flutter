// 包含标题文本title，值图片imageValue、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';

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
      valueWidgetBuilder: (BuildContext bContext) => _imageValueWidget(),
      arrowImageType: TableViewCellArrowImageType.arrowRight,
      clickCellCallback: (section, row, {bIsLongPress}) {
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
      // child: Image.asset("images/mine/qrcode.png",
      //     width: AdaptCJHelper.setWidth(34), height: AdaptCJHelper.setWidth(34)),
      child: RoundImage(
        size: 34,
        networkSrc: this.imageValue,
      ),
    );
  }
}

class RoundImage extends StatelessWidget {
  final double size;

  final String networkSrc;

  const RoundImage({
    Key key,
    this.size,
    this.networkSrc =
        'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      // child: Image.network(
      //   this.networkSrc,
      //   width: size,
      //   height: size,
      //   fit: BoxFit.cover,
      // ),
      child: CachedNetworkImage(
        imageUrl: this.networkSrc,
        errorWidget: (context, url, error) => Container(),
        width: AdaptCJHelper.setWidth(size),
        height: AdaptCJHelper.setWidth(size),
        fit: BoxFit.cover,
      ),
    );
  }
}
