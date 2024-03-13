/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-13 14:15:48
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_share_kit/flutter_share_kit.dart';
import 'package:flutter_share_kit/flutter_share_kit_adapt.dart';

import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class TSShareHomePage extends StatefulWidget {
  final bool currentIsPosterPage;
  const TSShareHomePage({
    Key? key,
    required this.currentIsPosterPage,
  }) : super(key: key);

  @override
  State<TSShareHomePage> createState() => _TSShareHomePageState();
}

class _TSShareHomePageState extends State<TSShareHomePage> {
  final GlobalKey _posterRepaintBoundaryGlobalKey = GlobalKey();

  late bool currentIsPosterPage;

  @override
  void initState() {
    super.initState();

    currentIsPosterPage = widget.currentIsPosterPage;
  }

  @override
  Widget build(BuildContext context) {
    return NormalPosterWidget.currentIsPosterPage(
      qrCodeWebUrl: "https://www.baidu.com/",
      qrCodePromptText: "扫码进入XXXAPP\n一起分享你的【YYYY】",
      posterRepaintBoundaryGlobalKey: _posterRepaintBoundaryGlobalKey,
      posterWidgetGetBlock: (BuildContext context) {
        return buildPosterWidget(context);
      },
      noposterWidgetGetBlock: (context, {required}) {
        return buildNoposterWidget(context);
      },
    );
  }

  Widget buildPosterWidget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 40.h_pt_cj, bottom: 40.h_pt_cj),
              child: Container(
                color: Colors.green,
                child: Image.asset(
                  "assets/poster_qrcode.png",
                  package: "flutter_share_kit",
                  fit: BoxFit.cover,
                  width: screenWidth - 2 * 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoposterWidget(BuildContext context) {
    return TSShareHomeButtons(
      saveHandle: _clickShare,
      button2Text: "保存",
      button2Handle: _clickSave,
    );
  }

  _clickSave() {
    // await _screenshotCompleter.future;

    PosterShareUtil.getAndSaveScreensShot(
      context,
      screenRepaintBoundaryGlobalKey: _posterRepaintBoundaryGlobalKey,
    ).then((value) {
      Navigator.pop(context);
    });
    // BuildContext context = globalKey.currentContext!;
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return pageWidget;
    // }));
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
        posterActionModel,
      ],
      operateActionModels: [
        BaseActionModel.copyLink(handle: () {
          CopyLinkShareUtil.copyLink(context, lastShareString: "abc");
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

  /// 分享海报的按钮
  BaseActionModel get posterActionModel {
    if (currentIsPosterPage) {
      return BaseActionModel.poster(
        title: "保存海报",
        handle: () {
          Navigator.pop(context);

          PosterShareUtil.getAndSaveScreensShot(
            context,
            screenRepaintBoundaryGlobalKey: _posterRepaintBoundaryGlobalKey,
          ).then((value) {
            Navigator.pop(context);
          });
        },
      );
    }
    return BaseActionModel.poster(handle: () {
      Navigator.pop(context);

      PopupUtil.popupInBottom(
        context,
        popupViewBulider: (context) {
          String posterBgImageUrl =
              "https://img0.baidu.com/it/u=3316636492,2799302396&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800";

          return PosterWithButtonPage.easy(
            appbarWidgetBuilder: () {
              return AppBar();
              // MediaQueryData mediaQueryData =
              //     MediaQueryData.fromWindow(window);

              // return PreferredSizeWidget();
              // return Container(
              //   padding: EdgeInsets.only(top: mediaQueryData.padding.top),
              //   child: AppBar(),
              // );
            },
            posterBgImageUrl: posterBgImageUrl,
            userImageUrl: posterBgImageUrl,
            posterTextContainerBuilder: (
                {required double halfAvatarHeight,
                required double qrCodeWidgetWidth}) {
              return Container(
                color: Colors.red,
                margin: EdgeInsets.only(
                  top: halfAvatarHeight,
                  right: qrCodeWidgetWidth,
                ),
              );
            },
            appLogoPath: 'images/share/logo_icon.png',
            qrCodeWebUrl: posterBgImageUrl,
          );
        },
      );
    });
  }
}
