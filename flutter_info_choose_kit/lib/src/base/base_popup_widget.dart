import 'dart:ui';
import 'package:flutter/material.dart';
import '../../flutter_info_choose_kit_adapt.dart';

class BasePopupWidget extends StatelessWidget {
  final double? height;
  final double? leftMargin;

  final String? title;
  final void Function()? onTapClose;
  final Widget Function(BuildContext bContext) customViewBuilder;
  final Widget Function(BuildContext bContext)? bottomButtonBuilder;

  const BasePopupWidget({
    Key? key,
    this.height,
    this.leftMargin,
    this.title,
    this.onTapClose,
    required this.customViewBuilder, // 由 Expanded 包裹，如果高度不够，会自动被拉伸
    this.bottomButtonBuilder,
  }) : super(key: key);

  // 计算弹出视图的完整高度(customViewHeight为UI图上扣除 toolbarHeight 和 srceenBottom 后的高度)
  static double viewHeight(double customViewHeight) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    // double screenHeight = mediaQuery.size.height;
    double srceenBottom = mediaQuery.padding.bottom;

    double viewHeight =
        BasePopupWidget.toolbarHeight + customViewHeight + srceenBottom;
    return viewHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
          // 顶部 提示可下滑关闭的短线 + 工具栏
          _renderTopToolbar(),
          // 内容视图
          Expanded(child: customViewBuilder(context)),
          // 底部视图（如果有，一般为确认按钮）
          bottomButtonBuilder == null
              ? Container()
              : bottomButtonBuilder!(context),
        ],
      ),
    );
  }

  static double toolbarHeight = (14 + 2 * 6 + 30).h_pt_cj;
  // 顶部 提示可下滑关闭的短线 + 工具栏
  Widget _renderTopToolbar() {
    return Container(
      // color: Colors.pink,
      height: BasePopupWidget.toolbarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 提示可下滑关闭的短线
          Container(
            color: Colors.transparent,
            height: 14.h_pt_cj,
            padding: EdgeInsets.only(top: 10.h_pt_cj),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(2.h_pt_cj),
                ),
                width: 34.w_pt_cj,
                height: 4.h_pt_cj,
              ),
            ),
          ),
          // 工具栏
          Expanded(child: _renderToolbar()),
        ],
      ),
    );
  }

  Container _renderToolbar() {
    double toolbarHeight = 30.h_pt_cj;
    return Container(
      // color: Colors.green,
      height: toolbarHeight,
      margin: EdgeInsets.symmetric(
        horizontal: 16.w_pt_cj,
        vertical: 6.h_pt_cj,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 30.w_pt_cj),
            // color: Colors.amber,
            child: Text(
              title ?? "",
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.bold,
                fontSize: 16.f_pt_cj,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          if (onTapClose != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onTapClose,
                child: Container(
                  width: 30.w_pt_cj,
                  height: 30.h_pt_cj,
                  // color: Colors.blue,
                  alignment: Alignment.center,
                  child: Image(
                    image: const AssetImage(
                      'assets/icon_close.png',
                      package: 'flutter_overlay_kit',
                    ),
                    width: 12.w_pt_cj,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
