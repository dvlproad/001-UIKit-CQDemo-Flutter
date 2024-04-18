// ignore_for_file: avoid_unnecessary_containers

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

import '../base_share_singleton.dart';
import '../share_util/poster_share_util.dart';
import '../share_util/wechat_share_util.dart';

import '../../flutter_share_kit_adapt.dart';

class PosterButtonsWidget extends StatefulWidget {
  final GlobalKey posterRepaintBoundaryGlobalKey;
  final void Function(bool isSuccess) completeBlock;

  const PosterButtonsWidget({
    required this.posterRepaintBoundaryGlobalKey,
    required this.completeBlock,
    Key? key,
  }) : super(key: key);

  @override
  State<PosterButtonsWidget> createState() => _PosterButtonsWidgetState();
}

class _PosterButtonsWidgetState extends State<PosterButtonsWidget> {
  ui.Image? _posterImage;

  @override
  void initState() {
    super.initState();
  }

  Future _getPoster() async {
    if (_posterImage != null) {
      return;
    }

    _posterImage = await PosterShareUtil.getScreensShot(
        widget.posterRepaintBoundaryGlobalKey);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    double _botbarH = mediaQuery.padding.bottom;

    return Container(
      height: 125.h_pt_cj + _botbarH,
      padding: EdgeInsets.only(
        top: 30.w_pt_cj,
        bottom: _botbarH + 30.w_pt_cj,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w_pt_cj),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w_pt_cj),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                saveButton,
                buildButtonWidget(
                  buttonImageName: "assets/wx_icon.png",
                  buttonText: "微信",
                  onTap: () => _shareToWechat(scene: WeChatScene.SESSION),
                ),
                buildButtonWidget(
                  buttonImageName: "assets/timeline_icon.png",
                  buttonText: "朋友圈",
                  onTap: () => _shareToWechat(scene: WeChatScene.TIMELINE),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 分享到微信
  /// scene: 微信好友/朋友圈
  _shareToWechat({required WeChatScene scene}) async {
    BaseShareSingleton.loadingShowHandle?.call();
    await _getPoster();
    if (_posterImage == null) {
      BaseShareSingleton.loadingDismissHandle?.call();
      widget.completeBlock(false);
      return;
    }

    WechatShareUtil.shareH5ImageByUIImage(_posterImage!, scene: scene);
    BaseShareSingleton.loadingDismissHandle?.call();
    widget.completeBlock(true);
  }

  Widget get saveButton {
    return buildButtonWidget(
      buttonImageName: "assets/save_icon.png",
      buttonText: "保存",
      onTap: () async {
        BaseShareSingleton.loadingShowHandle?.call();
        await _getPoster();
        if (_posterImage == null) {
          BaseShareSingleton.loadingDismissHandle?.call();
          widget.completeBlock(false);
          return;
        }

        PosterShareUtil.saveScreensShot(
          context,
          image: _posterImage!,
        ).then((value) {
          BaseShareSingleton.loadingDismissHandle?.call();
          widget.completeBlock(true);
        });
      },
    );
  }

  Widget buildButtonWidget({
    required String buttonImageName,
    required String buttonText,
    required void Function() onTap,
  }) {
    return InkWell(
      child: Container(
        // color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              buttonImageName,
              package: "flutter_share_kit",
              width: 44.w_pt_cj,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 5.w_pt_cj),
            Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
                fontSize: 11.w_pt_cj,
                color: const Color(0xff696969),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
