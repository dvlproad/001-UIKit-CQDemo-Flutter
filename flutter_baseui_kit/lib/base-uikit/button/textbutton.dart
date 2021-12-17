import 'package:flutter/material.dart';

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮，并且背景和边框文字的颜色互为反面)
class CJReverseThemeStateTextButton extends CJStateTextButton {
  CJReverseThemeStateTextButton({
    Key key,
    double width,
    double height,
    double cornerRadius = 5.0,
    Color themeColor,
    Color themeOppositeColor,
    double normalBorderWidth = 0.0,
    double selectedBorderWidth = 0.0,
    String normalTitle,
    String selectedTitle, // selectedTitle 为 null 的时候，会被自动设为 normalTitle
    TextStyle textStyle,
    bool enable = true,
    bool selected = false,
    Color normalBackgroundHighlightColor,
    Color selectedBackgroundHighlightColor,
    @required VoidCallback onPressed,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          normalTitle: normalTitle,
          selectedTitle: selectedTitle,
          textStyle: textStyle,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: normalBorderWidth,
          normalBorderColor: themeColor,
          normalBackgroundHighlightColor: normalBackgroundHighlightColor,
          selectedBGColor: themeOppositeColor,
          selectedTextColor: themeColor,
          selectedBorderWidth: selectedBorderWidth,
          selectedBorderColor: themeColor,
          selectedBackgroundHighlightColor: selectedBackgroundHighlightColor,
        );
}

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮)
class CJStateTextButton extends StatelessWidget {
  double width;
  double height;
  final String normalTitle;
  final String selectedTitle; // selectedTitle 为 null 的时候，会被自动设为 normalTitle
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final bool enable;
  final double disableOpacity;
  final bool selected;
  final double cornerRadius;
  final Color normalBGColor;
  final Color normalTextColor;
  final Color normalBorderColor;
  final double normalBorderWidth;
  final Color normalBackgroundHighlightColor;
  final Color selectedBGColor;
  final Color selectedTextColor;
  final Color selectedBorderColor;
  final double selectedBorderWidth;
  final Color selectedBackgroundHighlightColor;

  CJStateTextButton({
    Key key,
    this.width,
    this.height,
    @required this.normalTitle,
    this.selectedTitle, // selectedTitle 为 null 的时候，会被自动设为 normalTitle
    this.textStyle,
    @required this.onPressed,
    this.enable = true,
    this.disableOpacity = 0.5, // disable 时候，颜色的透明度
    this.selected = false,
    this.cornerRadius = 5.0,
    this.normalBGColor,
    this.normalTextColor,
    this.normalBorderColor,
    this.normalBorderWidth = 0.0,
    this.normalBackgroundHighlightColor,
    this.selectedBGColor,
    this.selectedTextColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 0.0, // 按钮选中时候的边框宽度
    this.selectedBackgroundHighlightColor,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentTitle;
    Color _currentTextColor;
    Color _currentBackgroundColor;
    Color _currentBackgroundHighlightColor;

    Color _currentBorderColor;
    double _currentBorderWidth;
    double _cornerRadius = this.cornerRadius;
    if (selected) {
      _currentTitle = selectedTitle ?? normalTitle;

      if (enable) {
        _currentTextColor = selectedTextColor;
        _currentBackgroundColor = selectedBGColor;
        _currentBorderColor = selectedBorderColor ?? Colors.transparent;
        _currentBackgroundHighlightColor = selectedBackgroundHighlightColor;
      } else {
        _currentTextColor = selectedTextColor?.withOpacity(disableOpacity);
        _currentBackgroundColor = selectedBGColor?.withOpacity(disableOpacity);
        _currentBorderColor = selectedBorderColor != null
            ? selectedBorderColor.withOpacity(disableOpacity)
            : Colors.transparent;
      }

      _currentBorderWidth = selectedBorderWidth;
    } else {
      _currentTitle = normalTitle;

      if (enable) {
        _currentTextColor = normalTextColor;
        _currentBackgroundColor = normalBGColor;
        _currentBorderColor = normalBorderColor ?? Colors.transparent;
        _currentBackgroundHighlightColor = normalBackgroundHighlightColor;
      } else {
        _currentTextColor = normalTextColor.withOpacity(disableOpacity);
        _currentBackgroundColor = normalBGColor.withOpacity(disableOpacity);
        _currentBorderColor = normalBorderColor != null
            ? normalBorderColor.withOpacity(disableOpacity)
            : Colors.transparent;
      }

      _currentBorderWidth = normalBorderWidth;
    }

    VoidCallback _onPressed;
    if (this.enable) {
      _onPressed =
          this.onPressed ?? () {}; // 这里是用 onPressed 的是否为空，来内部设置 enable 属性的
    } else {
      _onPressed = null; // 这里是用 onPressed 的是否为空，来内部设置 enable 属性的
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
    /*
    //[Flutter TextButton 详细使用配置、Flutter ButtonStyle概述实践](https://zhuanlan.zhihu.com/p/278330232)
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
            return Colors.red;
          }
          //默认状态使用灰色
          return _currentTextColor;
        },
      ),
      //背景颜色
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        //设置按下时的背景颜色
        if (states.contains(MaterialState.pressed)) {
          return _currentBackgroundHighlightColor ?? Colors.pink;
        }
        //默认不使用背景颜色
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
    */
    return Container(
      width: this.width,
      height: this.height,
      child: FlatButton(
        child: Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              TextStyle(
                // color: _currentTextColor,
                fontSize: 18.0,
              ),
        ),
        onPressed: _onPressed,
        // style: buttonStyle,
        splashColor: Colors.transparent,
        color: _currentBackgroundColor,
        textColor: _currentTextColor,
        highlightColor: _currentBackgroundHighlightColor,
        disabledColor: _currentBackgroundColor,
        disabledTextColor: _currentTextColor,
        shape: shapeBorder,
      ),
    );

    // return CJBGBorderWidget(
    //   // height: this.height,
    //   backgroundColor: _currentBackgroundColor,
    //   borderColor: _currentBorderColor,
    //   borderWidth: _currentBorderWidth,
    //   cornerRadius: _cornerRadius,
    //   onPressed: _onPressed,
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(
    //         _currentTitle,
    //         textAlign: TextAlign.left,
    //         overflow: TextOverflow.ellipsis,
    //         style: TextStyle(
    //           color: _currentTextColor,
    //           fontSize: 8.0,
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
