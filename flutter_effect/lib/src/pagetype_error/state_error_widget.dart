/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:42:19
 * @Description: 错误视图
 */
import 'package:flutter/material.dart';
import '../pagetype_nodata/empty_imageAboveText_widget.dart';
import '../appbar/appbar.dart';

class StateErrorWidget extends StatefulWidget {
  final bool needAppBar;
  final VoidCallback? onNavBackTap;
  final Color? color;
  final ImageProvider? image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),

  final VoidCallback errorRetry;

  StateErrorWidget({
    Key? key,
    this.needAppBar = false, // 是否需要为你补充上导航栏(默认不需要)
    this.onNavBackTap, //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)
    this.color, // 背景颜色
    this.image, // 默认值:AssetImage('assets/empty/no_network.png',package: 'flutter_effect',)
    required this.errorRetry, // 错误事件处理
  }) : super(key: key);

  @override
  _StateErrorWidgetState createState() => _StateErrorWidgetState();
}

class _StateErrorWidgetState extends State<StateErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return _errorView;
  }

  ///错误视图
  Widget get _errorView {
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
        child: _errorWidget,
      ),
    );

    return Column(
      children: columnWidgets,
    );
  }

  Widget get _errorWidget {
    return EmptyWithImageAboveTextWidget(
      color: widget.color,
      image: widget.image ??
          AssetImage(
            'assets/empty/no_network.png',
            package: 'flutter_effect',
          ),
      mainTitle: '网络开小差了，刷新一下试试！',
      // subTitle: '点击下方按钮帮你叫醒它！',
      // buttonWidget: ThemeBorderButton(
      //   width: 88, // 不设置会根据内容自适应
      //   height: 26, // 不设置会根据内容自适应
      //   borderColorType: ThemeBGType.theme,
      //   title: '刷新一下',
      //   titleStyle: ButtonBoldTextStyle(fontSize: 13.0),
      //   cornerRadius: 17.5,
      //   onPressed: widget.errorRetry,
      // ),
      buttonWidget: InkWell(
        onTap: () => widget.errorRetry(),
        child: Container(
          alignment: Alignment.center,
          width: 88,
          height: 26,
          decoration: BoxDecoration(
            color: themeColor(ThemeBGType.theme),
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          child: Text(
            "刷新一下",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
