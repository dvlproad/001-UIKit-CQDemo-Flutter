import 'package:flutter/material.dart';

/// 文本按钮(未配置 Normal 和 Selected 风格的主题色按钮)
class TextButton extends FlatButton {
  TextButton({
    Key key,
    String text,
    double radius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
    Color themeColor,
    Color themeDisabledColor,
  }) : super(
          key: key,
          child: Text(text,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
//          color: Colors.white,
                fontSize: 18.0,
              )),
          onPressed: enable
              ? onPressed ?? () {}
              : null, // 这里是用 onPressed 的是否为空，来内部设置 enable 属性的
          splashColor: Colors.transparent,
          color: themeColor,
          textColor: themeDisabledColor,
          highlightColor: themeColor,
          disabledColor: themeDisabledColor,
          disabledTextColor: themeColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        );
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
