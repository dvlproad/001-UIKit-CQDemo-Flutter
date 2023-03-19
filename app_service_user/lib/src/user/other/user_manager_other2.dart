/*
 * @Author: dvlproad
 * @Date: 2023-01-30 11:55:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 14:08:10
 * @Description: 
 */
// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wish/common/constants.dart';

// clearUserInfo() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove(SP_AUTHORIZATION);
//   await prefs.remove(SP_ACCESS_TOKEN);
// }

// setUserLoginState(bool isLogin, String phone, String userid) async {
//   if (phone == null || userid == null) return;
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString(USER_PHONE_KEY, phone);
//   prefs.setString(USER_ID_KEY, userid);
//   prefs.setBool(USER_LOGIN_KEY, isLogin);
// }

// Future<bool> getUserLoginState() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool isLogin = await prefs.getBool(USER_LOGIN_KEY);
//   return isLogin == null ? false : isLogin;
// }

// Future<String> getUserPhone() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String phone = await prefs.getString(USER_PHONE_KEY);
//   return phone;
// }

// Future<String> getUserID() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userid = await prefs.getString(USER_ID_KEY);
//   return userid;
// }

// ///取消系统键盘
// cancelKeybord(BuildContext context) {
//   FocusScopeNode focusScopeNode = FocusScope.of(context);
//   if (!focusScopeNode.hasPrimaryFocus && focusScopeNode.focusedChild != null) {
//     FocusManager.instance.primaryFocus.unfocus();
//   }
// }

// Color getRandomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
//   if (r == 0 || g == 0 || b == 0) return Colors.black;
//   if (a == 0) return Colors.white;
//   return Color.fromARGB(
//     a,
//     r != 255 ? r : Random.secure().nextInt(r),
//     g != 255 ? g : Random.secure().nextInt(g),
//     b != 255 ? b : Random.secure().nextInt(b),
//   );
// }

// bool isChinaPhoneLegal(String str) {
//   return new RegExp(
//           '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
//       .hasMatch(str);
// }
