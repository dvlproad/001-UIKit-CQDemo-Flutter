import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';

import './sound_wave_widget.dart';

import '../../app_info_choose_kit_adapt.dart';

enum RecordStatus {
  idle, // 闲着(从未开始、录制结束后、录制取消后)，等待用户操作
  recording, // 录制中
}

class SoundRecordActionView extends StatefulWidget {
  final void Function() onRecordStart;
  final void Function() onRecordCancel;
  final void Function() onRecordOK;

  const SoundRecordActionView({
    Key key,
    @required this.onRecordStart,
    @required this.onRecordCancel,
    @required this.onRecordOK,
  }) : super(key: key);

  @override
  _SoundRecordActionViewState createState() {
    return _SoundRecordActionViewState();
  }
}

class _SoundRecordActionViewState extends State<SoundRecordActionView> {
  // Map<int, Image> imageCaches = new Map();
  bool isOpen = false;

  RecordStatus recordStatus = RecordStatus.idle;
  DateTime startTime = DateTime.now();

  GlobalKey _cancelButtonKey = GlobalKey();
  double cancelButtonMaxX = 0.0;

  bool _recordingMoveWillCancel = false; // 录制过程中，长按滑动到取消录音的位置

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w_pt_cj),
          topRight: Radius.circular(10.w_pt_cj),
        ),
      ),
      height: 253.h_pt_cj,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 20.h_pt_cj),
          recordStatus == RecordStatus.idle
              ? Container(height: 20.h_pt_cj)
              : SoundWaveWidget(),
          // Container(
          //   height: Adapt.px(0),
          //   child: ImagesAnim(
          //       imageCaches, Adapt.px(174), Adapt.px(42), Colors.transparent),
          // ),
          Container(height: 20.h_pt_cj),
          Text(
            soundButtonText,
            style: TextStyle(
              color: const Color(0xff555555),
              fontSize: 16.h_pt_cj,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(height: 20.h_pt_cj),
          GestureDetector(
            onTapDown: (detail) async {
              // HapticFeedback.mediumImpact();
            },
            onLongPressStart: onLongPressStart,
            onLongPressMoveUpdate: onLongPressUpdate,
            onLongPressEnd: onLongPressEnd,
            onLongPressCancel: onLonePressCancel,
            child: Container(
              height: 100.w_pt_cj,
              // color: Colors.pink,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        child: Image(
                          image: AssetImage(
                            "assets/icon_voice_record_big.png",
                            package: 'app_info_choose_kit',
                          ),
                          width: 90.w_pt_cj,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Visibility(
                      visible: recordStatus == RecordStatus.recording,
                      child: Container(
                        alignment: Alignment.center,
                        width: 100.w_pt_cj,
                        // color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              soundTipsText,
                              textAlign: TextAlign.center,
                              style: RegularTextStyle(fontSize: 12),
                            ),
                            Container(height: 20.h_pt_cj),
                            Image(
                              key: _cancelButtonKey,
                              image: const AssetImage(
                                'assets/icon_cancel.png',
                                package: 'app_info_choose_kit',
                              ),
                              width: 40.w_pt_cj,
                              fit: BoxFit.fitWidth,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get soundButtonText {
    if (recordStatus == RecordStatus.idle) {
      return '按住录音';
    } else {
      //recordStatus == RecordStatus.recording
      if (_recordingMoveWillCancel == true) {
        return "松开取消";
      } else {
        return "松开完成";
      }
    }
  }

  String get soundTipsText {
    if (recordStatus == RecordStatus.idle) {
      return '滑动取消';
    } else {
      //recordStatus == RecordStatus.recording
      if (_recordingMoveWillCancel == true) {
        return "松开取消";
      } else {
        return "滑动取消";
      }
    }
  }

  onLongPressStart(_) {
    // HapticFeedback.mediumImpact();

    setState(() {
      recordStatus = RecordStatus.recording;
      _recordingMoveWillCancel = false;

      startTime = DateTime.now();
    });

    if (widget.onRecordStart != null) {
      widget.onRecordStart();
    }
  }

  onLongPressUpdate(LongPressMoveUpdateDetails e) async {
    double dx = e.localPosition.dx;
    // print("=============滑动距离dx=$dx");

    if (cancelButtonMaxX == 0) {
      // _cancelButtonKey 不是一直可见，所以位置应该等到显示后才能取获取
      RenderBox renderBox = _cancelButtonKey.currentContext.findRenderObject();
      Offset cancelButtonXY = renderBox.localToGlobal(Offset.zero);
      cancelButtonMaxX = cancelButtonXY.dx + renderBox.size.width;
      print("cancelButtonMaxX = $cancelButtonMaxX");
    }

    double cancelRight = cancelButtonMaxX;
    bool curRecordingMoveWillCancel = dx.abs() < cancelRight;
    if (_recordingMoveWillCancel != curRecordingMoveWillCancel && mounted) {
      setState(() {
        _recordingMoveWillCancel = curRecordingMoveWillCancel;

        if (_recordingMoveWillCancel == true) {
          // HapticFeedback.mediumImpact();
        }
      });
    }
  }

  onLongPressEnd(e) {
    // Did not receive onStop from FlutterPluginRecord if the duration is too short.
    // if (DateTime.now().difference(startTime).inSeconds < 1) {
    //   recordStatus = RecordStatus.cancel;
    //   ToastUtil.showMessage("说话时间太短!");
    // }

    // 此高度为 160为录音取消组件距离顶部的预留距离
    double dx = e.localPosition.dx;
    double cancelRight = cancelButtonMaxX;

    recordStatus = RecordStatus.idle;
    if (dx.abs() < cancelRight) {
      if (widget.onRecordCancel != null) {
        widget.onRecordCancel();
      }
    } else {
      if (widget.onRecordOK != null) {
        widget.onRecordOK();
      }
    }
  }

  onLonePressCancel() {
    recordStatus = RecordStatus.idle;
    if (widget.onRecordCancel != null) {
      widget.onRecordCancel();
    }
  }
}
