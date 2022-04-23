/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-20 18:31:59
 * @Description: 测试在长页面里点击状态栏能够返回到页面的顶部
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class TapStatusNormalPage extends StatefulWidget {
  const TapStatusNormalPage({Key key}) : super(key: key);

  @override
  State<TapStatusNormalPage> createState() => _TapStatusNormalPageState();
}

class _TapStatusNormalPageState extends State<TapStatusNormalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('状态栏点击-Normal'),
      ),
      body: ListView.builder(
        itemCount: 200,
        itemBuilder: (context, index) {
          return Text('$index');
        },
      ),
    );
  }
}
