import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_basekit/flutter_image_kit.dart';
import '../../flutter_share_kit_adapt.dart';

import './poster_buttons_widget.dart';
import 'poster_content_widget.dart';

// ignore: must_be_immutable
class PosterWithButtonPage extends StatefulWidget {
  final PreferredSizeWidget? Function() appbarWidgetBuilder;
  final String posterBgImageUrl;
  final void Function({String? errorMessage})? shareCompleteBlock;
  late Widget Function() posterContentWidgetBuilder;

  PosterWithButtonPage({
    Key? key,
    required this.appbarWidgetBuilder,
    required this.posterBgImageUrl,
    required this.posterContentWidgetBuilder,
    required this.shareCompleteBlock,
  }) : super(key: key);

  PosterWithButtonPage.easy({
    Key? key,
    required this.appbarWidgetBuilder,
    required this.posterBgImageUrl,
    required String userImageUrl,
    required String appLogoPath,
    required Future<PosterDataModel?> Function() netPosterDataGetter,
    required Widget Function(
            {required double halfAvatarHeight,
            required double qrCodeWidgetWidth})
        posterTextContainerBuilder,
    required this.shareCompleteBlock,
  }) : super(key: key) {
    posterContentWidgetBuilder = () {
      return PosterContentWidget(
        posterImageUrl: posterBgImageUrl,
        userImageUrl: userImageUrl,
        textContainerBuilder: (
            {required double halfAvatarHeight,
            required double qrCodeWidgetWidth}) {
          return posterTextContainerBuilder(
            halfAvatarHeight: halfAvatarHeight,
            qrCodeWidgetWidth: qrCodeWidgetWidth,
          );
          // return Container(
          //   color: Colors.red,
          //   margin: EdgeInsets.only(
          //     top: halfAvatarHeight,
          //     right: qrCodeWidgetWidth,
          //   ),
          // );
        },
        appLogoPath: appLogoPath,
        netPosterDataGetter: netPosterDataGetter,
      );
    };
  }

  @override
  State<PosterWithButtonPage> createState() => _PosterWithButtonPageState();
}

class _PosterWithButtonPageState extends State<PosterWithButtonPage> {
  final GlobalKey _repaintBoundaryGlobalKey = GlobalKey();
  ScrollPhysics _scrollPhysics = const AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 为了适配同时支持 showModalBottomSheet 和 Navigator.push ，所以放弃 extendBodyBehindAppBar， 使用自定义的方式
    // return Scaffold(
    //   extendBodyBehindAppBar: true,
    //   backgroundColor: Colors.transparent,
    //   appBar: widget.appbarWidgetBuilder(),
    //   body: _renderBody(context),
    // );

    Widget? appBarWidget = widget.appbarWidgetBuilder();

    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double statusBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = appBarWidget != null ? statusBarHeight + 44 : 0;
    // double screenBottomHeight = mediaQuery.padding.bottom;

    return Stack(
      children: [
        _renderBody(context),
        if (appBarWidget != null)
          SizedBox(height: appBarHeight, child: appBarWidget),
      ],
    );
  }

  _renderBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(child: buildPosterWidget(context)),
          PosterButtonsWidget(
            posterRepaintBoundaryGlobalKey: _repaintBoundaryGlobalKey,
            completeBlock: (isSuccess) {
              if (!isSuccess && widget.shareCompleteBlock != null) {
                widget.shareCompleteBlock!(errorMessage: "分享海报失败了");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildPosterWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double screenPaddingTop = mediaQuery.padding.top;

    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.atEdge) {
          if (notification.metrics.pixels == 0) {
            setState(() {
              _scrollPhysics = const NeverScrollableScrollPhysics();
            });
          }
        }
        return false;
      },
      child: Listener(
        onPointerMove: (PointerMoveEvent details) {
          if (details.delta.dy > 0) {
            if (details.delta.dy > 0) {
              setState(() {
                _scrollPhysics = const AlwaysScrollableScrollPhysics();
              });
            }
          }
        },
        child: SingleChildScrollView(
          physics: _scrollPhysics,
          clipBehavior: Clip.none,
          child: RepaintBoundary(
            key: _repaintBoundaryGlobalKey,
            child: Stack(
              children: [
                _renderPosterBackground(),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: screenPaddingTop + 54.h_pt_cj),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.posterContentWidgetBuilder(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderPosterBackground() {
    String posterBgImageUrl = widget.posterBgImageUrl;
    bool isNetworkImage = posterBgImageUrl.startsWith("http");
    Widget contentWidget = SizedBox(
      height: 733.h_pt_cj,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: isNetworkImage
            ? TolerantNetworkImage(
                imageUrl: posterBgImageUrl,
                width: 375.w_pt_cj,
                height: 733.h_pt_cj,
                fit: BoxFit.cover,
              )
            : Image.asset(
                posterBgImageUrl,
                width: 375.w_pt_cj,
                height: 733.h_pt_cj,
                fit: BoxFit.cover,
              ),
      ),
    );

    return contentWidget;
  }
}
