/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 17:20:30
 * @Description: 
 */

import 'package:flutter/material.dart';

import 'package:flutter_share_kit/flutter_share_kit.dart';
import 'package:flutter_share_kit/flutter_share_kit_adapt.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import 'ts_share_popup_container.dart';

class TSShareHomePage extends StatefulWidget {
  const TSShareHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TSShareHomePage> createState() => _TSShareHomePageState();
}

class _TSShareHomePageState extends State<TSShareHomePage> {
  final GlobalKey _posterRepaintBoundaryGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NormalPosterWidget(
      posterRepaintBoundaryGlobalKey: _posterRepaintBoundaryGlobalKey,
      posterWidgetGetBlock: (BuildContext context) {
        return buildPosterWidget(context);
      },
      noposterWidgetGetBlock: (context, {required}) {
        return buildButtonsWidget(context);
      },
    );
  }

  Widget buildPosterWidget(BuildContext context) {
    return TSSharePopupContainer(
      contentWidgetGetBlock: () {
        // 获取屏幕的宽度和高度
        double screenWidth = MediaQuery.of(context).size.width;
        // double screenHeight = MediaQuery.of(context).size.height;

        return Container(
          color: Colors.green,
          child: Image.asset(
            "images/wish/wish_rank_bg.png",
            fit: BoxFit.cover,
            width: screenWidth - 2 * 30,
          ),
        );
      },
    );
  }

  Positioned buildButtonsWidget(BuildContext context) {
    MediaQueryData mediaData = MediaQuery.of(context);
    double screenWidth = mediaData.size.width;
    // double screenHeight = mediaData.size.height;
    // double screenPaddingTop = mediaData.padding.top;
    double screenPaddingBottom = mediaData.padding.bottom;

    return Positioned(
      bottom: screenPaddingBottom + 140.h_pt_cj,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.only(left: 26.w_pt_cj, right: 26.w_pt_cj),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shareButton(context),
            _savePosterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _shareButton(BuildContext context) {
    return ThemeBGButton(
      width: 150.w_pt_cj,
      height: 44.h_pt_cj,
      cornerRadius: 22.h_pt_cj,
      bgColorType: ThemeBGType.theme,
      title: "分享XXX",
      // titleStyle: RegularTextStyle(fontSize: 12),
      onPressed: _clickShare,
    );
  }

  Widget _savePosterButton(BuildContext context) {
    return ThemeBGButton(
      width: 150.w_pt_cj,
      height: 44.h_pt_cj,
      cornerRadius: 22.h_pt_cj,
      bgColorType: ThemeBGType.pink,
      title: "保存海报",
      // titleStyle: RegularTextStyle(fontSize: 12),
      onPressed: () async {
        // await _screenshotCompleter.future;

        PosterShareUtil.getAndSaveScreensShot(
          context,
          screenRepaintBoundaryGlobalKey: _posterRepaintBoundaryGlobalKey,
          completeBlock: (bool isSuccess) {
            Navigator.pop(context);
          },
        );
        // BuildContext context = globalKey.currentContext!;
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return pageWidget;
        // }));
      },
    );
  }

  _clickShare() {
    bool isBlock = 0 % 2 == 0 ? true : false;
    // String imUserId = "imUserId";

    ShareDialogUtil.show(
      context,
      shareActionModels: [
        BaseActionModel.im(handle: () {
          Navigator.pop(context);
          ToastUtil.showDoing();
        }),
        BaseActionModel.wechat(handle: () {
          Navigator.pop(context);
          //
        }),
        BaseActionModel.timeline(handle: () {
          Navigator.pop(context);
          //
        }),
        BaseActionModel.poster(handle: () {
          Navigator.pop(context);

          PopupUtil.popupInBottom(
            context,
            popupViewBulider: (context) {
              return TSSharePopupContainer(
                contentWidgetGetBlock: () {
                  // 获取屏幕的宽度和高度
                  double screenWidth = MediaQuery.of(context).size.width;
                  // double screenHeight = MediaQuery.of(context).size.height;

                  return Container(
                    color: Colors.green,
                    child: Image.asset(
                      "images/wish/wish_rank_bg.png",
                      fit: BoxFit.cover,
                      width: screenWidth - 2 * 30,
                    ),
                  );
                },
              );
            },
          );
        }),
        BaseActionModel.poster(handle: () {
          Navigator.pop(context);

          PosterShareUtil.getAndSaveScreensShot(
            context,
            screenRepaintBoundaryGlobalKey: _posterRepaintBoundaryGlobalKey,
            completeBlock: (bool isSuccess) {
              Navigator.pop(context);
            },
          );
        }),
      ],
      operateActionModels: [
        BaseActionModel.copyLink(handle: () {
          CopyLinkShareUtil.copyLink(
            context,
            getShareTextBlock: () async {
              return Future.value("abc");
            },
          );
        }),
        BaseActionModel.block(
          isBlock: isBlock,
          handle: () {
            // if (isBlock) {
            //   ChatUtil.unblock(imUserId);
            // } else {
            //   ChatUtil.unblock(imUserId);
            // }
          },
        ),
      ],
    );
  }
}
