/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-14 18:14:23
 * @Description: 设备信息适配验证
 */

import 'dart:ui' show window;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class DeviceAdaptPage extends StatefulWidget {
  const DeviceAdaptPage({Key? key}) : super(key: key);

  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceAdaptPage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('设备信息适配验证')),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            Container(height: 20),
            _window_cell(), // 设备屏幕信息
            Container(height: 20),
            _adapt_method_all_cell(), // 设备适配方法验证
            Container(height: 20),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _window_cell() {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    EdgeInsets padding = mediaQuery.padding;
    padding = padding.copyWith(bottom: mediaQuery.viewPadding.top);
    // double bottomHeight = padding.top;

    String textValue = '';
    textValue += 'width:${mediaQuery.size.width}\n';
    textValue += 'height:${mediaQuery.size.height}\n';
    textValue += 'top:${mediaQuery.viewPadding.top}\n';
    textValue += 'bottom:${mediaQuery.viewPadding.bottom}\n';
    return CJTSImageTitleTextValueCell(
      title: "设备屏幕",
      textValue: textValue,
      textValueMaxLines: 10,
      textValueFontSize: 14,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        CJTSToastUtil.showMessage('设备屏幕信息拷贝成功');
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _adapt_method_all_cell() {
    double width1 = AdaptDemoHelper.setWidth(30);
    double height1 = AdaptDemoHelper.setHeight(30);
    double fontsize1 = AdaptDemoHelper.setSp(30);
    print("适配 width1:$width1 height1:$height1 fontsize1:$fontsize1");
    Widget view1 = _adapt_method_cell(
      adaptMethod: 'AdaptDemoHelper.setXXX',
      adaptResultMap: {
        'width': width1,
        'height': height1,
        'fontsize': fontsize1,
      },
    );

    double width2 = 30.w_pt_demo;
    double height2 = 30.h_pt_demo;
    double fontsize2 = 30.f_pt_demo;
    print("适配 width2:$width2 height2:$height2 fontsize2:$fontsize2");
    Widget view2 = _adapt_method_cell(
      adaptMethod: '.xxx_pt_demo',
      adaptResultMap: {
        'width': width2,
        'height': height2,
        'fontsize': fontsize2,
      },
    );
    /*
    double width3 = Adapt.px(60);
    double height3 = Adapt.px(60);
    double fontsize3 = Adapt.px(60);
    print("适配 width3:$width3 height3:$height3 fontsize3:$fontsize3");
    Widget view3 = _adapt_method_cell(
      adaptMethod: 'Adapt.px',
      adaptResultMap: {
        'width': width3,
        'height': height3,
        'fontsize': fontsize3,
      },
    );

    double width4 = 30.w_bj;
    double height4 = 30.h_bj;
    double fontsize4 = 30.h_bj;
    print("适配 width4:$width4 height4:$height4 fontsize4:$fontsize4");
    Widget view4 = _adapt_method_cell(
      adaptMethod: '.xxx_bj',
      adaptResultMap: {
        'width': width4,
        'height': height4,
        'fontsize': fontsize4,
      },
    );
    */
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Text(
            "设配屏幕适配方法的验证(eg:750pt下的30pt)",
            style: TextStyle(color: Colors.black),
          ),
        ),
        view1,
        view2,
        // view3,
        // view4,
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget _adapt_method_cell({
    required String adaptMethod,
    required Map<String, double> adaptResultMap,
  }) {
    String textValue = '';

    for (String key in adaptResultMap.keys) {
      double keyValue = adaptResultMap[key] ?? 0.0;
      textValue += '$key:$keyValue\n';
    }

    return CJTSImageTitleTextValueCell(
      title: "$adaptMethod",
      textValue: textValue,
      textValueMaxLines: 10,
      textValueFontSize: 14,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        CJTSToastUtil.showMessage('设备适配结果拷贝成功');
      },
    );
  }
}
