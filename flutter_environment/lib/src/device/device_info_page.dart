/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 14:16:50
 * @Description: 设备自身ip、代理等信息
 */

import 'dart:async';
import 'dart:developer' as developer;

import 'dart:io' show NetworkInterface, InternetAddressType, InternetAddress;
import 'dart:ui' show window;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import './device_info_util.dart';
import './device_adapt_page.dart';

class DeviceInfoPage extends StatefulWidget {
  final Future<Map<String, dynamic>?> Function() getFixedCommonParamsBlock;

  const DeviceInfoPage({
    Key? key,
    required this.getFixedCommonParamsBlock,
  }) : super(key: key);

  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String? _networkInterface;
  Map<String, String>? _phoneSystemIpMap;
  String? _phoneProxyIpAndPort;

  Map<String, dynamic>? _monitorPublicParamsMap;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    getNetworkInterface();
    getPhoneProxyIpAndProt();
    getFix();
  }

  getFix() async {
    _monitorPublicParamsMap = await widget.getFixedCommonParamsBlock();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开发工具-设备信息相关')),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            _networkType_cell(),
            Container(height: 20),
            _window_cell(), // 设备屏幕信息
            Container(height: 20),
            _NetworkInterface_cell(), // NetworkInterface
            _phoneProxyIpAndPort_cell(), // 设备自身代理环境
            Container(height: 20),
            _monitorPublicParams_cell(), // 设备参数(埋点公共参数信息)
          ],
        ),
      ),
    );
  }

  // 设备参数(埋点公共参数信息)
  Widget _monitorPublicParams_cell() {
    List<Widget> infoWidgets = [
      Container(
        width: double.infinity,
        color: Colors.white,
        child: Text(
          '设备参数(埋点公共参数信息)',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ];
    for (String key in _monitorPublicParamsMap?.keys ?? []) {
      String title = key;
      dynamic dTextValue = _monitorPublicParamsMap![key];
      String textValue = dTextValue.toString();

      Widget widget = ImageTitleTextValueCell(
        title: title,
        textValue: textValue,
        textValueMaxLines: 3,
        textValueFontSize: 12,
        onTap: () {
          Clipboard.setData(ClipboardData(text: textValue));
          ToastUtil.showMessage('设备网络信息拷贝成功');
        },
      );
      infoWidgets.add(widget);
    }

    return Column(
      children: infoWidgets,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  getPhoneProxyIpAndProt() async {
    HttpProxy httpProxy = await HttpProxy.createHttpProxy();

    setState(() {
      if (httpProxy.host == null) {
        _phoneProxyIpAndPort = null;
      } else {
        _phoneProxyIpAndPort = "${httpProxy.host}:${httpProxy.port}";
      }
    });
  }

  getNetworkInterface() async {
    _networkInterface = await DeviceInfoUtil.getPhoneSystemNetworkInterface();
    _phoneSystemIpMap = await DeviceInfoUtil.getPhoneSystemIpMap();
    setState(() {});
  }

  Widget _networkType_cell() {
    String textValue = _connectionStatus.toString().split('.').last;
    return ImageTitleTextValueCell(
      title: '网络类型',
      textValue: textValue,
      textValueFontSize: 12,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('设备网络信息拷贝成功');
      },
    );
  }

  // 设备相关信息
  Widget _NetworkInterface_cell() {
    String textValue_all = _networkInterface ??= '获取失败(可能断网了)';
    String textValue_ip = '获取失败(可能断网了)';
    if (_phoneSystemIpMap != null) {
      textValue_ip =
          "${_phoneSystemIpMap!["value"]}(${_phoneSystemIpMap!["name"]})";
    }
    return Column(
      children: [
        ImageTitleTextValueCell(
          title: "设备网络(all)",
          textValue: textValue_all,
          textValueMaxLines: 20,
          textValueFontSize: 10,
          onTap: () {
            Clipboard.setData(ClipboardData(text: textValue_all));
            ToastUtil.showMessage('设备网络信息拷贝成功');
          },
        ),
        ImageTitleTextValueCell(
          title: "设备网络(ip)",
          textValue: textValue_ip,
          textValueMaxLines: 10,
          textValueFontSize: 12,
          onTap: () {
            Clipboard.setData(ClipboardData(text: textValue_ip));
            ToastUtil.showMessage('设备网络信息拷贝成功');
          },
        ),
      ],
    );
  }

  Widget _phoneProxyIpAndPort_cell() {
    String textValue = _phoneProxyIpAndPort ?? '关闭/获取失败(可能断网了)';
    return ImageTitleTextValueCell(
      title: "设备自身代理",
      textValue: textValue,
      textValueFontSize: 12,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('设备自身代理信息拷贝成功');
      },
    );
  }

  Widget _window_cell() {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    EdgeInsets padding = mediaQuery.padding;
    padding = padding.copyWith(bottom: mediaQuery.viewPadding.top);
    double bottomHeight = padding.top;

    String textValue = '';
    textValue += 'width:${mediaQuery.size.width}\n';
    textValue += 'height:${mediaQuery.size.height}\n';
    textValue += 'top:${mediaQuery.viewPadding.top}\n';
    textValue += 'bottom:${mediaQuery.viewPadding.bottom}\n';
    return ImageTitleTextValueCell(
      title: "设备屏幕(点击验证适配)",
      textValue: textValue,
      textValueMaxLines: 10,
      textValueFontSize: 14,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return DeviceAdaptPage();
          },
        ));
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('设备屏幕信息拷贝成功');
      },
    );
  }
}
