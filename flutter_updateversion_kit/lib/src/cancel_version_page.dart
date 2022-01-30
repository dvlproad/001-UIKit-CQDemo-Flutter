import 'package:flutter/material.dart';
import './check_version_common_util.dart';

class CancelVersionPage extends StatefulWidget {
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
        title: Text('不再提示更新的新版本'),
        actions: _cancelShowVersions?.length > 0
            ? [
                TextButton(
                  child: Text(
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
                      });
                    });
                  },
                ),
              ]
            : null,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
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
