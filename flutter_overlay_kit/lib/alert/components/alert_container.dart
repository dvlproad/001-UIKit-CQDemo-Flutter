/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 11:16:39
 * @Description: 基础的 MessageAlert 部分
 */
import 'package:flutter/material.dart';
import '../../flutter_overlay_kit_adapt.dart';

class CQAlertContainer extends StatelessWidget {
  final double? height;

  final Widget contentWidget;
  final double? buttonsWidgetHeight;
  final Widget? buttonsWidget;
  final Function? closeHandle;
  final bool barrierDismissible;
  final bool showCloseButton;

  CQAlertContainer({
    Key? key,
    this.height,
    required this.contentWidget,
    this.buttonsWidgetHeight,
    this.buttonsWidget,
    this.closeHandle,
    this.barrierDismissible = true,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double contentWidth = 290.w_pt_cj;
    return GestureDetector(
      onTap: () {
        if (barrierDismissible) {
          if (closeHandle != null) {
            closeHandle!();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Container(
        width: width,
        height: this.height,
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: contentWidth,
                  constraints: BoxConstraints(
                    //minWidth: double.infinity,
                    minHeight: 160,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w_pt_cj),
                    color: Color(0xffffffff),
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter, //指定未定位或部分定位widget的对齐方式
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          bottom: this.buttonsWidgetHeight ?? 80.h_pt_cj,
                        ),
                        child: Column(
                          children: <Widget>[
                            this.contentWidget,
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          // color: Colors.red,
                          width: contentWidth,
                          child: this.buttonsWidget,
                        ),
                      ),
                      Positioned(
                        top: 10.w_pt_cj,
                        right: 10.w_pt_cj,
                        child: Visibility(
                          visible: showCloseButton,
                          child: GestureDetector(
                            onTap: () {
                              if (closeHandle != null) {
                                closeHandle!();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Image(
                              image: AssetImage(
                                'assets/icon_close2.png',
                                package: 'flutter_overlay_kit',
                              ),
                              width: 21.w_pt_cj,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
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
}
