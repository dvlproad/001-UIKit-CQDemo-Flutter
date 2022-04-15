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
    Image image = Image(
      image: buttonImageProvider,
      width: 22.w_pt_cj,
      height: 17.h_pt_cj,
    );

    image.image.resolve(new ImageConfiguration()).addListener(
      new ImageStreamListener(
        (ImageInfo info, bool _) {
          int imageWidth = info.image.width;
          int imageHeight = info.image.height;
          print('imageWidth=$imageWidth, imageHeight=$imageHeight');
        },
      ),
    );
    return LeftImageTextButton(
      key: key,
      onTap: onTap,
      bgColor: Colors.white,
      cornerRadius: 24.w_pt_cj,
      height: 50.h_pt_cj,
      iconHeight: 22.w_pt_cj,
      imageView: image,
      iconTitleSpace: 5.w_pt_cj,
      textLabel: Text(
        buttonText,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 12.w_pt_cj,
          color: Color(0xFF222222),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// 左图片+右文字的按钮视图:icon和文字保持一定上下间距，一起居中(常见于等)
class LeftImageTextButton extends StatelessWidget {
  double width;
  double height;
  EdgeInsetsGeometry padding; // 图片与边缘一般都有一定距离
  Color bgColor;
  double cornerRadius;
  double iconHeight; // icon的高度(宽度等于高度)
  double iconTitleSpace; // icon与文字之间的间距
  double titleHeight; // 文字高度
  double clickHandle; // 点击视图的事件

  Image imageView;
  Widget textLabel;
  GestureTapCallback onTap;

  bool showDeleteIcon; // 是否显示删除按钮
  Widget Function() customDeleteIconBuilder; // 自定义删除按钮(默认null,null时候有默认图片)
  GestureTapCallback onTapDelete; // 点击删除按钮执行的操作(如果有显示删除按钮的情况下)

  LeftImageTextButton({
    Key key,
    this.width,
    this.height,
    this.padding,
    this.bgColor,
    this.cornerRadius,
    this.iconHeight,
    this.iconTitleSpace,
    this.titleHeight,
    this.clickHandle,
    this.imageView,
    this.textLabel,
    this.onTap,
    this.showDeleteIcon,
    this.customDeleteIconBuilder,
    this.onTapDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Container(
        width: iconHeight,
        height: iconHeight,
        // color: Colors.green,
        alignment: Alignment.center,
        child: imageView,
      ),
      Container(width: iconTitleSpace),
      Container(
        alignment: Alignment.center,
        height: titleHeight,
        // color: Colors.blue,
        child: textLabel,
      )
    ];

    if (showDeleteIcon == true) {
      Widget deleteWidget;
      if (customDeleteIconBuilder != null) {
        deleteWidget = customDeleteIconBuilder();
      } else {
        deleteWidget = Image.asset(
          "assets/icon_delete.png",
          package: 'flutter_baseui_kit',
          width: 16.w_pt_cj,
          height: 16.h_pt_cj,
          fit: BoxFit.cover,
        );
      }

      widgets.add(
        Container(width: 3.w_pt_cj),
      );
      widgets.add(
        InkWell(onTap: onTapDelete, child: deleteWidget),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(cornerRadius ?? 0),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
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
      width: this.width ?? 60.w_pt_cj,
      height: this.height ?? 60.h_pt_cj,
      iconTitleSpace: 2.h_pt_cj,
      imageView: icon,
      textLabel: Text(
        title,
        style: TextStyle(fontSize: 9.w_pt_cj, color: titleColor),
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

    double titleHeight = 12.h_pt_cj;
    double iconTitleSpace = 8.h_pt_cj;
    double iconHeight = 24.h_pt_cj;

    String badgeCountString = "";
    double badgeWidgetWidth = 0;
    if (badgeCount != null && badgeCount > 0) {
      if (badgeCount > 99) {
        badgeCountString = "99+";
        badgeWidgetWidth = 20.w_pt_cj;
      } else {
        badgeCountString = "$badgeCount";
        if (badgeCount > 10) {
          badgeWidgetWidth = 20.w_pt_cj;
        } else {
          badgeWidgetWidth = 20.w_pt_cj;
        }
      }
    }

    double badgePositionedLeft = 0;
    if (width != null && width > 0) {
      badgePositionedLeft = width / 2;
    }
    double badgePositionedRight =
        width - badgePositionedLeft - badgeWidgetWidth;

    double badgePositionedTop = 14.h_pt_cj;

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
            titleHeight: titleHeight,
            iconTitleSpace: iconTitleSpace,
            iconHeight: iconHeight,
            imageView: Image.asset(
              imgUrl,
              width: iconHeight,
              fit: BoxFit.fitWidth,
            ),
            textLabel: Text(
              title,
              style: TextStyle(
                fontSize: titleHeight,
                color: const Color(0xff222222),
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: badgePositionedTop,
            right: badgePositionedRight,
            child: Container(
              height: 10.h_pt_cj,
              width: badgeWidgetWidth,
              // constraints: BoxConstraints(maxWidth: 0),
              decoration: BoxDecoration(
                color: Color(0xFFFF7F00),
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(15),
                //   topRight: Radius.circular(10),
                // ),
                borderRadius: BorderRadius.all(
                  Radius.circular(badgeWidgetWidth / 2),
                ),
              ),
              child: Center(
                child: Text(
                  badgeCountString,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 8.f_pt_cj,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
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
  double iconLeftRightSpace; // icon与左/右两边的距离
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
    this.iconLeftRightSpace,
    this.iconTitleSpace,
    this.titleHeight,
    this.clickHandle,
    this.imageView,
    this.textLabel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool hasIconLeftRightSpace =
    //     iconLeftRightSpace != null && iconLeftRightSpace != 0;
    // bool hasIconHeight = iconHeight != null && iconHeight != 0;
    // if (hasIconLeftRightSpace == false && hasIconHeight == false) {
    //   throw Exception("iconLeftRightSpace与iconHeight不能同时为空");
    // }
    // double contentHeight =
    //     iconHeight ?? 0 + iconTitleSpace ?? 0 + titleHeight ?? 0;
    // double contentHeight = height;
    Widget contentWidget = Container(
      width: width,
      // height: contentHeight,
      height: height,
      // color: Colors.cyan,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: iconHeight,
            height: iconHeight,
            // color: Colors.yellow,
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
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        color: color,
        alignment: Alignment.center,
        child: contentWidget,
      ),
    );
  }
}
