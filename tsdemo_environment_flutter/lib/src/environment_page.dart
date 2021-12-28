import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

class TSEnvironmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TSEnvironmentPageState();
  }
}

class _TSEnvironmentPageState extends State<TSEnvironmentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _bodyWidget,
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('切换环境'),
    );
  }

  Widget get _bodyWidget {
    return EnvironmentPageContent();
  }
}
