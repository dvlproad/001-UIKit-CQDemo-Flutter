import 'package:flutter/material.dart';

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮，并且背景和边框文字的颜色互为反面)
class CJReverseThemeStateTextButton extends CJStateTextButton {
  CJReverseThemeStateTextButton({
    Key key,
    Color themeColor,
    Color themeOppositeColor,
    double normalBorderWidth = 0.0,
    double selectedBorderWidth = 0.0,
    String normalTitle,
    String selectedTitle,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: normalTitle,
          selectedTitle: selectedTitle,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: normalBorderWidth,
          normalBorderColor: themeColor,
          selectedBGColor: themeOppositeColor,
          selectedTextColor: themeColor,
          selectedBorderWidth: selectedBorderWidth,
          selectedBorderColor: themeColor,
        );
}

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮)
class CJStateTextButton extends StatelessWidget {
  final String normalTitle;
  final String selectedTitle; // selectedTitle 为 null 的时候，会被自动设为 normalTitle
  final VoidCallback onPressed;
  final bool enable;
  final double disableOpacity;
  final bool selected;
  final double cornerRadius;
  final Color normalBGColor;
  final Color normalTextColor;
  final Color normalBorderColor;
  final double normalBorderWidth;
  final Color selectedBGColor;
  final Color selectedTextColor;
  final Color selectedBorderColor;
  final double selectedBorderWidth;

  CJStateTextButton({
    Key key,
    @required this.normalTitle,
    this.selectedTitle, // selectedTitle 为 null 的时候，会被自动设为 normalTitle
    @required this.onPressed,
    this.enable = true,
    this.disableOpacity = 0.5, // disable 时候，颜色的透明度
    this.selected = false,
    this.cornerRadius = 5.0,
    this.normalBGColor,
    this.normalTextColor,
    this.normalBorderColor,
    this.normalBorderWidth = 0.0,
    this.selectedBGColor,
    this.selectedTextColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 0.0, // 按钮选中时候的边框宽度
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentTitle;
    Color _currentTextColor;
    Color _currentBackgroundColor;

    Color _currentBorderColor;
    double _currentBorderWidth;
    double _cornerRadius = this.cornerRadius;
    if (selected) {
      _currentTitle = selectedTitle ?? normalTitle;

      if (enable) {
        _currentTextColor = selectedTextColor;
        _currentBackgroundColor = selectedBGColor;
        _currentBorderColor = selectedBorderColor ?? Colors.transparent;
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

    return Container(
      child: FlatButton(
        child: Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            // color: _currentTextColor,
            fontSize: 18.0,
          ),
        ),
        onPressed: _onPressed,
        splashColor: Colors.transparent,
        color: _currentBackgroundColor,
        textColor: _currentTextColor,
        //highlightColor: selectedBGColor,
        disabledColor: _currentBackgroundColor,
        disabledTextColor: _currentTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cornerRadius),
          side: BorderSide(
            width: _currentBorderWidth,
            color: _currentBorderColor,
          ),
        ),
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
