import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/main/IconFont.dart';
import 'package:tsdemodemo_flutter/modules/user_manager/user_detail_bean.dart';

class TempTestPage extends StatelessWidget {
  TempTestPage({Key key}) : super(key: key);

  UserDetailBean _user;

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
            title: '读取 user_detail.json，并map转model',
            onPressed: () {
              rootBundle
                  .loadString("lib/modules/user_manager/user_detail.json")
                  .then(
                (value) {
                  Map<String, dynamic> data = json.decode(value);
                  _user = UserDetailBean.fromJson(data);
                  debugPrint("user=${_user.toString()}");
                },
              );
            },
          ),
          CQTSThemeBGButton(
            bgColorType: CQTSThemeBGType.pink,
            title: '获取userMap，通过 model 转 map',
            onPressed: () {
              if (_user == null) {
                CJTSToastUtil.showMessage("请先读取 user_detail.json");
              } else {
                Map<String, dynamic> userJson = _user.toJson();
                debugPrint("userJson=${userJson.toString()}");
              }
            },
          ),
        ],
      ),
    );
  }
}
