/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 16:54:12
 * @Description: 
 */

import 'package:flutter/material.dart';

import 'package:flutter_share_kit/flutter_share_kit.dart';
import 'package:flutter_share_kit/flutter_share_kit_adapt.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import 'ts_share_popup_container.dart';

class PosterPopupPage extends StatefulWidget {
  final void Function(BuildContext context)? firstFrameCompleteBack;
  final Widget Function() contentWidgetGetBlock;

  const PosterPopupPage({
    Key? key,
    this.firstFrameCompleteBack,
    required this.contentWidgetGetBlock,
  }) : super(key: key);

  @override
  State<PosterPopupPage> createState() => _PosterPopupPageState();
}

class _PosterPopupPageState extends State<PosterPopupPage> {
  final GlobalKey _screenRepaintBoundaryGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NormalPosterWidget(
      posterWidgetGetBlock: (BuildContext context) {
        return TSSharePopupContainer(
          contentWidgetGetBlock: widget.contentWidgetGetBlock,
        );
      },
      posterRepaintBoundaryGlobalKey: _screenRepaintBoundaryGlobalKey,
      noposterWidgetGetBlock: (context, {required}) {
        return buildButtonsWidget(context);
      },
    );
  }

  Positioned buildButtonsWidget(BuildContext context) {
    MediaQueryData mediaData = MediaQuery.of(context);
    double screenWidth = mediaData.size.width;
    double screenHeight = mediaData.size.height;
    double screenPaddingTop = mediaData.padding.top;
    double screenPaddingBottom = mediaData.padding.bottom;

    return Positioned(
      bottom: screenPaddingBottom + 140.h_pt_cj,
      child: Column(
        children: [
          _saveButton(context),
        ],
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return ThemeBGButton(
      width: 300.w_pt_cj,
      height: 44.h_pt_cj,
      cornerRadius: 22.h_pt_cj,
      bgColorType: ThemeBGType.pink,
      title: "保存海报",
      // titleStyle: RegularTextStyle(fontSize: 12),
      onPressed: () async {
        // await _screenshotCompleter.future;

        PosterShareUtil.getAndSaveScreensShot(
          context,
          screenRepaintBoundaryGlobalKey: _screenRepaintBoundaryGlobalKey,
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
}
