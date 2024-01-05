// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:15:12
 * @Description: 展示exposure曝光信息的message视图
 */

import 'package:flutter/material.dart';
import 'package:flutter_exposure_kit/flutter_exposure_kit.dart';

class ExposureMessageWidget extends StatefulWidget {
  const ExposureMessageWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExposureMessageWidgetState();
  }
}

class ExposureMessageWidgetState extends State<ExposureMessageWidget> {
  int first = -1;
  int last = -1;
  List<int> export = [];
  ScrollController scrollController = ScrollController();

  ExposureStartIndex? _newExposureModel;
  ExposureEndIndex? _newNoFullExposureModel;

  void updateNewExposureModel(ExposureStartIndex newExposureModel) {
    setState(() {
      _newExposureModel = newExposureModel;
    });
  }

  void updateNewNoFullExposureModel(ExposureEndIndex newNoFullExposureModel) {
    setState(() {
      _newNoFullExposureModel = newNoFullExposureModel;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void updateExposureData_None() {}

  void updateExposureData(int first, int last) {
    if (first < last) {
      for (int i = first; i <= last; i++) {
        if (i < this.first || i > this.last) {
          export.add(i); // 新曝光的元素(①没曝光过、②有更小的曝光值，③有更大的曝光值)
        }
      }
    }
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
    setState(() {
      this.first = first;
      this.last = last;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      height:
          180, // 使用固定值，修复header视图因 ExposureModel!.message 自动变长，导致给列表所占的高度自动变短，从而引起原本正确计算出来的可见头和可见尾，因没在重新计算导致显示错误
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.topLeft,
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(text: '当前第一个完全可见元素下标:'),
            TextSpan(
              text: '$first\n',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: '当前最后一个完全可见元素下标:'),
            TextSpan(
              text: '$last\n',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: '新开始曝光(完全可见)的元素:'),
            TextSpan(
              text: _newExposureModel == null ? '' : _newExposureModel!.message,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: '新结束曝光(非完全可见)元素:'),
            TextSpan(
              text: _newNoFullExposureModel == null
                  ? ''
                  : _newNoFullExposureModel!.message,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          height: 40,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Text(
              '曝光元素列表: ${export.join("、")}',
              // style: TextStyle(),
            ),
          ),
        ),
        content,
      ],
    );
  }
}
