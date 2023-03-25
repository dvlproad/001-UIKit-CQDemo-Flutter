import 'package:flutter/material.dart';
import './env_widget.dart';

class EnvPage extends StatefulWidget {
  const EnvPage({Key? key}) : super(key: key);

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<EnvPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('环境工具'),
      ),
      body: const EnvWidget(),
    );
  }
}
