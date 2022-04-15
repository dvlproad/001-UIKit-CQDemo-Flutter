import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network/src/network_client.dart';
import 'package:flutter_network/src/interceptor/interceptor_request.dart';
import 'package:flutter_network/src/interceptor/interceptor_response.dart';
import 'package:flutter_network/src/interceptor/interceptor_error.dart';
import 'package:flutter_network/src/interceptor/interceptor_log.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:dio/dio.dart';

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
  void initState() {
    super.initState();

    String baseUrl = "http://dev.api.xxx.com/hapi/";

    LogUtil.init(isDebug: true);
    // NetworkManager();
    NetworkManager.start(
      baseUrl: baseUrl,
      interceptors: [
        // RequestInterceptor(),
        // ResponseInterceptor(),
        // ErrorInterceptor(),
        DioLogInterceptor(),
      ],
    );
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
            ListTile(
              title: Text('切换环境:real'),
              onTap: () {
                String baseUrl = "http://dev.api.xxx.com/hapi/";
                NetworkChangeUtil.changeOptions(
                  baseUrl: baseUrl,
                );
              },
            ),
            ListTile(
              title: Text('切换环境:mock'),
              onTap: () {
                String baseUrl = "http://121.41.91.92:3000/mock/28/api/bjh/";
                NetworkChangeUtil.changeOptions(
                  baseUrl: baseUrl,
                );
              },
            ),
            ListTile(
              title: Text('切换代理:none'),
              onTap: () {
                NetworkChangeUtil.changeProxy(null);
              },
            ),
            ListTile(
              title: Text('切换代理:mac'),
              onTap: () {
                NetworkChangeUtil.changeProxy('192.168.72.55:8888');
              },
            ),
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
    String url = '/account/wallet/wishStar/page';
    Map<String, dynamic> customParams = {"accountId": id, "message": message};

    ResponseModel responseModel1 = await NetworkUtil.postRequestUrl(
      url,
      customParams: customParams,
      cancelToken: cancelToken,
    );
    print(
        '请求结果1:responseModel=$responseModel1,result=${responseModel1.result}');

    NetworkUtil.postRequestUrl(
      url,
      customParams: customParams,
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      print(
          '请求结果2:responseModel=$responseModel,result=${responseModel.result}');
    });

    NetworkUtil.postUrl(
      url,
      customParams: customParams,
      cancelToken: cancelToken,
      onSuccess: (result) {
        print('请求结果3:result=$result');
      },
      onFailure: (failureMessage) {
        print('请求结果3:failureMessage=$failureMessage');
      },
    );
  }
}
