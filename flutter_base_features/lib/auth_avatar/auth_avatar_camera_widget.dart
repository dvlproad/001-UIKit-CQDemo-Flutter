/*
 * @Author: dvlproad
 * @Date: 2024-04-25 16:53:01
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-21 15:48:32
 * @Description: 头像认证-2摄像头头像拍摄页
 */
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log_with_env/flutter_log_with_env.dart';

import '../flutter_base_features_adapt.dart';

// 参考 CameraExampleHome
class AuthAvatarCameraWidget extends StatefulWidget {
  final void Function() onTapClose;
  final void Function({required String avatarLocalPath}) takePhotoCompleteBlock;
  const AuthAvatarCameraWidget({
    Key? key,
    required this.onTapClose,
    required this.takePhotoCompleteBlock,
  }) : super(key: key);

  @override
  State<AuthAvatarCameraWidget> createState() => _AuthAvatarCameraWidgetState();
}

class _AuthAvatarCameraWidgetState extends State<AuthAvatarCameraWidget> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  int mCameraId = 1; //0后置 1前置

  @override
  void initState() {
    initCameras();
    super.initState();
  }

  //初始化相机
  initCameras() async {
    try {
      cameras = await availableCameras();
    } catch (error) {
      var map = {"description": error};
      AppLogUtil.logMessage(
        logType: LogObjectType.other,
        logLevel: LogLevel.error,
        shortMap: map,
        detailMap: map,
      );
    }
    onCameraSwitch();
  }

  /// 设置相机 以及摄像头正反面
  Future<void> onCameraSwitch() async {
    final CameraDescription? cameraDescription = cameras?[mCameraId];
    if (controller != null) {
      await controller?.dispose();
    }
    if (cameraDescription == null) {
      return;
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    try {
      await controller?.initialize();
    } on CameraException catch (error) {
      var map = {"errorCode": error.code, "description": error.description};
      AppLogUtil.logMessage(
        logType: LogObjectType.other,
        logLevel: LogLevel.error,
        shortMap: map,
        detailMap: map,
      );
    }

    if (!mounted) return;
    setState(() {});
  }

  //拍照
  onTakePictureButtonPressed(context) async {
    try {
      isPicture = true;
      //拍摄
      final XFile? result = await controller?.takePicture();
      if (result != null) {
        memoryUrl = result.path;
        widget.takePhotoCompleteBlock(avatarLocalPath: memoryUrl);
      }
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      isPicture = false;
      setState(() {});
      var map = {"description": error};
      AppLogUtil.logMessage(
        logType: LogObjectType.other,
        logLevel: LogLevel.error,
        shortMap: map,
        detailMap: map,
      );
    }
  }

  bool isPicture = false;
  late String memoryUrl;

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const SizedBox.shrink();
    }

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    final double screenHeight = mediaQueryData.size.height;
    // final double paddingTop = mediaQueryData.padding.top;
    final double paddingBottom = mediaQueryData.padding.bottom;

    Widget cameraWidget = CameraPreview(controller!);

    return WillPopScope(
      onWillPop: () async => false,
      child: SizedBox(
        height: screenHeight,
        child: Stack(
          children: [
            if (!isPicture)
              controller == null || !(controller?.value.isInitialized ?? false)
                  ? Container()
                  : cameraWidget,
            // : CameraPreview(controller),
            if (isPicture)
              Positioned(
                top: -50.h_pt_cj,
                child: Image.asset(
                  memoryUrl,
                  width: screenWidth,
                  height: screenHeight,
                ),
              ),
            Positioned(
              top: -230.h_pt_cj,
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: _TopBackClipper(
                  clipWidth: 304.w_pt_cj,
                  borderRadius: 152.w_pt_cj,
                ),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: -230.h_pt_cj,
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: _BottomBackClipper(
                  clipWidth: 304.w_pt_cj,
                  borderRadius: 152.w_pt_cj,
                ),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
                bottom: 58.5.h_pt_cj,
                left: 0,
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    children: [
                      Text(
                        "请确保您的正脸全部显示在识别区域 ",
                        style: TextStyle(
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff2b2b47),
                          fontSize: 16.f_pt_cj,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        "请确保画面中仅有你一人",
                        style: TextStyle(
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff2b2b47),
                          fontSize: 16.f_pt_cj,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 30.h_pt_cj),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15.w_pt_cj,
                          right: 15.w_pt_cj,
                        ),
                        child: Image.asset(
                          'assets/auth_avatar/verify_icons.png',
                          width: MediaQuery.of(context).size.width * 0.9,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: paddingBottom + 70.h_pt_cj),
                    ],
                  ),
                )),
            Positioned(
              left: 0,
              right: 0,
              child: _renderAppbar(),
            ),
            Positioned(
              bottom: paddingBottom + 15.h_pt_cj,
              left: 15.h_pt_cj,
              child: InkWell(
                onTap: () {
                  onTakePictureButtonPressed(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 345.h_pt_cj,
                  height: 40.h_pt_cj,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFFE67D4F),
                  ),
                  child: Text(
                    "拍照认证",
                    style: TextStyle(
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 15.h_pt_cj,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _renderAppbar() {
    final double paddingTop = MediaQuery.of(context).padding.top;
    // final double paddingTop = 40.h_pt_cj;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.onTapClose,
          child: Container(
            width: 60.h_pt_cj,
            padding: EdgeInsets.only(
              left: 15.h_pt_cj,
              top: paddingTop + 10.h_pt_cj,
              bottom: 15.h_pt_cj,
            ),
            child: Text(
              "取消",
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: const Color(0xff333333),
                fontSize: 16.h_pt_cj,
                height: 1,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: paddingTop + 10.h_pt_cj,
            bottom: 15.h_pt_cj,
          ),
          child: Text(
            "真实头像验证",
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.bold,
              color: const Color(0xff333333),
              fontSize: 16.h_pt_cj,
              height: 1,
            ),
          ),
        ),
        Container(width: 60.h_pt_cj),
      ],
    );
  }
}

class _TopBackClipper extends CustomClipper<Path> {
  final double _clipWidth;
  final double _borderRadius;

  _TopBackClipper({required double clipWidth, required double borderRadius})
      : _clipWidth = clipWidth,
        _borderRadius = borderRadius;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height / 2 + 0.1);
    path.lineTo(size.width / 2 - _clipWidth / 2, size.height / 2 + 0.1);
    path.lineTo(size.width / 2 - _clipWidth / 2,
        size.height / 2 - _clipWidth / 2 + _borderRadius);
    //左上角
    path.arcToPoint(
        Offset(size.width / 2 - _clipWidth / 2 + _borderRadius,
            size.height / 2 - _clipWidth / 2),
        radius: Radius.circular(_borderRadius));
    path.lineTo(size.width / 2 + _clipWidth / 2 - _borderRadius,
        size.height / 2 - _clipWidth / 2);
    //右上角
    path.arcToPoint(
        Offset(size.width / 2 + _clipWidth / 2,
            size.height / 2 - _clipWidth / 2 + _borderRadius),
        radius: Radius.circular(_borderRadius));
    path.lineTo(size.width / 2 + _clipWidth / 2, size.height / 2 + 0.1);
    path.lineTo(size.width, size.height / 2 + 0.1);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _BottomBackClipper extends CustomClipper<Path> {
  final double _clipWidth;
  final double _borderRadius;

  _BottomBackClipper({required double clipWidth, required double borderRadius})
      : _clipWidth = clipWidth,
        _borderRadius = borderRadius;

  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height / 2);
    path.lineTo(size.width / 2 - _clipWidth / 2, size.height / 2);
    path.lineTo(size.width / 2 - _clipWidth / 2,
        size.height / 2 + _clipWidth / 2 - _borderRadius);
    //左下角
    path.arcToPoint(
        Offset(size.width / 2 - _clipWidth / 2 + _borderRadius,
            size.height / 2 + _clipWidth / 2),
        radius: Radius.circular(_borderRadius),
        clockwise: false);
    path.lineTo(size.width / 2 + _clipWidth / 2 - _borderRadius,
        size.height / 2 + _clipWidth / 2);
    //右下角
    path.arcToPoint(
        Offset(size.width / 2 + _clipWidth / 2,
            size.height / 2 + _clipWidth / 2 - _borderRadius),
        radius: Radius.circular(_borderRadius),
        clockwise: false);
    path.lineTo(size.width / 2 + _clipWidth / 2, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
