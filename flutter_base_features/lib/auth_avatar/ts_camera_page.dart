import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log_with_env/flutter_log_with_env.dart';
// import 'package:flutter_effect_kit/flutter_effect_kit.dart';

import '../flutter_base_features_adapt.dart';

class CameraExampleHome extends StatefulWidget {
  const CameraExampleHome({Key? key}) : super(key: key);

  @override
  State<CameraExampleHome> createState() => _CameraExampleHomeState();
}

class _CameraExampleHomeState extends State<CameraExampleHome> {
  late List<CameraDescription> cameras;
  late CameraController? controller;
  int mCameraId = 1; //0后置 1前置

  @override
  void initState() {
    initCameras();
    super.initState();
  }

  //初始化相机
  initCameras() async {
    await getCameras();
    onCameraSwitch();
  }

  //获取相机
  Future<void> getCameras() {
    return availableCameras().then((value) {
      cameras = value;
      if (!cameras.isNotEmpty) {
        var errorMap = {"message": "相机获取失败，请检查相机权限"};
        AppLogUtil.logMessage(
            logType: LogObjectType.other,
            logLevel: LogLevel.error,
            shortMap: errorMap,
            detailMap: errorMap);
      }
    });
  }

  /// 设置相机 以及摄像头正反面
  Future<void> onCameraSwitch() async {
    final CameraDescription cameraDescription = cameras[mCameraId];
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    try {
      await controller?.initialize();
    } on CameraException catch (e) {
      debugPrint(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  //拍照
  void onTakePictureButtonPressed(context) async {
    try {
      //拍摄
      // final dateTime = DateTime.now(); //以时间为图片名称处理
      // final path = join((await getApplicationDocumentsDirectory()).path,
      //     '${dateTime.millisecondsSinceEpoch}.png');
      final result = await controller?.takePicture();
      if (result != null) {
        croppedFile(context, result);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  //裁剪框
  croppedFile(context, pickedFile) async {
    CroppedFile? croppedFile;

    if (pickedFile != null) {
      // LoadingUtil.showDongingTextInContext(context, "编辑加载中");
      // 该组件文档参考 https://pub.flutter-io.cn/packages/image_cropper
      croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        cropStyle: CropStyle.circle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '头像编辑',
            toolbarColor: const Color(0xFFE67D4F),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            // lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: '头像编辑',
            aspectRatioPickerButtonHidden: true,
            cancelButtonTitle: "重拍",
            doneButtonTitle: "完成裁剪",
          ),
        ],
      );
      if (croppedFile != null) {
        Navigator.pop(context);
      }
      // LoadingUtil.dismissDongingTextInContext(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final double screenWidth = deviceSize.width;
    // final double screenHeight = deviceSize.height;
    // final double paddingTop = MediaQuery.of(context).padding.top;
    final double paddingBottom = MediaQuery.of(context).padding.bottom;

    Widget cameraWidget = mCameraId == 1
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CameraPreview(controller!),
          )
        : CameraPreview(controller!);
    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: controller == null ||
                        !(controller?.value.isInitialized ?? false)
                    ? Container()
                    : cameraWidget,
                // : CameraPreview(controller),
              ),
              Container(
                width: screenWidth,
                padding: EdgeInsets.only(
                  top: 20.w_pt_cj,
                  bottom: 20.w_pt_cj + paddingBottom,
                ),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: screenWidth / 3,
                        alignment: Alignment.center,
                        child: Text(
                          '取消',
                          style: MediumTextStyle(
                            fontSize: 15.w_pt_cj,
                            color: const Color(0xFFE67D4F),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => onTakePictureButtonPressed(context),
                      child: Container(
                        width: screenWidth / 3,
                        alignment: Alignment.center,
                        child: Container(
                          width: 75.w_pt_cj,
                          height: 75.w_pt_cj,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE67D4F),
                            borderRadius: BorderRadius.all(
                              Radius.circular(75.w_pt_cj * 0.5),
                            ),
                          ),
                          child: Text(
                            '拍照',
                            style: MediumTextStyle(
                              fontSize: 15.w_pt_cj,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        mCameraId = mCameraId == 1 ? 0 : 1;
                        onCameraSwitch();
                      },
                      child: Container(
                        width: screenWidth / 3,
                        alignment: Alignment.center,
                        child: Text(
                          '翻转',
                          style: MediumTextStyle(
                            fontSize: 15.w_pt_cj,
                            color: const Color(0xFFE67D4F),
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
      ],
    );
  }
}
