import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CJStateTextButton extends StatelessWidget {
  final String normalTitle;
  final VoidCallback onPressed;
  final bool enable;
  final double disableOpacity;
  final double cornerRadius;
  final Color normalBGColor;
  final Color normalTextColor;
  final Color normalBorderColor;
  final double normalBorderWidth;
  final Color normalHighlightColor;

  CJStateTextButton({
    Key key,
    @required this.normalTitle,
    @required this.onPressed,
    this.enable = true,
    this.disableOpacity = 0.5, // disable 时候，颜色的透明度
    this.cornerRadius = 5.0,
    this.normalBGColor,
    this.normalTextColor,
    this.normalBorderColor,
    this.normalBorderWidth = 0.0,
    this.normalHighlightColor,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentTitle;
    Color _currentTextColor;
    Color _currentBackgroundColor;
    Color _highlightColor;

    Color _currentBorderColor;
    double _currentBorderWidth;
    double _cornerRadius = this.cornerRadius;

    _currentTitle = normalTitle;

    if (enable) {
      _currentTextColor = normalTextColor;
      _currentBackgroundColor = normalBGColor;
      _currentBorderColor = normalBorderColor ?? Colors.transparent;
      _highlightColor = normalHighlightColor;
    } else {
      _currentTextColor = normalTextColor.withOpacity(disableOpacity);
      _currentBackgroundColor = normalBGColor.withOpacity(disableOpacity);
      _currentBorderColor = normalBorderColor != null
          ? normalBorderColor.withOpacity(disableOpacity)
          : Colors.transparent;
    }

    _currentBorderWidth = normalBorderWidth;

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
            // color: Color(0xFF222222),
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: _onPressed,
        splashColor: Colors.transparent,
        color: _currentBackgroundColor,
        textColor: Color(0xFF222222),
        highlightColor: Color(0xFFFF7F00).withOpacity(0.12),
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
