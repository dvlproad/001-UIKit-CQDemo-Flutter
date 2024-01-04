import 'package:flutter/material.dart';
import 'package:app_network_kit/app_network_kit.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';

class TSNetworkHomePage extends StatefulWidget {
  const TSNetworkHomePage({super.key});

  @override
  _TSNetworkHomePageState createState() => _TSNetworkHomePageState();
}

class _TSNetworkHomePageState extends State<TSNetworkHomePage> {
  CancelToken? cancelToken;

  @override
  void dispose() {
    super.dispose();
    cancelToken?.cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            _chooseSexRow1,
            ListTile(
              title: const Text('切换环境:real'),
              onTap: () {
                _onlyChangeApiHost("http://dev.api.xxx.com/hapi/");
              },
            ),
            ListTile(
              title: const Text('切换环境:mock'),
              onTap: () {
                _onlyChangeApiHost("http://121.41.91.92:3000/mock/28/api/xxx/");
              },
            ),
            ListTile(
              title: const Text('切换代理:none'),
              onTap: () {
                AppNetworkChangeUtil.changeProxy(null);
              },
            ),
            ListTile(
              title: const Text('切换代理:mac'),
              onTap: () {
                AppNetworkChangeUtil.changeProxy('192.168.72.55:8888');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onlyChangeApiHost(String newApiHost) {
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    selectedNetworkModel.apiHost = newApiHost;

    AppNetworkChangeUtil.changeOptions(selectedNetworkModel);
  }

  Widget get _chooseSexRow1 {
    return ListTile(
      title: const Text('Get请求'),
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

    ResponseModel responseModel1 = await AppNetworkManager().post(
      url,
      customParams: customParams,
    );
    debugPrint(
        '请求结果1:\nresponseModel=$responseModel1,result=${responseModel1.result}');

    AppNetworkManager()
        .post(
      url,
      customParams: customParams,
    )
        .then((ResponseModel responseModel) {
      // print('请求结果2:\nresponseModel=$responseModel,result=${responseModel.result}');
    });
  }
}
