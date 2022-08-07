/*
 * @Author: dvlproad
 * @Date: 2022-04-13 10:17:11
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-22 18:37:17
 * @Description: loading 单例形式的弹出方法
 * @FilePath: /wish/Users/qian/Project/Bojue/mobile_flutter_wish/flutter_effect_kit/lib/src/hud/loading_util.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './loading_widget.dart';

class FullLoadingWidget extends StatefulWidget {
  double? loadingWidth;
  double? loadingHeight;
  bool withColseButton;
  void Function()? onTapClose;

  FullLoadingWidget({
    Key? key,
    this.loadingWidth,
    this.loadingHeight,
    this.withColseButton = false,
    this.onTapClose,
  }) : super(key: key);

  @override
  State<FullLoadingWidget> createState() => FullLoadingWidgetState();
}

class FullLoadingWidgetState extends State<FullLoadingWidget> {
  bool _shouldShowColseButton = false;

  void Function()? _onTapClose;
  @override
  void initState() {
    super.initState();
    _shouldShowColseButton = widget.withColseButton;
    _onTapClose = widget.onTapClose;
  }

  showCloseButton({
    required void Function()? onTapClose,
  }) {
    setState(() {
      _onTapClose = onTapClose;
      _shouldShowColseButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double loadingWidth = widget.loadingWidth ?? 49;
    double loadingHeight = widget.loadingHeight ?? 20;
    if (_shouldShowColseButton != true) {
      return LoadingWidget(width: loadingWidth, height: loadingHeight);
    }

    double closeButtonSize = loadingHeight;
    return Container(
      width: loadingWidth + 2 + closeButtonSize,
      height: loadingHeight,
      // color: Colors.red,
      child: Row(
        children: [
          LoadingWidget(width: loadingWidth, height: loadingHeight),
          GestureDetector(
            onTap: _onTapClose,
            child: Container(
              width: closeButtonSize,
              height: closeButtonSize,
              // color: Colors.green,
              child: Image(
                image: AssetImage(
                  'assets/icon_close.png',
                  package: 'flutter_effect_kit',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
