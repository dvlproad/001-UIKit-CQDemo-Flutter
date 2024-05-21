// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-25 16:53:01
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-21 16:01:54
 * @Description: 头像认证-1引导页
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_image_basekit/flutter_image_kit.dart';

import '../flutter_base_features_adapt.dart';

class AuthAvatarGuideWidget extends StatelessWidget {
  final String avatar;
  final bool avatarAuthPass;
  final void Function() onTapAuth;
  final void Function() onTapAvatar;
  final void Function() onTapClose;
  const AuthAvatarGuideWidget({
    Key? key,
    required this.avatar,
    required this.avatarAuthPass, // 当前头像是否认证通过
    required this.onTapAuth,
    required this.onTapAvatar,
    required this.onTapClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final double screenWidth = deviceSize.width;
    // final double screenHeight = deviceSize.height;
    // final double paddingTop = MediaQuery.of(context).padding.top;
    final double paddingBottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: screenWidth,
            height: 420.h_pt_cj + paddingBottom,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7.5.w_pt_cj),
                  topLeft: Radius.circular(7.5.w_pt_cj)),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h_pt_cj),
                _renderAvatarAndChangeButton(),
                SizedBox(height: 15.h_pt_cj),
                Text(
                  '请上传本人高清正面照',
                  style: TextStyle(
                    color: const Color(0xff404040),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.f_pt_cj,
                  ),
                ),
                SizedBox(height: 10.h_pt_cj),
                _renderMessage(),
                SizedBox(height: 20.h_pt_cj),
                _renderVerifySamples(context),
              ],
            ),
          ),
          Positioned(
            top: 0.h_pt_cj,
            right: 0,
            child: InkWell(
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
            ),
          ),
          Positioned(
            bottom: 8.h_pt_cj + paddingBottom,
            left: 15.w_pt_cj,
            child: _renderAuthButton(),
          )
        ],
      ),
    );
  }

  Widget _renderAvatarAndChangeButton() {
    return _renderAvatarAndChangeButton_new();
    // ignore: dead_code
    return InkWell(
      onTap: onTapAvatar,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(45.w_pt_cj)),
                ),
                padding: EdgeInsets.all(1.w_pt_cj),
                child: TolerantNetworkImage(
                  imageUrl: avatar,
                  width: 86.w_pt_cj,
                  height: 86.w_pt_cj,
                  borderRadius: BorderRadius.circular(43.w_pt_cj),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(5.w_pt_cj),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7956A),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.w_pt_cj),
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 12.5.w_pt_cj,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderAvatarAndChangeButton_new() {
    return InkWell(
      onTap: onTapAvatar,
      child: Column(
        children: [
          TolerantNetworkImage(
            imageUrl: avatar,
            width: 100.w_pt_cj,
            height: 100.w_pt_cj,
            borderRadius: BorderRadius.circular(8.w_pt_cj),
            fit: BoxFit.cover,
          ),
          SizedBox(height: 6.h_pt_cj),
          CJButton(
            width: 100.w_pt_cj,
            height: 30.h_pt_cj,
            // onPressed: onTapAvatar, // 这里不设置，可实现透传
            normalConfig: CJButtonConfigModel(
              textColor: Colors.white,
              bgColor: Colors.black,
            ),
            title: "更换头像",
            titleStyle: BoldTextStyle(fontSize: 14.f_pt_cj),
            imageWidget: Image(
              width: 18.w_pt_cj,
              height: 18.h_pt_cj,
              image: const AssetImage(
                "assets/auth_avatar/btn_avatar_take.png",
                package: "flutter_base_features",
              ),
            ),
          ),
        ],
      ),
    );
  }

  _renderMessage() {
    if (avatarAuthPass) {
      // 更换的时候给与红色提醒注意
      return Container(
        alignment: Alignment.center,
        height: 28.h_pt_cj,
        width: 375.w_pt_cj,
        color: const Color(0xffFFF2F2),
        child: Text(
          "头像不符合平台要求，请上传清晰的本人真实照片",
          style: MediumTextStyle(
            color: Colors.red,
            fontSize: 14.f_pt_cj,
          ),
        ),
      );
    }

    return Text(
      "上传五官清晰的照片，会更受欢迎哦～",
      style: MediumTextStyle(
        color: const Color(0xff999999),
        fontSize: 14.f_pt_cj,
      ),
    );
  }

  _renderVerifySamples(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w_pt_cj),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: 1, color: const Color(0xffD8D8D8)),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w_pt_cj),
                child: Text(
                  "错误示范",
                  style: RegularTextStyle(
                    fontSize: 14.f_pt_cj,
                    color: const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h_pt_cj),
        // ignore: avoid_unnecessary_containers
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 15.w_pt_cj),
          child: Image.asset(
            'assets/auth_avatar/verify_samples.png',
            package: "flutter_base_features",
            height: 60.f_pt_cj,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }

  Widget _renderAuthButton() {
    return InkWell(
      onTap: onTapAuth,
      child: Container(
        alignment: Alignment.center,
        width: 345.w_pt_cj,
        height: 48.w_pt_cj,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w_pt_cj),
          color: Colors.black,
        ),
        child: Text(
          avatarAuthPass ? "更换头像" : "开始认证",
          style: MediumTextStyle(
            color: Colors.white,
            fontSize: 16.w_pt_cj,
          ),
        ),
      ),
    );
  }
}
