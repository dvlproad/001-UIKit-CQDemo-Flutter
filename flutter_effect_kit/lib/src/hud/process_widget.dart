/*
 * @Author: dvlproad
 * @Date: 2022-07-22 14:50:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 17:19:51
 * @Description: 
 */
import 'package:flutter/material.dart';
// import './loading_images_base_widget.dart'; // 使用 images 加载动画
// import 'package:lottie/lottie.dart'; // 使用 json 加载动画

class ProgressUtil {
  static Widget? _progressWidget;
  static GlobalKey<ProgressWidgetState> progressWidgetKey = GlobalKey();

  static Future showProgressHud(
    BuildContext context, {
    String? Function(double progressValue)? progressTextGetBlock,
  }) {
    _progressWidget = ProgressWidget(
      key: progressWidgetKey,
      height: 10,
      width: 240,
      progressValue: 0.0,
      progressTextGetBlock: progressTextGetBlock,
    );
    return showDialog(
      context: context,
      // barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _progressWidget!,
        ],
      ),
    );
  }

  static void hideProgressHud(BuildContext context) {
    Navigator.pop(context);
  }

  static void updateProgressValue(BuildContext context, double progressValue) {
    if (progressWidgetKey.currentState != null) {
      progressWidgetKey.currentState!.updateProgressValue(progressValue);
    }
  }
}

class ProgressWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final double progressValue;
  final bool showProgressText;
  final String? Function(double progressValue)? progressTextGetBlock;

  const ProgressWidget({
    Key? key,
    this.width,
    this.height,
    required this.progressValue, //0~100的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
    this.showProgressText = false,
    this.progressTextGetBlock, // 自定义进度条文本
  }) : super(key: key);

  @override
  State<ProgressWidget> createState() => ProgressWidgetState();
}

class ProgressWidgetState extends State<ProgressWidget> {
  double _progressValue = 0.0;
  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    /*
    return Container(
      // width: containerWidth,
      constraints: BoxConstraints(
        //minWidth: double.infinity,
        minHeight: 160,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffeeeeee),
      ),
      child: aaa,
    );
  }

  Widget get aaa {
    */
    String? progressText = _progressValue.toStringAsFixed(2);
    if (widget.progressTextGetBlock != null) {
      progressText = widget.progressTextGetBlock!(_progressValue);
    }

    return Column(
      children: [
        progressText == null
            ? Container()
            : Text(
                "$progressText%",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: const BoxDecoration(
              color: Colors.red,
              // borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: LinearProgressIndicator(
              value: _progressValue / 100.0,
              backgroundColor: Colors.grey,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFFF7F00)),
            ),
          ),
        ),
      ],
    );
    // ignore: dead_code
    return Column(
      children: [
        Center(
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: LinearProgressIndicator(
              value: _progressValue / 100.0,
              //背景颜色
              backgroundColor: Colors.yellow,
              //进度颜色
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  updateProgressValue(double progressValue) {
    setState(() {
      _progressValue = progressValue;
      debugPrint("progress == $_progressValue");
    });
  }
}
