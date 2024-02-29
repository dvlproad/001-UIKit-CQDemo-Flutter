/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-29 09:41:32
 * @Description: 
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../flutter_share_kit_adapt.dart';
import './share_poster_util.dart';

class SharePosterWidget extends StatefulWidget {
  final void Function(BuildContext context)? firstFrameCompleteBack;
  final Widget Function() contentWidgetGetBlock;

  const SharePosterWidget({
    Key? key,
    this.firstFrameCompleteBack,
    required this.contentWidgetGetBlock,
  }) : super(key: key);

  @override
  State<SharePosterWidget> createState() => _SharePosterWidgetState();
}

class _SharePosterWidgetState extends State<SharePosterWidget> {
  final GlobalKey _repaintBoundaryGlobalKey = GlobalKey();

  Uint8List? _screenshotBytes;
  // Completer _screenshotCompleter = Completer();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_repaintBoundaryGlobalKey.currentContext != null) {
        if (widget.firstFrameCompleteBack != null) {
          widget.firstFrameCompleteBack!(
              _repaintBoundaryGlobalKey.currentContext!);
        }
      }
    });
  }

  /*
  getScreenShot(BuildContext context) async {
    if (_screenshotCompleter.isCompleted) {
      return;
    }
    _screenshotBytes = await SharePosterUtil.getScreensShot(context);

    if (!_screenshotCompleter.isCompleted) {
      _screenshotCompleter.complete();
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _repaintBoundaryGlobalKey,
      child: contentWidget(context),
    );
  }

  Widget contentWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pop(context);
      },
      child: Container(
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
                child: widget.contentWidgetGetBlock(),
              ),
            ),
            Container(height: 40.h_pt_cj),
            ThemeBGButton(
              width: 300.w_pt_cj,
              height: 44.h_pt_cj,
              cornerRadius: 22.h_pt_cj,
              bgColorType: ThemeBGType.pink,
              title: "保存海报",
              // titleStyle: RegularTextStyle(fontSize: 12),
              onPressed: () async {
                // await _screenshotCompleter.future;
                _screenshotBytes =
                    await SharePosterUtil.getScreensShot(context);

                if (_screenshotBytes == null) {
                  return;
                }

                SharePosterUtil.saveScreensShot(
                  context,
                  pngBytes: _screenshotBytes!,
                  saveCompleteBlock: () {
                    Navigator.pop(context);
                  },
                );
                // BuildContext context = globalKey.currentContext!;
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                //   return pageWidget;
                // }));
              },
            ),
            Container(height: 140.h_pt_cj),
          ],
        ),
      ),
    );
  }
}
