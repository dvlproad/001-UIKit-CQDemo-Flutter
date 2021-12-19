// button 中 childWidget 的创建
import 'package:flutter/material.dart';

class ButtonChildWidget extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final ImageProvider image;

  const ButtonChildWidget({
    Key key,
    this.title,
    this.titleStyle,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.image != null) {
      return _childWidget_textAndImage;
    } else {
      return _childWidget_onlyText;
    }
  }

  // 为什么 Button 里 不要再设置颜色。猜测是由于[DefaultTextStyle](https://blog.csdn.net/jungle_pig/article/details/94383759)
  Widget get _childWidget_onlyText {
    return Text(
      title,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: this.titleStyle ??
          TextStyle(
            // color: _currentTextColor, //不用设颜色，会自动使用外层样式
            fontSize: 13.0,
          ),
    );
  }

  Widget get _childWidget_textAndImage {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: this.image,
            width: 22,
            height: 22,
          ),
          SizedBox(
            width: 5,
          ),
          _childWidget_onlyText,
        ],
      ),
    );
  }

  Widget get _testWidget {
    String _currentTitle = '临时标题';
    return Column(
      children: [
        Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: this.titleStyle ??
              TextStyle(
                // color: _currentTextColor,
                fontSize: 18.0,
              ),
        ),
        Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: this.titleStyle ??
              TextStyle(
                // color: _currentTextColor,
                fontSize: 18.0,
              ),
        ),
      ],
    );
  }
}
