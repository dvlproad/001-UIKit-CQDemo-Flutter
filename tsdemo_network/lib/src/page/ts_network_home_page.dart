import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:dio/dio.dart';

import 'dart:convert';

class TSNetworkHomePage extends StatefulWidget {
  @override
  _TSNetworkHomePageState createState() => _TSNetworkHomePageState();
}

class _TSNetworkHomePageState extends State<TSNetworkHomePage> {
  CancelToken cancelToken;
  void dispose() {
    cancelToken?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            _chooseSexRow1,
          ],
        ),
      ),
    );
  }

  Widget get _chooseSexRow1 {
    return ListTile(
      title: Text('Get请求'),
      onTap: () {
        requestData('11', '22');
      },
    );
  }

  requestData(String id, String message) async {
    Map<String, dynamic> result = await request(
      'http://121.41.91.92:3000/mock/28/api/bjh/account/wallet/wishStar/page',
      formData: {"id": id, "message": message},
      cancelToken: cancelToken,
    );
    print('result=$result');
  }
}
