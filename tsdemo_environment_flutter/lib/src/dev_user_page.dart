/*
 * @Author: dvlproad
 * @Date: 2022-04-21 18:58:00
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 01:05:17
 * @Description: 用户信息相关
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
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
    double width1 = AdaptCJHelper.setWidth(30);
    double height1 = AdaptCJHelper.setHeight(30);
    double fontsize1 = AdaptCJHelper.setSp(30);
    print("适配 width1:$width1 height1:$height1 fontsize1:$fontsize1");
    double width2 = 30.w_pt_cj;
    double height2 = 30.h_pt_cj;
    double fontsize2 = 30.f_pt_cj;
    print("适配 width2:$width2 height2:$height2 fontsize2:$fontsize2");

    return Scaffold(
      appBar: AppBar(title: const Text('开发工具-用户信息相关')),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            Container(height: 20),
            _username_cell(), // username
            _devtool_userid_cell(), // userid
            _devtool_usertoken_cell(), // usertoken
            _devtool_forceLogout_cell(), // 强制退出
          ],
        ),
      ),
    );
  }

  // 用户相关信息
  Widget _username_cell() {
    String userName = UserInfoManager().userModel.nickname;
    String textValue = UserInfoManager.isLoginState ? userName : '您还未登录';
    return ImageTitleTextValueCell(
      title: "用户名",
      textValue: textValue,
      textValueFontSize: 12,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('用户名信息拷贝成功');
      },
    );
  }

  Widget _devtool_userid_cell() {
    String userId = UserInfoManager().userModel.userId;
    String textValue = UserInfoManager.isLoginState ? userId : '您还未登录';
    return ImageTitleTextValueCell(
      title: "userid",
      textValue: textValue,
      textValueFontSize: 12,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('userid信息拷贝成功');
      },
    );
  }

  Widget _devtool_usertoken_cell() {
    String userToken = UserInfoManager().userModel.authToken;
    String textValue = UserInfoManager.isLoginState ? userToken : '您还未登录';
    return ImageTitleTextValueCell(
      title: "userToken",
      textValue: textValue,
      textValueFontSize: 12,
      textValueMaxLines: 2,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('userToken信息拷贝成功');
      },
    );
  }

  Widget _devtool_forceLogout_cell() {
    if (UserInfoManager.isLoginState == false) {
      return Container(height: 1);
    }
    return ImageTitleTextValueCell(
      title: "强制退出",
      textValue: '',
      onTap: () {
        AlertUtil.showCancelOKAlert(
          context: context,
          title: '确认强制退出吗？',
          message: '强制退出本仅用于某个环境无法退出导致无法使用其他环境时候使用，其他情况仅尽量不要使用',
          okHandle: () {
            UserInfoManager().logout();
          },
        );
      },
    );
  }
}
