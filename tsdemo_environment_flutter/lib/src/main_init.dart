import 'package:flutter/material.dart';
import './dev_page.dart';
import './main_init/dev_tool_init.dart';
export './main_init/main_diff_util.dart' show PackageType;

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import './dev_user_page.dart';

class MainInit {
  static initWithGlobalKey(GlobalKey globalKey, PackageType packageType) {
    DevToolInit.initWithGlobalKey(globalKey, packageType);

    DevPage.navbarActions = [
      _buttonToPage('调试页面', const Text('1'), globalKey),
      _buttonToPage('用户相关', const DevUserPage(), globalKey),
    ];
  }

  static Widget _buttonToPage(
      String buttonText, Widget pageWidget, GlobalKey globalKey) {
    return ThemeBGButton(
      bgColorType: ThemeBGType.blue,
      title: buttonText,
      onPressed: () {
        BuildContext context = globalKey.currentContext;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return pageWidget;
        }));
      },
    );
  }
}
