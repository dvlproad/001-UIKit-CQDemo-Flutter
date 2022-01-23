import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_cache_kit/flutter_cache_kit.dart';

class TSCacheHomePage extends StatefulWidget {
  @override
  _TSCacheHomePageState createState() => _TSCacheHomePageState();
}

class _TSCacheHomePageState extends State<TSCacheHomePage> {
  void dispose() {}

  @override
  void initState() {
    super.initState();

    LocalStorage.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cache'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('保存 bool'),
              onTap: () {
                bool bValue = true;
                LocalStorage.save('test_bool', bValue);
                CJTSToastUtil.showMessage('保存结束');
              },
            ),
            ListTile(
              title: Text('获取 bool'),
              onTap: () {
                bool bValue = LocalStorage.get('test_bool');
                String message = bValue ? 'true' : 'false';
                CJTSToastUtil.showMessage(message);
              },
            ),
            rowWidget(
              saveTitle: '保存 String',
              onPressedSave: () {
                String string =
                    cqtsRandomString(3, 10, CQRipeStringType.english);
                LocalStorage.save('test_string', string);
                CJTSToastUtil.showMessage('保存结束');
              },
              getTitle: '获取 String',
              onPressedGet: () {
                String string = LocalStorage.get('test_string');
                String message = string;
                CJTSToastUtil.showMessage(message);
              },
            ),
            rowWidget(
              saveTitle: '保存 StringList',
              onPressedSave: () {
                List<String> stringList = [];
                for (var i = 0; i < 10; i++) {
                  String string =
                      cqtsRandomString(3, 10, CQRipeStringType.english);
                  stringList.add(string);
                }
                LocalStorage.save('test_stringList', stringList);
                CJTSToastUtil.showMessage('保存结束');
              },
              getTitle: '获取 StringList',
              onPressedGet: () {
                List<String> stringList = LocalStorage.get('test_stringList');
                String message = stringList.toString();
                CJTSToastUtil.showMessage(message);
              },
            ),
            rowWidget(
              saveTitle: '保存自定义类 Custom',
              onPressedSave: () {
                TSCustomBean customBean = TSCustomBean(
                  proxyId: '1001',
                  proxyIp: '192.168.1.1',
                  name: '代理',
                );
                LocalStorage.saveCustomBean(
                  'test_custom',
                  customBean,
                  itemToJson: (TSCustomBean bItem) {
                    return bItem.toJson();
                  },
                );
                CJTSToastUtil.showMessage('保存结束');
              },
              getTitle: '获取自定义类 Custom',
              onPressedGet: () {
                TSCustomBean customBean = LocalStorage.getCustomBean(
                  'test_custom',
                  fromJson: (bMap) {
                    return TSCustomBean.fromJson(bMap);
                  },
                );
                String message = customBean.toString();
                CJTSToastUtil.showMessage(message);
              },
            ),
            rowWidget(
              saveTitle: '保存自定义类 CustomBeans',
              onPressedSave: () {
                List<TSCustomBean> customBeans = [];
                for (var i = 0; i < 10; i++) {
                  TSCustomBean customBean = TSCustomBean(
                    proxyId: '1001',
                    proxyIp: '192.168.1.1',
                    name: '代理',
                  );
                  customBeans.add(customBean);
                }

                LocalStorage.saveCustomBeans(
                  'test_customBeans',
                  customBeans,
                  itemToJson: (TSCustomBean bItem) {
                    return bItem.toJson();
                  },
                );
                CJTSToastUtil.showMessage('保存结束');
              },
              getTitle: '获取自定义类 CustomBeans',
              onPressedGet: () {
                List<TSCustomBean> customBeans = LocalStorage.getCustomBeans(
                  'test_customBeans',
                  fromJson: (bMap) {
                    return TSCustomBean.fromJson(bMap);
                  },
                );
                String message = customBeans.toString();
                CJTSToastUtil.showMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget rowWidget2(String key) {
  //   return rowWidget(
  //     saveTitle: '保存$key',
  //     onPressedSave: () {
  //       LocalStorage.save('test_bool', true);
  //     },
  //     getTitle: '获取$key',
  //     onPressedGet: () {
  //       bool bValue = LocalStorage.get('test_bool');
  //       String message = bValue ? 'true' : 'false';
  //       CJTSToastUtil.showMessage(message);
  //     },
  //   );
  // }

  Widget rowWidget(
      {@required String saveTitle,
      @required VoidCallback onPressedSave,
      @required String getTitle,
      @required VoidCallback onPressedGet}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CQTSThemeBGButton(
          title: saveTitle,
          onPressed: onPressedSave,
        ),
        CQTSThemeBGButton(
          title: getTitle,
          onPressed: onPressedGet,
        ),
      ],
    );
  }
}

class TSCustomBean {
  String proxyId;
  String name; // 网络代理的名称
  String proxyIp; // 网络代理的 ip
  String useDirection; // 使用说明
  bool check; // 是否选中

  TSCustomBean({
    this.proxyId,
    this.name,
    this.proxyIp,
    this.useDirection,
    this.check,
  });

  // json 与 model 转换
  factory TSCustomBean.fromJson(Map<String, dynamic> json) {
    return TSCustomBean(
      proxyId: json['proxyId'],
      name: json['name'],
      proxyIp: json['proxyIp'],
      useDirection: json['useDirection'],
      check: json['check'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "proxyId": this.proxyId,
      "name": this.name,
      "proxyIp": this.proxyIp,
      "useDirection": this.useDirection,
      "check": this.check,
    };
  }

  @override
  String toString() {
    return '{"proxyId":$proxyId, "proxyIp":$proxyIp, "name":$name}';
  }
}
