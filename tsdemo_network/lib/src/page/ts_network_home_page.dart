import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:app_network/app_network.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_network/src/mock/local_mock_util.dart';
import 'package:flutter_log/src/log_console/print_console_log_util.dart';
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

    AppNetworkKit.start(
      baseUrl: baseUrl,
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
                AppNetworkKit.changeOptions(
                  baseUrl: baseUrl,
                );
              },
            ),
            ListTile(
              title: Text('切换环境:mock'),
              onTap: () {
                String baseUrl = "http://121.41.91.92:3000/mock/28/api/bjh/";
                AppNetworkKit.changeOptions(
                  baseUrl: baseUrl,
                );
              },
            ),
            ListTile(
              title: Text('切换代理:none'),
              onTap: () {
                AppNetworkKit.changeProxy(null);
              },
            ),
            ListTile(
              title: Text('切换代理:mac'),
              onTap: () {
                AppNetworkKit.changeProxy('192.168.72.55:8888');
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
    LocalMockUtil.localApiDirBlock = (String apiPath) {
      return "packages/tsdemo_network/assets/data/";
    };
    String url = LocalMockUtil.localApiHost + '/account/wallet/wishStar/page';
    Map<String, dynamic> customParams = {"accountId": id, "message": message};

    ResponseModel responseModel1 = await AppNetworkKit.post(
      url,
      params: customParams,
      cancelToken: cancelToken,
    );
    // print('请求结果1:\nresponseModel=$responseModel1,result=${responseModel1.result}');

    AppNetworkKit.post(
      url,
      params: customParams,
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      // print('请求结果2:\nresponseModel=$responseModel,result=${responseModel.result}');
    });
  }
}
