// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-11 18:29:27
 * @Description: 当前页是海报页的前一页，或者当前页就是海报页
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_share_kit/flutter_share_kit_adapt.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NormalPosterWidget extends StatelessWidget {
  late bool currentIsPosterPage;
  late String qrCodeWebUrl;
  late String qrCodePromptText;
  final Widget Function(BuildContext context) posterWidgetGetBlock;

  final GlobalKey posterRepaintBoundaryGlobalKey;
  final Widget Function(BuildContext context) noposterWidgetGetBlock;

  NormalPosterWidget({
    Key? key,
    required this.posterWidgetGetBlock,
    required this.posterRepaintBoundaryGlobalKey,
    required this.noposterWidgetGetBlock,
  }) : super(key: key) {
    currentIsPosterPage = false;
  }

  NormalPosterWidget.currentIsPosterPage({
    Key? key,
    required this.qrCodeWebUrl,
    required this.qrCodePromptText,
    required this.posterWidgetGetBlock,
    required this.posterRepaintBoundaryGlobalKey,
    required this.noposterWidgetGetBlock,
  }) : super(key: key) {
    currentIsPosterPage = true;
  }

  @override
  Widget build(BuildContext context) {
    if (currentIsPosterPage == true) {
      return Container(
        child: Stack(
          children: [
            RepaintBoundary(
              key: posterRepaintBoundaryGlobalKey,
              child: Container(
                color: Colors.red,
                child: Stack(
                  children: [
                    posterWidgetGetBlock(context),
                    _renderPositionedQRCode(),
                  ],
                ),
              ),
            ),
            posterWidgetGetBlock(context),
            noposterWidgetGetBlock(context),
          ],
        ),
      );
    }

    return Container(
      child: Stack(
        children: [
          RepaintBoundary(
            key: posterRepaintBoundaryGlobalKey,
            child: posterWidgetGetBlock(context),
          ),
          noposterWidgetGetBlock(context),
        ],
      ),
    );
  }

  double leftOrRightPadding = 16.w_pt_cj;
  double bottomPadding = 16.h_pt_cj;

  double qrCodeImageSize = 66.w_pt_cj;
  Widget _renderPositionedQRCode() {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
    return Container(
      child: Positioned(
        right: leftOrRightPadding,
        bottom: mediaQueryData.padding.bottom + bottomPadding,
        child: Container(
          // color: Colors.green,
          alignment: Alignment.bottomRight,
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                qrCodePromptText,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                  fontSize: 11.w_pt_cj,
                  color: const Color(0xFF8b8b8b),
                ),
              ),
              SizedBox(width: 6.w_pt_cj),
              Container(
                width: qrCodeImageSize,
                height: qrCodeImageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3.w_pt_cj)),
                  color: Colors.white,
                ),
                child: QrImageView(
                  data: qrCodeWebUrl,
                  padding: EdgeInsets.zero,
                  errorStateBuilder: (BuildContext context, Object? object) {
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
