import 'package:flutter/material.dart';
import '../../base-uikit/bg_border_widget.dart';

/// 底层按钮(已配置 Normal 和 Selected 风格的主题色按钮)
class CJStateButton extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final VoidCallback? onPressed;
  final bool? enable;
  final double disableOpacity;
  final bool? selected;
  final double cornerRadius;
  final Color normalBGColor;
  final Color normalTextColor;
  final Color? normalBorderColor;
  final double normalBorderWidth;
  final Color? normalBackgroundHighlightColor;
  final Color? selectedBGColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;
  final double selectedBorderWidth;
  final Color? selectedBackgroundHighlightColor;
  final double? highlightOpacity; // 没有设置高亮 highlightColor 的时候，取原色的多少透明度值

  CJStateButton({
    Key? key,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.padding,
    required this.child,
    this.onPressed, // 不是必传(为了使其null时候，能够自动透传点击事件)
    this.enable = true,
    this.disableOpacity = 0.5, // disable 时候，颜色的透明度
    this.selected = false,
    this.cornerRadius = 5.0,
    required this.normalBGColor,
    required this.normalTextColor,
    this.normalBorderColor,
    this.normalBorderWidth = 0.0,
    this.normalBackgroundHighlightColor,
    this.selectedBGColor,
    this.selectedTextColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 0.0, // 按钮选中时候的边框宽度
    this.selectedBackgroundHighlightColor,
    this.highlightOpacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _currentTextColor;
    Color _currentBackgroundColor;
    Color? _currentBackgroundHighlightColor;

    Color _currentBorderColor;
    double _currentBorderWidth;
    double _cornerRadius = this.cornerRadius;

    double _highlightOpacity = 1.0; // 默认为1.0,即没直接设置高亮颜色的时候，高亮为原色
    if (this.highlightOpacity != null) {
      _highlightOpacity = this.highlightOpacity!;
    }

    if (selected == true) {
      if (enable == true) {
        _currentTextColor = selectedTextColor!;
        _currentBackgroundColor = selectedBGColor!;
        _currentBorderColor = selectedBorderColor ?? Colors.transparent;
        _currentBackgroundHighlightColor = selectedBackgroundHighlightColor;
      } else {
        _currentTextColor = selectedTextColor!.withOpacity(disableOpacity);
        _currentBackgroundColor = selectedBGColor!.withOpacity(disableOpacity);
        _currentBorderColor = selectedBorderColor != null
            ? selectedBorderColor!.withOpacity(disableOpacity)
            : Colors.transparent;
      }

      _currentBorderWidth = selectedBorderWidth;
    } else {
      if (enable == true) {
        _currentTextColor = normalTextColor;
        _currentBackgroundColor = normalBGColor;
        _currentBorderColor = normalBorderColor ?? Colors.transparent;
        _currentBackgroundHighlightColor = normalBackgroundHighlightColor;
      } else {
        _currentTextColor = normalTextColor.withOpacity(disableOpacity);
        _currentBackgroundColor = normalBGColor.withOpacity(disableOpacity);
        _currentBorderColor = normalBorderColor != null
            ? normalBorderColor!.withOpacity(disableOpacity)
            : Colors.transparent;
      }

      _currentBorderWidth = normalBorderWidth;
    }

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
    //* // 使用新版 TextButton
    //[Flutter TextButton 详细使用配置、Flutter ButtonStyle概述实践](https://zhuanlan.zhihu.com/p/278330232)

    // 检查 高亮颜色 的值(使用 FlatButton 的时候,空值会自动补上高亮效果)
    if (_currentBackgroundHighlightColor == null) {
      if (_currentBackgroundColor == Colors.transparent) {
        //bugfix:修复透明时候的取值
        _currentBackgroundHighlightColor = _currentBackgroundColor;
      } else {
        _currentBackgroundHighlightColor =
            _currentBackgroundColor.withOpacity(_highlightOpacity);
      }
    }

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

    VoidCallback? _onPressed = this.onPressed;
    if (this.enable == false) {
      _onPressed = () {}; // 不能点击的时候，如果还是this.onPressed，则也会自行该操作
    }

    return CJBGBorderWidget(
      width: this.width,
      height: this.height,
      constraints: this.constraints,
      margin: this.margin,
      padding: this.padding,
      backgroundColor: _currentBackgroundColor,
      borderColor: _currentBorderColor,
      borderWidth: _currentBorderWidth,
      cornerRadius: _cornerRadius,
      onPressed: _onPressed, // 非必传,null时候要且会自动结合behavior属性实现透传
      behavior: _onPressed == null
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      child: DefaultTextStyle(
        style: TextStyle(
          color: _currentTextColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            child,
          ],
        ),
      ),
    );
  }
}
