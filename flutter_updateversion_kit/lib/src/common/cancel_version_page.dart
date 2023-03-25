/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 21:07:40
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './check_version_common_util.dart';

class CancelVersionPage extends StatefulWidget {
  const CancelVersionPage({
    Key? key,
  }) : super(key: key);

  @override
  _CancelVersionPageState createState() => _CancelVersionPageState();
}

class _CancelVersionPageState extends State<CancelVersionPage> {
  List<String> _cancelShowVersions = [];

  @override
  void initState() {
    super.initState();

    CheckVersionCommonUtil.getCancelShowVersion()
        .then((List<String> bCancelShowVersions) {
      setState(() {
        _cancelShowVersions = bCancelShowVersions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('不再提示更新的版本'),
        actions: _cancelShowVersions.isNotEmpty
            ? [
                TextButton(
                  child: const Text(
                    '清空',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      CheckVersionCommonUtil.removeAllCancelShowVersions()
                          .then((value) {
                        _cancelShowVersions = [];

                        AlertUtil.showIKnowAlert(
                          context,
                          title: '清空成功',
                          iKnowHandle: () {
                            Navigator.pop(context);
                          },
                        );
                      });
                    });
                  },
                ),
              ]
            : null,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView.builder(
          itemCount: _cancelShowVersions.length,
          itemBuilder: (context, index) {
            String version = _cancelShowVersions[index];
            return ListTile(title: Text(version));
          },
        ),
      ),
    );
  }
}
