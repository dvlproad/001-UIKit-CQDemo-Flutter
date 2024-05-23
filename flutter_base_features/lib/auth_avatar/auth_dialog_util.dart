/*
 * @Author: dvlproad
 * @Date: 2024-05-07 17:31:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-22 19:10:01
 * @Description: 
 */
import 'package:flutter/material.dart';

import '../flutter_base_features_adapt.dart';

class AuthDialogUtil {
  //不可以被关闭的dialog检测提示
  static showForceDialog(
    context, {
    required String title,
    bool useSafeArea = true,
    Widget? child,
  }) {
    return showDialog(
      context: context,
      useSafeArea: useSafeArea,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              _renderDialog(title),
              if (child != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: child,
                ),
            ],
          ),
        );
      },
    );
  }

  static Dialog _renderDialog(String title) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      child: Container(
        width: 20.w_pt_cj,
        height: 52.w_pt_cj,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              width: 20.w_pt_cj,
              height: 20.w_pt_cj,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Color(0xFFE67D4F)),
              ),
            ),
            SizedBox(height: 10.w_pt_cj),
            Text(
              title,
              style: MediumTextStyle(
                color: Colors.white,
                fontSize: 14.w_pt_cj,
              ),
            )
          ],
        ),
      ),
    );
  }
}
