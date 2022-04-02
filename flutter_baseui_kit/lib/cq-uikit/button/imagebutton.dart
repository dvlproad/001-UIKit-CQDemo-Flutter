import 'package:flutter/material.dart';
import '../../flutter_baseui_kit_adapt.dart';

/// 图片在左，文字在右的按钮
class LeftImageButton extends StatelessWidget {
  String buttonText;
  int maxLines;
  ImageProvider buttonImageProvider;
  GestureTapCallback onTap;

  LeftImageButton({
    Key key,
    this.buttonText,
    this.buttonImageProvider,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w_cj),
        ),
        height: 100.h_cj,
        child: Row(
          children: [
            SizedBox(width: 25.w_cj),
            Image(
              image: buttonImageProvider,
              width: 44.w_cj,
              height: 35.h_cj,
            ),
            SizedBox(width: 11.w_cj),
            Text(
              buttonText,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: 24.w_cj,
                color: Color(0xFF222222),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopImageButton extends StatelessWidget {
  double width;
  double height;
  Image icon;
  String title;
  Color titleColor;
  GestureTapCallback onTap;

  TopImageButton({
    Key key,
    this.width,
    this.height,
    this.icon,
    this.title,
    this.titleColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TopImageTextButton(
      onTap: onTap,
      width: this.width ?? 120.w_cj,
      height: this.height ?? 120.h_cj,
      iconTitleSpace: 4.h_cj,
      imageView: icon,
      textLabel: Text(
        title,
        style: TextStyle(fontSize: 18.w_cj, color: titleColor),
      ),
    );
  }
}

class MenuImageTextButton extends StatelessWidget {
  double width;
  double height;
  Color color;
  String imgUrl;
  String title;
  int badgeCount;
  GestureTapCallback onTap;

  MenuImageTextButton({
    Key key,
    this.width,
    this.height,
    this.color,
    this.imgUrl,
    this.title,
    this.badgeCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double _width = MediaQuery.of(context).size.width;

    String badgeCountString = "";
    if (badgeCount != null && badgeCount > 0) {
      badgeCountString = "$badgeCount";
    }

    double badgePositionedRight = 0;
    if (width != null && width > 0) {
      badgePositionedRight = width / 2 - 44.w_cj;
    }

    return Container(
      color: this.color,
      width: this.width,
      height: this.height,
      child: Stack(
        children: [
          TopImageTextButton(
            onTap: onTap,
            // width: this.width ?? 120.w_cj,
            // height: this.height ?? 120.h_cj,
            // color: Colors.green,
            iconTitleSpace: 6.h_cj,
            imageView: Image.asset(
              imgUrl,
              width: 44.w_cj,
              fit: BoxFit.fitWidth,
            ),
            textLabel: Text(
              title,
              style: TextStyle(
                fontSize: 24.w_cj,
                color: const Color(0xff222222),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            // right: 0,
            right: badgePositionedRight,
            child: Container(
              height: 40.h_cj,
              decoration: BoxDecoration(
                // color: Colors.green,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(15),
                //   topRight: Radius.circular(10),
                // ),
                borderRadius: BorderRadius.all(Radius.circular(20.h_cj)),
              ),
              child: Text(
                badgeCountString,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 32.w_cj,
                  color: const Color(0xff222222),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 上图片+下文字的按钮视图:icon和文字保持一定上下间距，一起居中(常见于第三方登录icon设置等)
class TopImageTextButton extends StatelessWidget {
  double width;
  double height;
  Color color;
  double iconHeight; // icon的高度(宽度等于高度)
  double iconTitleSpace; // icon与文字之间的间距
  double titleHeight; // 文字高度
  double clickHandle; // 点击视图的事件

  Image imageView;
  Widget textLabel;
  GestureTapCallback onTap;

  TopImageTextButton({
    Key key,
    this.width,
    this.height,
    this.color,
    this.iconHeight,
    this.iconTitleSpace,
    this.titleHeight,
    this.clickHandle,
    this.imageView,
    this.textLabel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        color: color,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: iconHeight,
              height: iconHeight,
              // color: Colors.green,
              alignment: Alignment.center,
              child: imageView,
            ),
            Container(height: iconTitleSpace),
            Container(
              alignment: Alignment.center,
              height: titleHeight,
              // color: Colors.blue,
              child: textLabel,
            )
          ],
        ),
      ),
    );
  }
}
