import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './c1440_loading.dart';
import 'package:lottie/lottie.dart';

class StateLoadingWidget extends StatefulWidget {
  StateLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  _StateLoadingWidgetState createState() => _StateLoadingWidgetState();
}

class _StateLoadingWidgetState extends State<StateLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return _loadingView;
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Container(
        color: Color.fromRGBO(22, 170, 175, 0.5),
        height: 200,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _loadingWidget,
            SizedBox(height: 10),
            Text(
              '拼命加载中...',
              style: TextStyle(color: Colors.blue, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _loadingWidget {
    // return C1440Loading();
    return Container(
      // color: Colors.yellow,
      height: 100,
      child: Lottie.asset(
        'assets/loading_json/footer.json',
        // 'assets/loading_json/undefined_ske.json',
        package: 'flutter_effect',
        fit: BoxFit.fill,
        alignment: Alignment.bottomCenter,
        repeat: true,
      ),
    );
  }
}
