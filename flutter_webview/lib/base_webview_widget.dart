import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

// String selectedUrl = 'https://flutter.io';
String selectedUrl = 'https://www.baidu2.com';

class BaseWebView extends StatefulWidget {
  const BaseWebView({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _BaseWebViewState createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

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

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  bool _loadSuccess = true;

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Webview Destroyed2')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _loadSuccess = false;
          flutterWebViewPlugin.close();
          setState(() {});
          // _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    if (_loadSuccess == false) {
      return Container(
        color: Colors.green,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Center(
              child: Text(
                '加载失败',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              child: const Text('刷新'),
              onPressed: () {
                // flutterWebViewPlugin.launch(selectedUrl);
                flutterWebViewPlugin.launch('https://www.baidu.com');
              },
            ),
            ElevatedButton(
              child: const Text('退出'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      // return ElevatedButton(
      //   child: const Text('刷新'),
      //   onPressed: () {
      //     flutterWebViewPlugin.launch('https://www.baidu2.com');
      //     // _loadSuccess = false;
      //     // setState(() {});
      //     // Navigator.of(context).pushNamed('/widget');
      //   },
      // );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            child: TextField(controller: _urlCtrl),
          ),
          ElevatedButton(
            onPressed: () {
              flutterWebViewPlugin.launch(
                selectedUrl,
                rect: Rect.fromLTWH(
                    0.0, 0.0, MediaQuery.of(context).size.width, 300.0),
                userAgent: kAndroidUserAgent,
                invalidUrlRegex:
                    r'^(https).+(twitter)', // prevent redirecting to twitter when user click on its icon in flutter website
              );
            },
            child: const Text('Open Webview (rect)'),
          ),
          ElevatedButton(
            onPressed: () {
              flutterWebViewPlugin.launch(selectedUrl, hidden: true);
            },
            child: const Text('Open "hidden" Webview'),
          ),
          ElevatedButton(
            onPressed: () {
              flutterWebViewPlugin.launch(selectedUrl);
            },
            child: const Text('Open Fullscreen Webview'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/widget');
            },
            child: const Text('Open widget webview'),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            child: TextField(controller: _codeCtrl),
          ),
          ElevatedButton(
            onPressed: () {
              final future =
                  flutterWebViewPlugin.evalJavascript(_codeCtrl.text);
              future.then((String result) {
                setState(() {
                  _history.add('eval: $result');
                });
              });
            },
            child: const Text('Eval some javascript'),
          ),
          ElevatedButton(
            onPressed: () {
              final future =
                  flutterWebViewPlugin.evalJavascript('alert("Hello World");');
              future.then((String result) {
                setState(() {
                  _history.add('eval: $result');
                });
              });
            },
            child: const Text('Eval javascript alert()'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _history.clear();
              });
              flutterWebViewPlugin.close();
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              flutterWebViewPlugin.getCookies().then((m) {
                setState(() {
                  _history.add('cookies: $m');
                });
              });
            },
            child: const Text('Cookies'),
          ),
          Text(_history.join('\n'))
        ],
      ),
    );
  }
}
