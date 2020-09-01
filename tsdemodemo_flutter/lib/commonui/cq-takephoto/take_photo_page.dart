// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class TakePhotoPage extends StatefulWidget {
//   TakePhotoPage({Key key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _TakePhotoPageState();
//   }
// }

// List<CameraDescription> cameras = [];

// class _TakePhotoPageState extends State<TakePhotoPage> {
//   CameraController controller;

//   CameraLensDirection _selectDirection;

//   @override
//   void initState() {
//     super.initState();

//     initializeData();
//   }

//   Future<void> initializeData() async {
//     cameras = await availableCameras();

//     _selectDirection = CameraLensDirection.back;

//     setState(() {});

//     selectCameraDirection(_selectDirection);

//     disabledLoading();
//   }

//   ///打开摄像头
//   void selectCameraDirection(CameraLensDirection direction) {
//     for (CameraDescription cameraDescription in cameras) {
//       if (cameraDescription.lensDirection == direction) {
//         onNewCameraSelected(cameraDescription);
//         return;
//       }
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void onNewCameraSelected(CameraDescription cameraDescription) async {
//     if (controller != null) {
//       await controller.dispose();
//     }
//     controller = CameraController(cameraDescription, ResolutionPreset.high);

//     controller.addListener(() {
//       if (mounted) setState(() {});
//       if (controller.value.hasError) {
//         LogUtil.v('相机错误 ${controller.value.errorDescription}');
//       }
//     });

//     try {
//       await controller.initialize();
//     } on CameraException catch (e) {
//       LogUtil.v('相机初始化错误 ${e.toString()}');
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   PreferredSizeWidget appBar() {
//     return null;
//   }

//   @override
//   Widget topWidget() {
//     return Container(
//       height: kToolbarHeight + ScreenUtil.statusBarHeight,
//       child: CenterAppBar(
//           backgroundColor: Colors.black.withOpacity(.3),
//           title: Text(LangUtil.l("EDITOR_MEDIA_PHOTO_TITLE"))),
//     );
//   }

//   @override
//   Widget bottomWidget() {
//     var indexTabbarNotifier =
//         Provider.of<MediaEditorIndexTabbarNotifier>(context);
//     return Positioned(
//         left: 0,
//         right: 0,
//         bottom: 0,
//         child: SizedBox(
//           height: ScreenConfig().bottombarHeight,
//           child: BottomNavigationBar(
//             elevation: 0,
//             backgroundColor: Colors.black.withOpacity(.3),
//             type: BottomNavigationBarType.fixed,
//             currentIndex: indexTabbarNotifier.currentIndex,
//             items: bottomTabs,
//             onTap: (index) {
//               indexTabbarNotifier.changeIndex(index);
//             },
//           ),
//         ));
//   }

//   @override
//   Widget buildWidget(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     final size = MediaQuery.of(context).size;
//     final deviceRatio = size.width / size.height;
//     return Stack(children: <Widget>[
//       Center(
//         child: Transform.scale(
//           scale: controller.value.aspectRatio / deviceRatio,
//           child: AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: CameraPreview(controller),
//           ),
//         ),
//       ),
//       _toolWidget(),
//     ]);
//   }

//   Widget _toolWidget() {
//     return Positioned(
//         bottom: ScreenConfig().bottombarHeight,
//         child: Container(
//           height: 150,
//           width: ScreenUtil.screenWidth,
//           color: Colors.black.withOpacity(.3),
//           child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 SizedBox(width: 50, child: _cutoverCameraWidget()),
//                 _cameraPlayWidget(),
//                 SizedBox(width: 50),
//               ]),
//         ));
//   }

//   Widget _cameraPlayWidget() {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<CameraPlayNofitier>(
//             create: (_) => CameraPlayNofitier()),
//       ],
//       child: CameraPlayWidget(
//         radius: 40,
//         strokeWidth: 4,
//         onPressed: takePhoto,
//       ),
//     );
//   }

//   Widget _cutoverCameraWidget() {
//     return InkWell(
//       onTap: _cutoverCamera,
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               C1440Icon.icon_cameracutover,
//               color: Colors.white,
//               size: 30,
//             ),
//             SizedBox(height: 8),
//             Text(LangUtil.l("EDITOR_MEDIA_PHOTO_SWITCH")),
//           ]),
//     );
//   }

//   //拍照
//   Future<void> takePhoto() async {
//     var tabbar =
//         Provider.of<MediaEditorIndexTabbarNotifier>(context, listen: false);

//     try {
//       final path = join(
//         (await getTemporaryDirectory()).path,
//         '${DateTime.now().millisecondsSinceEpoch.toString()}.png',
//       );
//       await controller.takePicture(path);
//       Routes.navigateTo(context, Routes.updateMediaPage, params: {
//         "fileType": "1",
//         "filePath": path,
//         "playlistID": tabbar.playlistID ?? "",
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   ///切换前置摄像头,后置摄像头
//   void _cutoverCamera() {
//     if (controller != null &&
//         controller.value.isInitialized &&
//         !controller.value.isRecordingVideo) {
//       if (_selectDirection == CameraLensDirection.front) {
//         _selectDirection = CameraLensDirection.back;
//       } else {
//         _selectDirection = CameraLensDirection.front;
//       }

//       selectCameraDirection(_selectDirection);
//     } else {
//       AppUtil.makeToast("无法切换");
//     }
//   }
// }
