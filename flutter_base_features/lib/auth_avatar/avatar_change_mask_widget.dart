// 头像改变的前置视图
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_basekit/flutter_image_kit.dart';

import '../flutter_base_features_adapt.dart';

class AvatarChangeMaskWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String avatarUrl;
  final Widget Function(double widgetSize)? customAvatarWidgetBuilder;
  final void Function() onTapRechoose;
  final void Function() onTapConfirm;
  final void Function() onTapClose;

  AvatarChangeMaskWidget({
    this.width,
    this.height,
    required this.avatarUrl,
    this.customAvatarWidgetBuilder,
    required this.onTapRechoose,
    required this.onTapConfirm,
    required this.onTapClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddintTop = MediaQueryData.fromWindow(window).padding.top;

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          color: Colors.black,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: paddintTop + 74.h_pt_cj),
              _renderAvatarWidget(context),
              SizedBox(height: 28.h_pt_cj),
              Text(
                "将您的正脸显示在居中位置\n效果更好哦～",
                style: MediumTextStyle(
                  color: Colors.white,
                  fontSize: 15.w_pt_cj,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60.w_pt_cj),
              InkWell(
                onTap: onTapConfirm,
                child: Container(
                  width: 255.w_pt_cj,
                  height: 36.w_pt_cj,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE67D4F),
                    borderRadius: BorderRadius.circular(20.w_pt_cj),
                  ),
                  child: Text(
                    "确认修改",
                    style: MediumTextStyle(
                      color: Colors.white,
                      fontSize: 15.w_pt_cj,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.w_pt_cj),
              InkWell(
                onTap: onTapRechoose,
                child: Container(
                  width: 255.w_pt_cj,
                  height: 36.w_pt_cj,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.w_pt_cj),
                  ),
                  child: Text(
                    "重新选择图片",
                    style: MediumTextStyle(
                      color: const Color(0xFF8b8b8b),
                      fontSize: 15.w_pt_cj,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 20.w_pt_cj,
          top: 60.w_pt_cj,
          child: InkWell(
            onTap: onTapClose,
            child: Image.asset(
              'assets/auth_avatar/comon_close.png',
              package: "flutter_base_features",
              color: Colors.white,
              width: 20.w_pt_cj,
              height: 20.h_pt_cj,
            ),
          ),
        ),
        Positioned(
          top: paddintTop + 74.h_pt_cj,
          left: 0,
          right: 0,
          child: Container(
            width: outerCircleSize,
            height: outerCircleSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(outerCircleSize * 0.5),
              ),
              image: const DecorationImage(
                image: AssetImage(
                  "assets/auth_avatar/avatar_mask_cover.png",
                  package: "flutter_base_features",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final double outerCircleSize = 295.w_pt_cj;
  _renderAvatarWidget(BuildContext context) {
    if (customAvatarWidgetBuilder != null) {
      return customAvatarWidgetBuilder!(outerCircleSize);
    }

    double innerCircleSize = outerCircleSize;
    return GestureDetector(
      onTap: null, // 确保外部传null时候可以透传事件
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: outerCircleSize,
            height: outerCircleSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(outerCircleSize * 0.5),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(innerCircleSize * 0.5),
              ),
              child: TolerantNetworkImage(
                imageUrl: avatarUrl,
                width: innerCircleSize,
                height: innerCircleSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
