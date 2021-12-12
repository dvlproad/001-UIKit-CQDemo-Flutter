import 'package:flutter/material.dart';
import 'dart:ui';

class EasyAppBarWidget extends StatefulWidget {
  // final bool hideBackButton; // 隐藏返回按钮(默认不隐藏)
  final ImageProvider image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),

  final String title;
  final VoidCallback
      onTap; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

  EasyAppBarWidget({
    Key key,
    // this.hideBackButton = false,
    this.image,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  _EasyAppBarWidgetState createState() => _EasyAppBarWidgetState();
}

class _EasyAppBarWidgetState extends State<EasyAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    // 添加标题
    Widget stackTitleWidget = Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.pink[300],
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(left: 80, right: 80),
            child: _centerTitleWidget,
          ),
        ),
      ],
    );
    widgets.add(stackTitleWidget);

    // 根据情况，添加返回按钮
    if (widget.onTap != null) {
      Widget navBarButton = Positioned(
        left: 20,
        child: _navbarBackButton,
      );
      widgets.add(navBarButton);
    }

    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double stautsBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
//或者 double stautsBarHeight = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        Container(height: stautsBarHeight, color: Colors.red),
        Container(
          color: Colors.orange,
          width: double.infinity,
          height: 44,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: widgets,
          ),
        ),
      ],
    );
  }

  // 控件加载
  Widget get _centerTitleWidget {
    return Center(
      // 保证文本的竖直居中
      child: _titleWidget,
    );
  }

  Widget get _titleWidget {
    return Text(
      widget.title ?? '',
      textAlign: TextAlign.center, // 只会保证文本的水平居中
      style: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget get _navbarBackButton {
    return GestureDetector(
      onTap: () {
        if (widget.onTap == null) {
          //Navigator.of(context).pop();
        } else {
          widget.onTap();
        }
      },
      child: Image(
        image: widget.image ??
            AssetImage(
              'assets/navback.png',
            ),
        width: 40,
        height: 31,
        // color: Colors.yellow,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
