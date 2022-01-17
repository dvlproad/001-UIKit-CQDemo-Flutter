import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'; // 为了引入 ThemeBorderButton
import './empty_imageAboveText_widget.dart';

class BaseWebPage extends StatefulWidget {
  final FlutterWebviewPlugin flutterWebViewPlugin;
  final String Url;
  final Set<JavascriptChannel> javascriptChannels;
  final Widget failureWidget; // 请求失败时候的显示视图

  const BaseWebPage({
    Key key,
    this.flutterWebViewPlugin,
    @required this.Url,
    this.javascriptChannels,
    this.failureWidget,
  }) : super(key: key);

  @override
  _BaseWebPageState createState() => _BaseWebPageState();
}

class _BaseWebPageState extends State<BaseWebPage> {
  // Instance of WebView plugin
  // final FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  FlutterWebviewPlugin flutterWebViewPlugin;

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  bool _loadSuccess = true;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin = widget.flutterWebViewPlugin;
    if (flutterWebViewPlugin == null) {
      flutterWebViewPlugin = FlutterWebviewPlugin();
    }

    flutterWebViewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        print('web关闭了');
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Webview Destroyed2')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _historyAdd('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _historyAdd('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _historyAdd('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _historyAdd('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _historyAdd('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _loadSuccess = false;
          flutterWebViewPlugin.close();

          _historyAdd('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  void _historyAdd(String text) {
    print(text);
    _history.add(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return !_loadSuccess; // 成功则必须通过h5自己调用js来返回
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    if (_loadSuccess == true) {
      bool withLocalUrl = !widget.Url.startsWith(RegExp(r'https?:'));
      return WebviewScaffold(
        javascriptChannels: widget.javascriptChannels,
        url: widget.Url,
        // withLocalUrl: withLocalUrl,
        //当WebView没加载出来前显示
        initialChild: Container(
          color: Colors.red,
          child: Center(
            child: Text(
              "正在加载中....",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        debuggingEnabled: true,
      );
    } else {
      return bodyWidget_failure(context);
    }
  }

  Widget bodyWidget_failure(BuildContext context) {
    if (widget.failureWidget != null) {
      return widget.failureWidget;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('网页加载失败'),
      ),
      body: EmptyWithImageAboveTextWidget(
        color: Color(0xFFF0F0F0),
        image: AssetImage(
          'assets/nonetwork.png',
          package: 'flutter_webview',
        ),
        mainTitle: '咦，网络开小差啦！',
        subTitle: '点击下方按钮帮你叫醒它！',
        buttonWidget: ThemeBorderButton(
          width: 110, // 不设置会根据内容自适应
          height: 35, // 不设置会根据内容自适应
          borderColorType: ThemeBGType.pink,
          title: '刷新',
          titleStyle: ButtonBoldTextStyle(fontSize: 13.0),
          cornerRadius: 17.5,
          onPressed: () {
            flutterWebViewPlugin.reload();
          },
        ),
      ),
    );
  }
}
