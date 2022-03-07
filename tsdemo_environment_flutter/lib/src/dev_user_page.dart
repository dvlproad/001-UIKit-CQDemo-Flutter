import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './userInfoManager.dart';

class DevUserPage extends StatefulWidget {
  const DevUserPage({Key key}) : super(key: key);

  @override
  _DevUserPageState createState() => _DevUserPageState();
}

class _DevUserPageState extends State<DevUserPage> {
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
      appBar: AppBar(title: const Text('开发工具-用户信息相关')),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            Container(height: 20),
            _devtool_userinfo_cell(),
            _devtool_forceLogout_cell(), // 强制退出
          ],
        ),
      ),
    );
  }

  // 用户相关信息
  Widget _devtool_userinfo_cell() {
    String userId = 'UserInfoManager().userModel.userId';
    String textValue = '';
    if (UserInfoManager.isLoginState()) {
      textValue = 'uid:$userId';
    } else {
      textValue = '您还未登录';
    }
    return BJHTitleTextValueCell(
      title: "user信息",
      textValue: textValue,
      textValueFontSize: 12,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('user信息拷贝成功');
      },
    );
  }

  Widget _devtool_forceLogout_cell() {
    if (UserInfoManager.isLoginState() == false) {
      return Container(height: 1);
    }
    return BJHTitleTextValueCell(
      title: "强制退出",
      textValue: '',
      onTap: () {
        AlertUtil.showCancelOKAlert(
          context: context,
          title: '确认强制退出吗？',
          message: '强制退出本仅用于某个环境无法退出导致无法使用其他环境时候使用，其他情况仅尽量不要使用',
          okHandle: () {
            /*
            UserInfoManager.instance.userLoginOut().then((value) {
              eventBus.fire(LogoutSuccessEvent());
              Navigator.of(context).pop();
            });
            */
          },
        );
      },
    );
  }
}
