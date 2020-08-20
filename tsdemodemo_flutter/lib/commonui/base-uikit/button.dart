import 'package:flutter/material.dart';

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮，并且颜色已添加用设置的主题色控制)
class CJStateThemeButton extends CJTextButton {
  CJStateThemeButton({
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
class CJTextButton extends StatelessWidget {
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

  CJTextButton({
    Key key,
    @required this.normalTitle,
    this.selectedTitle, // selectedTitle 为 null 的时候，会被自动设为 normalTitle
    @required this.onPressed,
    this.enable = true,
    this.disableOpacity = 0.7, // disable 时候，颜色的透明度
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
  }
}

/// Icon 位于图片中心，可大小可定制的按钮
class CenterIconButton extends StatelessWidget {
  @required
  final String assestName; // 按钮的本地图片名
  @required
  final double iconButtonSize; // 按钮大小
  @required
  final double iconImageSize; // 按钮中的图片大小
  @required
  final VoidCallback onPressed; // 按钮点击事件

  CenterIconButton({
    Key key,
    this.assestName,
    this.iconButtonSize,
    this.iconImageSize,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconButtonSize,
      width: iconButtonSize,
      child: FlatButton(
        color: Colors.red,
        onPressed: this.onPressed,
        padding: EdgeInsets.fromLTRB(
          0,
          (iconButtonSize - iconImageSize) / 2,
          0,
          (iconButtonSize - iconImageSize) / 2,
        ),
        child: Image.asset(
          assestName,
          width: iconImageSize,
          height: iconImageSize,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
