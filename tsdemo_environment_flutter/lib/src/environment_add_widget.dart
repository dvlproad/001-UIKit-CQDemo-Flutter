import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EnvironmentAddWidget extends StatelessWidget {
  EnvironmentAddWidget({Key key}) : super(key: key);

  String _tmpIP = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _proxyTextField,
      ],
    );
  }

  Widget get _proxyTextField {
    // SharedPreferences.getInstance().then((prefs) {
    //   String ip = prefs.getString('bj_app_proxy_ip');
    //   if (ip != null) {
    //     _ip = ip;
    //   }
    // });
    return Text('data');
    return TextField();

    return TextField(
        // keyboardType: TextInputType.url,
        // onSubmitted: (value) {
        //   // 保存数据
        //   // SharedPreferences.getInstance().then((prefs) {
        //   //   _ip = _tmpIP;
        //   //   prefs.setString('bj_app_proxy_ip', value);
        //   //   // Toast.show('代理已设置：${_ip}:8888 重新打开app后生效', context,
        //   //   //     gravity: Toast.CENTER);
        //   // });
        // },
        // onChanged: (value) {
        //   _tmpIP = value;
        // },
        // decoration: InputDecoration(
        //   hintText: "设置代理ip xx.xx.xx.xx，默认端口8888",
        //   // alignLabelWithHint: true,
        //   // contentPadding: EdgeInsets.all(1),
        //   // border: OutlineInputBorder(
        //   //   borderSide: BorderSide.none,
        //   // ),
        //   // hintStyle: TextStyle(color: Color(0xFF767A7D), fontSize: 13),
        // ),
        );
  }
}
