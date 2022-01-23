// appbar 上 左侧返回视图 + 中间标题视图 + 右侧按钮视图
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../flutter_effect_adapt.dart';

// 导航栏文本颜色类型
enum AppBarTextColorType {
  defalut, // 默认(黑色)
  white, // 白色
}

// 左侧返回视图
class AppBarTitleWidget extends StatelessWidget {
  final String text;
  final AppBarTextColorType textColorType;
  final double width;

  final VoidCallback onPressed;

  const AppBarTitleWidget({
    Key key,
    @required this.text,
    this.textColorType = AppBarTextColorType.defalut,
    this.width,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(0xFF222222);
    if (textColorType == AppBarTextColorType.white) {
      textColor = Colors.white;
    }
    return Container(
      color: Colors.transparent,
      width: this.width == 0 ? 150 : this.width,
      child: TextButton(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            this.text ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: this.onPressed,
      ),
    );

    // return Center(
    //   // 保证文本的竖直居中
    //   child: Text(
    //     widget.titleText ?? '',
    //     textAlign: TextAlign.center, // 只会保证文本的水平居中
    //     style: TextStyle(
    //       color: const Color(0xFF222222),
    //       fontSize: 15,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
  }
}

// 左侧返回视图
class AppBarBackWidget extends StatelessWidget {
  final String text;
  final AppBarTextColorType textColorType; // 导航栏标题颜色能影响到返回按钮的颜色

  final VoidCallback
      onPressed; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

  const AppBarBackWidget({
    Key key,
    this.text,
    this.textColorType = AppBarTextColorType.defalut,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider image = null;
    if (this.text == null) {
      image = AssetImage(
        'assets/appbar/navback.png',
        package: 'flutter_effect',
      );
    }

    return AppBarActionWidget(
      text: this.text,
      image: image,
      onPressed: this.onPressed,
    );
  }
}

// 右侧按钮视图
class AppBarActionWidget extends StatelessWidget {
  final String text;
  final AppBarTextColorType textColorType; // 导航栏标题颜色能影响到其他按钮的颜色

  final ImageProvider image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  final VoidCallback onPressed;

  const AppBarActionWidget({
    Key key,
    this.text,
    this.textColorType = AppBarTextColorType.defalut,
    this.image,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(0xFF222222);
    if (textColorType == AppBarTextColorType.white) {
      textColor = Colors.white;
    }

    if (this.text != null) {
      return TextButton(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            this.text,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: this.onPressed,
      );
    } else {
      return IconButton(
        icon: Image(
          image: this.image ??
              AssetImage(
                'assets/appbar/navback.png',
                package: 'flutter_effect',
              ),
          width: 34.w_cj,
          height: 34.h_cj,
          fit: BoxFit.scaleDown,
        ),
        onPressed: this.onPressed,
      );
    }
  }
}
