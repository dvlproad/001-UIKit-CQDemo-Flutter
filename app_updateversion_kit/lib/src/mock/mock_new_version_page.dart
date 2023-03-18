/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-09-29 13:37:59
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../check_version_util.dart';

class MockNewVersionPage extends StatefulWidget {
  @override
  _MockNewVersionPageState createState() => _MockNewVersionPageState();
}

class _MockNewVersionPageState extends State<MockNewVersionPage> {
  TextEditingController _versionController = TextEditingController();
  TextEditingController _buildNumberController = TextEditingController();

  String? _currentVersion;
  String? _currentBuildNumber;

  @override
  void initState() {
    super.initState();

    _getPackageInfo();
  }

  _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _currentVersion = packageInfo.version;
      _currentBuildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('模拟有新版本的页面'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: _currentVersion,
                helperText: '请输入模拟的后台版本号',
              ),
              controller: _versionController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: _currentBuildNumber,
                helperText: '请输入模拟的后台版本编译号',
              ),
              controller: _buildNumberController,
            ),
            Container(height: 20),
            GestureDetector(
              onTap: () {
                String? mockServiceVersion = _versionController.text;
                String? mockServiceBuildNumber = _buildNumberController.text;
                _mockCheckVersion(
                  mockServiceVersion: mockServiceVersion,
                  mockServiceBuildNumber: mockServiceBuildNumber,
                );
              },
              child: Container(
                color: Colors.blue,
                height: 44,
                width: 200,
                child: Center(
                  child: Text(
                    '模拟新版本，检查更新',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _mockCheckVersion({
    String? mockServiceVersion,
    String? mockServiceBuildNumber,
  }) {
    LoadingUtil.showInContext(context);
    CheckVersionUtil.checkVersion(
      isManualCheck: true,
      changeServiceVersionBlock: (String realServiceVersion) {
        if (mockServiceVersion != null && mockServiceVersion.isNotEmpty) {
          return mockServiceVersion;
        } else {
          List<String> mockVersionComponents = realServiceVersion.split('.');
          int mockVersionFirstComponent =
              int.parse(mockVersionComponents.first) + 1;
          String mockVersionFirstComponentString =
              mockVersionFirstComponent.toString();
          mockVersionComponents
              .replaceRange(0, 1, [mockVersionFirstComponentString]);
          String newServiceVersion = mockVersionComponents.join('.');
          return newServiceVersion;
        }
      },
      changeServiceBuildNumberBlock: (String realServiceBuildNumber) {
        if (mockServiceBuildNumber != null &&
            mockServiceBuildNumber.isNotEmpty) {
          return mockServiceBuildNumber;
        } else {
          int newServiceBuildNumber = int.parse(realServiceBuildNumber) + 1;
          return newServiceBuildNumber.toString();
        }
      },
    ).then((value) {
      LoadingUtil.dismissInContext(context);
    }).catchError((onError) {
      LoadingUtil.dismissInContext(context);
    });
  }
}
