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
  late Widget Function() posterContentWidgetBuilder;

  final void Function({required bool show}) loadingForButtonHandle;

  PosterWithButtonPage({
    Key? key,
    required this.appbarWidgetBuilder,
    required this.loadingForButtonHandle,
    required this.posterBgImageUrl,
    required this.posterContentWidgetBuilder,
  }) : super(key: key);

  PosterWithButtonPage.easy({
    Key? key,
    required this.appbarWidgetBuilder,
    required this.loadingForButtonHandle,
    required this.posterBgImageUrl,
    required String userImageUrl,
    required String appLogoPath,
    required String qrCodeWebUrl,
    required Widget Function(
            {required double halfAvatarHeight,
            required double qrCodeWidgetWidth})
        posterTextContainerBuilder,
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
        qrCodeWebUrl: qrCodeWebUrl,
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: widget.appbarWidgetBuilder(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: buildPosterWidget(context)),
            PosterButtonsWidget(
              posterRepaintBoundaryGlobalKey: _repaintBoundaryGlobalKey,
              loadingHandle: widget.loadingForButtonHandle,
              completeBlock: (isSuccess) {
                //
              },
            ),
          ],
        ),
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
    Widget contentWidget = SizedBox(
      height: 733.h_pt_cj,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: TolerantNetworkImage(
          imageUrl: widget.posterBgImageUrl,
          width: 375.w_pt_cj,
          height: 733.h_pt_cj,
          fit: BoxFit.cover,
        ),
      ),
    );

    return contentWidget;
  }
}
