/*
 * @Author: dvlproad
 * @Date: 2024-04-25 15:59:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-21 15:48:58
 * @Description: 头像认证-3认证状态页(认证中、认证成功、认证失败)
 */
import 'package:flutter/material.dart';

import '../flutter_base_features_adapt.dart';

enum VerityResult {
  loading, // "头像认证中"
  success, // "已完成真实头像认证"
  fail, // "头像认证失败"
}

class AuthAvatarStepWidget extends StatelessWidget {
  final VerityResult status;
  final String? tips;
  final void Function() onTapClose;
  final void Function() onTapReAuth;

  final String successTitle;
  final void Function() onTapSuccess;

  const AuthAvatarStepWidget({
    Key? key,
    required this.status,
    this.tips,
    required this.onTapClose,
    required this.onTapReAuth, // 失败的时候，点击重新认证
    required this.successTitle, // 成功时候，按钮显示的文案(用于提醒用户接下去的是什么操作，PS:只有success和failure才有按钮)
    required this.onTapSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final double screenWidth = deviceSize.width;
    // final double screenHeight = deviceSize.height;
    // final double paddingTop = MediaQuery.of(context).padding.top;
    // final double paddingBottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 276.h_pt_cj,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 43.h_pt_cj,
            child: Container(
              width: screenWidth,
              height: 233.h_pt_cj,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7.5.w_pt_cj),
                    topLeft: Radius.circular(7.5.w_pt_cj)),
              ),
            ),
          ),
          Positioned(
            top: 46.h_pt_cj,
            right: 0,
            child: status != VerityResult.loading
                ? InkWell(
                    onTap: onTapClose,
                    child: Padding(
                      padding: EdgeInsets.all(15.w_pt_cj),
                      child: Image.asset(
                        "assets/auth_avatar/close_icon.png",
                        package: "flutter_base_features",
                        color: const Color(0xff000000),
                        width: 17.5.w_pt_cj,
                        height: 17.5.w_pt_cj,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          _renderResult(status, tips),
          _renderSuccessOrFailurePositioned(status),
        ],
      ),
    );
  }

  _renderSuccessOrFailurePositioned(VerityResult status) {
    return Visibility(
      visible: status == VerityResult.success || status == VerityResult.fail,
      child: Positioned(
        bottom: 42.h_pt_cj,
        left: 15.w_pt_cj,
        child: InkWell(
          onTap: status == VerityResult.success ? onTapSuccess : onTapReAuth,
          child: Container(
            alignment: Alignment.center,
            width: 345.w_pt_cj,
            height: 36.h_pt_cj,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFFE67D4F),
            ),
            child: Text(
              status == VerityResult.success ? successTitle : "重新认证",
              style: MediumTextStyle(
                color: Colors.white,
                fontSize: 15.w_pt_cj,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _renderResult(VerityResult status, String? tips) {
    if (status == VerityResult.loading) {
      return Column(
        children: [
          Image.asset(
            "assets/auth_avatar/auth_await_icon.png",
            package: "flutter_base_features",
            width: 86.h_pt_cj,
            height: 86.h_pt_cj,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 35.h_pt_cj),
          Text(
            "认证中",
            style: BoldTextStyle(
              fontSize: 17.f_pt_cj,
              color: const Color(0xff404040),
              height: 1,
            ),
          ),
          SizedBox(height: 10.h_pt_cj),
          Text(
            "真实头像认证中，请稍后",
            style: MediumTextStyle(
              color: const Color(0xff8b8b8b),
              fontSize: 13.f_pt_cj,
              height: 1,
            ),
          )
        ],
      );
    } else if (status == VerityResult.success) {
      return Column(
        children: [
          Image.asset(
            "assets/auth_avatar/auth_succeed_icon.png",
            package: "flutter_base_features",
            width: 86.h_pt_cj,
            height: 86.h_pt_cj,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 35.h_pt_cj),
          Text(
            "认证成功",
            style: BoldTextStyle(
              fontSize: 17.f_pt_cj,
              color: const Color(0xff404040),
              height: 1,
            ),
          ),
          SizedBox(height: 15.w_pt_cj),
          Text(
            "恭喜您完成真实头像认证，可以享受相关特权",
            style: MediumTextStyle(
              color: const Color(0xff8b8b8b),
              fontSize: 12.w_pt_cj,
              height: 1,
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Image.asset(
            "assets/auth_avatar/auth_faild_icon.png",
            package: "flutter_base_features",
            width: 86.h_pt_cj,
            height: 86.h_pt_cj,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 35.h_pt_cj),
          Text(
            "认证失败",
            style: BoldTextStyle(
              fontSize: 17.f_pt_cj,
              color: const Color(0xff404040),
              height: 1,
            ),
          ),
          SizedBox(height: 10.h_pt_cj),
          SizedBox(
            width: 250.w_pt_cj,
            child: Column(
              children: [
                (tips?.isNotEmpty ?? true)
                    ? Text(
                        tips ?? "",
                        style: MediumTextStyle(
                          color: const Color(0xff8b8b8b),
                          fontSize: 12.w_pt_cj,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      )
                    : Column(
                        children: [
                          Text(
                            "请确保您的正脸全部显示在识别区域",
                            style: MediumTextStyle(
                              color: const Color(0xff8b8b8b),
                              fontSize: 12.w_pt_cj,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "请确保画面中仅有你一人",
                            style: MediumTextStyle(
                              color: const Color(0xff8b8b8b),
                              fontSize: 12.w_pt_cj,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
