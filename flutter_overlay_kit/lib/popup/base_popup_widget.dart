import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import '../flutter_overlay_kit_adapt.dart';

class BasePopupWidget extends StatefulWidget {
  static double toolbarHeight = 40.h_pt_cj;

  double? height;

  String? title;
  Widget Function(BuildContext bContext) customViewBuilder;
  Widget Function(BuildContext bContext)? bottomButtonBuilder;

  BasePopupWidget({
    Key? key,
    this.height,
    this.title,
    required this.customViewBuilder, // 由 Expanded 包裹，如果高度不够，会自动被拉伸
    this.bottomButtonBuilder,
  })  : assert(customViewBuilder != null),
        super(key: key);

  @override
  _BasePopupWidgetState createState() => _BasePopupWidgetState();

  // 计算弹出视图的完整高度(customViewHeight为UI图上扣除 toolbarHeight 和 srceenBottom 后的高度)
  static double viewHeight(double customViewHeight) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double screenHeight = mediaQuery.size.height;
    double srceenBottom = mediaQuery.padding.bottom;

    double viewHeight =
        BasePopupWidget.toolbarHeight + customViewHeight + srceenBottom;
    return viewHeight;
  }
}

class _BasePopupWidgetState extends State<BasePopupWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget get _toolbar {
    return QuickToolBar(
      context,
      automaticallyImplyLeading: false,
      title: widget.title ?? '',
      actions: [
        ToolBarImageActionWidget(
          image: Image(
            image: AssetImage(
              'assets/icon_close.png',
              package: 'flutter_overlay_kit',
            ),
            width: 17.w_pt_cj,
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.w_pt_cj),
          topRight: Radius.circular(16.w_pt_cj),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _toolbar,
          Expanded(child: widget.customViewBuilder(context)),
          widget.bottomButtonBuilder == null
              ? Container()
              : widget.bottomButtonBuilder!(context),
        ],
      ),
    );
  }
}

class BottomPopupButton extends StatelessWidget {
  String buttonText;
  void Function() onPressedButton;

  BottomPopupButton({
    Key? key,
    required this.buttonText, // 为默认值null时候，不占位置
    required this.onPressedButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double srceenBottom = mediaQuery.padding.bottom;
    double childBottom = 18.h_pt_cj;
    double childHeight = 40.h_pt_cj + 2 * childBottom + srceenBottom;
    Widget child = Container(
      // height: childHeight,
      // padding: EdgeInsets.only(bottom: childBottom),
      color: Colors.pink,
      child: RowPaddingButton(
        leftRightPadding: 10.w_pt_cj,
        height: 40.h_pt_cj,
        cornerRadius: 20.h_pt_cj,
        bgColorType: ThemeBGType.theme,
        title: buttonText,
        titleStyle: ButtonRegularTextStyle(fontSize: 12.h_pt_cj),
        onPressed: () {
          if (onPressedButton != null) {
            onPressedButton();
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );

    return Container(
      padding: EdgeInsets.only(bottom: srceenBottom),
      height: childHeight,
      color: Colors.red,
      child: child,
    );
  }
}
