/*
 * @Author: dvlproad
 * @Date: 2022-04-13 19:32:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:12:37
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './empty_imageAboveText_widget.dart';
import '../appbar/appbar.dart';

/* 使用示例
  return StateNodataWidget(
      buttonWidget: ThemeBorderButton(
        width: 110, // 不设置会根据内容自适应
        height: 35, // 不设置会根据内容自适应
        borderColorType: ThemeBGType.theme,
        title: '去看看',
        titleStyle: ButtonBoldTextStyle(fontSize: 13.0),
        cornerRadius: 17.5,
        onPressed: widget.errorRetry,
      ),
    );
*/

class StateNodataWidget extends StatefulWidget {
  final bool needAppBar;
  final VoidCallback? onNavBackTap;
  final Color? color;
  final ImageProvider? image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  final String? mainTitle;
  final String? subTitle;
  final Widget? buttonWidget;

  const StateNodataWidget({
    Key? key,
    this.needAppBar = false, // 是否需要为你补充上导航栏(默认不需要)
    this.onNavBackTap, //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)
    this.color, // 背景颜色
    this.image, // 默认值:AssetImage('assets/empty/no_data.png',package: 'flutter_effect',)
    this.mainTitle, // 默认值:'很抱歉，您暂无相关数据'
    this.subTitle, // 默认值:'去其他逛逛吧'
    this.buttonWidget,
  }) : super(key: key);

  @override
  _StateNodataWidgetState createState() => _StateNodataWidgetState();
}

class _StateNodataWidgetState extends State<StateNodataWidget> {
  @override
  Widget build(BuildContext context) {
    return _nodataView;
  }

  /// 无数据视图
  Widget get _nodataView {
    List<Widget> columnWidgets = [];

    if (widget.needAppBar) {
      Widget appBar = CommonAppBar(
        title: ToolBarTitleWidget(text: '数据异常'),
        leading: QuickToolBarImageActionWidget(onPressed: widget.onNavBackTap),
      );
      columnWidgets.add(appBar);
    }

    columnWidgets.add(
      Expanded(
        child: _nodataWidget,
      ),
    );

    return Column(
      children: columnWidgets,
    );
  }

  Widget get _nodataWidget {
    return EmptyWithImageAboveTextWidget(
      color: widget.color,
      image: widget.image ??
          AssetImage(
            'assets/empty/no_data.png',
            package: 'flutter_effect',
          ),
      mainTitle: widget.mainTitle ?? '很抱歉，您暂无相关数据',
      subTitle: widget.subTitle ?? '去其他逛逛吧',
      buttonWidget: widget.buttonWidget,
    );
  }
}
