import 'package:flutter/material.dart';
import '../bg_border_widget.dart';

class CJButtonConfigModel {
  final Color? bgColor; // 背景颜色
  final Color textColor; // 文字颜色
  final Color? borderColor; // 边框颜色
  final double? borderWidth; // 边框大小
  final Color? backgroundHighlightColor;

  CJButtonConfigModel({
    this.bgColor,
    required this.textColor,
    this.borderColor,
    this.borderWidth,
    this.backgroundHighlightColor,
  });
}

/// 真正的底层按钮(和iOS原生一样可配置 Normal 和 Selected 风格的按钮)
class CJBaseButton extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget Function(bool bSelected) childBuider;
  final MainAxisAlignment childMainAxisAlignment;
  final VoidCallback? onPressed;
  final VoidCallback? onPressedUnable;
  final bool enable;
  final bool selected;
  final double cornerRadius;
  final CJButtonConfigModel normalConfig;
  final CJButtonConfigModel? normalDisableConfig;
  final CJButtonConfigModel? selectedConfig;
  final CJButtonConfigModel? selectedDisableConfig;

  CJBaseButton({
    Key? key,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.padding,
    required this.childBuider,
    this.childMainAxisAlignment = MainAxisAlignment.center,
    this.onPressed, // 不是必传(为了使其null时候，能够自动透传点击事件)
    this.onPressedUnable, // unable的时候，可自定义点击事件（为了让unbale的时候点击能弹出toast)
    this.enable = true,
    this.selected = false,
    this.cornerRadius = 5.0,
    required this.normalConfig,
    this.normalDisableConfig,
    this.selectedConfig,
    this.selectedDisableConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CJButtonConfigModel _currentConfig = normalConfig;
    double _cornerRadius = cornerRadius;

    if (selected == true) {
      if (enable == true) {
        if (selectedConfig != null) {
          _currentConfig = selectedConfig!;
        }
      } else {
        if (selectedDisableConfig != null) {
          _currentConfig = selectedDisableConfig!;
        }
      }
    } else {
      if (enable == true) {
        _currentConfig = normalConfig;
      } else {
        if (normalDisableConfig != null) {
          _currentConfig = normalDisableConfig!;
        }
      }
    }
    /*
    BorderSide borderSide = BorderSide(
      width: _currentBorderWidth,
      color: _currentBorderWidth == 0
          ? Colors.transparent
          : _currentBorderColor, // bugfix:等于0的时候，要设置透明色，否则会有描边
    );

    OutlinedBorder shapeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_cornerRadius),
      side: borderSide,
    );

    OutlinedBorder shapeBorder2 = StadiumBorder();
    */
    //* // 使用新版 TextButton
    //[Flutter TextButton 详细使用配置、Flutter ButtonStyle概述实践](https://zhuanlan.zhihu.com/p/278330232)
    /*
    VoidCallback _onPressed = this.onPressed;
    if (this.enable == false) {
      _onPressed = () {}; // 不能点击的时候，如果还是this.onPressed，则也会自行该操作
    }

    ButtonStyle buttonStyle = ButtonStyle(
      //定义文本的样式 这里设置的颜色是不起作用的
      textStyle:
          MaterialStateProperty.all(TextStyle(fontSize: 18, color: Colors.red)),
      //设置按钮上字体与图标的颜色
      // foregroundColor: MaterialStateProperty.all(_currentTextColor),
      //更优美的方式来设置
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.focused) &&
              !states.contains(MaterialState.pressed)) {
            //获取焦点时的颜色
            return Colors.yellow;
          } else if (states.contains(MaterialState.pressed)) {
            //按下时的颜色
            if (_currentTextColor == Colors.transparent) {
              //bugfix:修复透明时候的取值
              return _currentTextColor;
            }
            return _currentTextColor.withOpacity(_highlightOpacity);
          }
          //默认状态使用灰色
          return _currentTextColor;
        },
      ),
      //背景颜色
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        //设置按下时的背景颜色
        if (states.contains(MaterialState.pressed)) {
          _currentBackgroundHighlightColor;
        }
        //默认使用背景颜色
        return _currentBackgroundColor;
      }),
      //设置水波纹颜色
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      // //设置阴影  不适用于这里的TextButton
      // elevation: MaterialStateProperty.all(0),
      //设置按钮内边距
      // padding: MaterialStateProperty.all(EdgeInsets.all(10)),
      //设置按钮的大小
      // minimumSize: MaterialStateProperty.all(Size(200, 100)),

      //设置边框
      // side: MaterialStateProperty.all(borderSide),
      //外边框装饰 会覆盖 side 配置的样式
      shape: MaterialStateProperty.all(shapeBorder),
    );
    return Container(
      width: this.width,
      height: this.height,
      child: TextButton(
        child: this.child,
        onPressed: _onPressed, // 必传，但null时候会自动透传
        style: buttonStyle,
      ),
    );
    */

    VoidCallback? _onPressed = enable == true ? onPressed : onPressedUnable;

    return CJBGBorderWidget(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      backgroundColor: _currentConfig.bgColor,
      borderColor: _currentConfig.borderColor,
      borderWidth: _currentConfig.borderWidth,
      cornerRadius: _cornerRadius,
      onPressed: _onPressed, // 非必传,null时候要且会自动结合behavior属性实现透传
      behavior: _onPressed == null
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      child: DefaultTextStyle(
        style: TextStyle(
          color: _currentConfig.textColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: childMainAxisAlignment,
          children: <Widget>[
            childBuider(selected),
          ],
        ),
      ),
    );
  }
}
