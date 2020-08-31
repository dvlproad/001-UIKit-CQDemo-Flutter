import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottie/lottie.dart';

/// 金色校园Footer
class C1440RefreshFooter extends Footer {
  /// Key
  final Key key;

  final LinkFooterNotifier linkNotifier = LinkFooterNotifier();

  C1440RefreshFooter({
    this.key,
    bool enableHapticFeedback = false,
  }) : super(
          extent: 80.0,
          triggerDistance: 80.0,
          float: false,
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteLoad: false,
          completeDuration: const Duration(seconds: 1),
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    // 不能为水平方向以及反向
    assert(axisDirection == AxisDirection.down,
        'Widget can only be vertical and cannot be reversed');
    linkNotifier.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
    return C1440RefreshFooterWidget(
      key: key,
      linkNotifier: linkNotifier,
    );
  }
}

/// 金色校园组件
class C1440RefreshFooterWidget extends StatefulWidget {
  final LinkFooterNotifier linkNotifier;

  const C1440RefreshFooterWidget({
    Key key,
    this.linkNotifier,
  }) : super(key: key);

  @override
  C1440RefreshFooterWidgetState createState() {
    return C1440RefreshFooterWidgetState();
  }
}

class C1440RefreshFooterWidgetState extends State<C1440RefreshFooterWidget> {
  LoadMode get _loadState => widget.linkNotifier.loadState;
  double get _pulledExtent => widget.linkNotifier.pulledExtent;
  double get _indicatorExtent => widget.linkNotifier.loadIndicatorExtent;
  bool get _noMore => widget.linkNotifier.noMore;

  // // 图片资源
  // String _buildingsBase64 = "";
  // String _sunBase64 = "";
  // String _skyBase64 = "";
  // Uint8List _buildingsBytes;
  // Uint8List _sunBytes;
  // Uint8List _skyBytes;

  // 太阳旋转值
  // double _sunRotateValue;
  // // 旋转计时器
  // Timer _sunRotateTimer;
  // // 是否旋转太阳
  // bool _isRotateSun;
  // set isRotateSun(bool value) {
  //   if (_isRotateSun != value) {
  //     _isRotateSun = value;
  //     if (_isRotateSun) {
  //       _sunRotateValue = _pulledExtent;
  //       rotateSun();
  //     } else {
  //       if (_sunRotateTimer != null) {
  //         _sunRotateTimer.cancel();
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _buildingsBytes = base64Decode(_buildingsBase64);
    // _sunBytes = base64Decode(_sunBase64);
    // _skyBytes = base64Decode(_skyBase64);
    // _sunRotateValue = _pulledExtent;
    // _isRotateSun = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _loading() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            width: double.infinity,
            height: _pulledExtent > _indicatorExtent
                ? _pulledExtent
                : _indicatorExtent,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    // margin: EdgeInsets.only(top: 15.0),
                    width: double.infinity,
                    height: _pulledExtent < _indicatorExtent
                        ? _indicatorExtent
                        : _pulledExtent,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Transform.scale(
                            scale: 0.5,
                            child: Lottie.asset(
                              'lib/commonui/cq-effect-kit/refresh/flare/footer.json',
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                              repeat: true,
                            ),
                          ),
                          // Text("刷得太快啦,休息一下 o(≧口≦)o"),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_noMore) return Container();
    if (_loadState == LoadMode.armed || _loadState == LoadMode.load) {
      // isRotateSun = true;
      return _loading();
    } else if (_loadState == LoadMode.done || _loadState == LoadMode.inactive) {
      // isRotateSun = false;
    }

    return _loading();

    // return Stack(
    //   children: <Widget>[
    //     Positioned(
    //       bottom: 0.0,
    //       left: 0.0,
    //       right: 0.0,
    //       child: Container(
    //         width: double.infinity,
    // height: _pulledExtent > _indicatorExtent
    //     ? _pulledExtent
    //     : _indicatorExtent,
    //         child: Stack(
    //           children: <Widget>[
    //             // // 天空
    //             // Container(
    //             //   width: double.infinity,
    //             //   height: double.infinity,
    //             //   color: Colors.blue,
    //             // ),
    //             // // 云
    //             // Positioned(
    //             //   top: 0.0,
    //             //   left: 0.0,
    //             //   right: 0.0,
    //             //   child: Container(
    //             //     width: double.infinity,
    //             //     height: _indicatorExtent,
    //             //     child: Image.memory(
    //             //       _skyBytes,
    //             //       fit: BoxFit.cover,
    //             //     ),
    //             //   ),
    //             // ),
    //             // 学校
    //             // Positioned(
    //             //   top: 0.0,
    //             //   left: 0.0,
    //             //   right: 0.0,
    //             //   child: Container(
    //             //     margin: EdgeInsets.only(top: 15.0),
    //             //     width: double.infinity,
    //             //     height: _pulledExtent < _indicatorExtent
    //             //         ? _indicatorExtent
    //             //         : _pulledExtent,
    //             //     child: Image.memory(
    //             //       _buildingsBytes,
    //             //       fit: BoxFit.fitHeight,
    //             //     ),
    //             //   ),
    //             // ),
    //             // 太阳
    //             // Positioned(
    //             //   top: 0.0,
    //             //   left: 0.0,
    //             //   right: 0.0,
    //             //   child: Container(
    //             //     margin: EdgeInsets.only(
    //             //         top: _pulledExtent < _indicatorExtent - 20.0
    //             //             ? _indicatorExtent / 2 - _pulledExtent / 2
    //             //             : 10.0),
    //             //     width: double.infinity,
    //             //     height: _indicatorExtent,
    //             //     child: Center(
    //             //       child: Container(
    //             //         height: _indicatorExtent,
    //             //         width: 110.0,
    //             //         child: Align(
    //             //           alignment: Alignment.topLeft,
    //             //           child: Transform.rotate(
    //             //             child: Container(
    //             //               height: 30.0,
    //             //               width: 30.0,
    //             //               child: Image.memory(
    //             //                 _sunBytes,
    //             //                 fit: BoxFit.fill,
    //             //               ),
    //             //             ),
    //             //             angle: (_isRotateSun
    //             //                     ? _sunRotateValue
    //             //                     : _pulledExtent) /
    //             //                 8 /
    //             //                 pi,
    //             //           ),
    //             //         ),
    //             //       ),
    //             //     ),
    //             //   ),
    //             // ),

    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
