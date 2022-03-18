import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/main/IconFont.dart';

class TempTestPage extends StatelessWidget {
  const TempTestPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('未抽离的测试'),
      ),
      body: Column(
        children: [
          const Icon(IconFont.dianzan),
          const Icon(IconFont.dianzan, color: Colors.pink),
          const Icon(IconFont.dianzan1),
          const Icon(IconFont.dianzan1, color: Colors.pink),
          const Icon(IconFont.zhinengkefuzhongxin),
          const Icon(IconFont.zhinengkefuzhongxin, color: Colors.pink),
          const Icon(IconFont.zhuanban, color: Colors.pink),
          CQTSThemeBGButton(
            bgColorType: CQTSThemeBGType.pink,
            title: '读取json',
            onPressed: () {
              rootBundle.loadString("lib/user_manager/user_detail.json").then(
                (value) {
                  Map<String, dynamic> data = json.decode(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
