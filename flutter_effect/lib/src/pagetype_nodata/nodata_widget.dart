import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './empty_imageAboveText_widget.dart';
import '../appbar/appbar.dart';

class StateNodataWidget extends StatefulWidget {
  final bool needAppBar; // 是否需要为你补充上导航栏(默认不需要)
  final VoidCallback
      onNavBackTap; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)
  final Color color; // 背景颜色
  final ImageProvider image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  final String mainTitle;
  final String subTitle;
  final Widget buttonWidget;

  const StateNodataWidget({
    Key key,
    this.needAppBar = false,
    this.onNavBackTap,
    this.color,
    this.image,
    this.mainTitle = '很抱歉，您暂无相关数据',
    this.subTitle = '去其他逛逛吧',
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
      Widget appBar = EasyAppBarWidget(
        title: '数据异常',
        onTap: widget.onNavBackTap,
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
      image: widget.image,
      mainTitle: widget.mainTitle,
      subTitle: widget.subTitle,
      buttonWidget: widget.buttonWidget,
    );
  }
}
