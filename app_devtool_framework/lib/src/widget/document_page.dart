import 'package:flutter/material.dart';
import 'dart:io';
import 'clear_cache_util.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter_overlay_kit/toast/toast_util.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {

  List<Widget> widgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    path.getApplicationDocumentsDirectory().then((value) {
      _getChildren(file: value, padding: 0, list: widgets).then((value) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  minWidth: 0,
                  onPressed: () async {
                    LoadingUtil.show();
                    final dir = await path.getApplicationDocumentsDirectory();
                    final testDir = Directory("${dir.path}/test");
                    if (!testDir.existsSync()) {
                      testDir.createSync();
                    }
                    final listFile = testDir.listSync();
                    final count = listFile.length;
                    final file = File("${testDir.path}/$count");

                    List<int> bytes = List.filled(200 * 1024 * 1024, 0);
                    file.writeAsBytes(bytes).then((value) {
                      ToastUtil.showMessage("添加测试文件成功");
                      _refresh();
                      LoadingUtil.dismiss();
                    });
                  },
                  child: Text("添加测试文件 200M", style: TextStyle(fontSize: 10)),),
                MaterialButton(
                  minWidth: 0,
                  onPressed: () async {
                    LoadingUtil.show();
                    final dir = await path.getApplicationDocumentsDirectory();
                    final testDir = Directory("${dir.path}/test");
                    if (testDir.existsSync()) {
                      _delDir(testDir).then((value) {
                        ToastUtil.showMessage("删除测试文件成功");
                        _refresh();
                        LoadingUtil.dismiss();
                      });
                    }
                  }, child: Text("删除测试文件", style: TextStyle(fontSize: 10)),),
                MaterialButton(
                    minWidth: 0,
                    onPressed: () async {
                      final dir = await path.getApplicationDocumentsDirectory();
                      for (var file in dir.listSync()) {
                        if (!file.path.contains("city.json")) {
                          await _delDir(file);
                        }
                      }
                      ToastUtil.showMessage("清理成功");
                      _refresh();
                    },
                    child: Text(
                      "清空Document目录", style: TextStyle(fontSize: 10),))
              ],
            ),
            ...widgets
          ],
        ),
      ),
    );
  }

  _refresh() {
    widgets.clear();
    path.getApplicationDocumentsDirectory().then((value) {
      _getChildren(file: value, padding: 0, list: widgets)
          .then((value) {
        setState(() {});
      });
    });
  }

  Future<void> _getChildren({required FileSystemEntity file, List<
      Widget>? list, double padding = 20}) async {
    list ??= <Widget>[];
    double size = await _getTotalSizeOfFilesInDir(file);
    list.add(Container(
      color: file is File ? Colors.lightBlue:Colors.redAccent,
      margin: EdgeInsets.only(left: padding),
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50,
      alignment: Alignment.centerLeft,
      child: Text(
        "${file.path}--${_renderSize(size)}--${file is File ? "file" : "dir"}",
         style: const TextStyle(fontSize: 12,color: Colors.black),),
    ));
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (var child in children) {
        await _getChildren(file: child, list: list, padding: padding + 20);
      }
    }
    return Future(() => null);
  }


  // 循环计算文件的大小（递归）
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await _getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  Future<Null> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    await file.delete();
  }


// 计算大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    if (size == '0.00') {
      return '0M';
    }
    // print('size:${size == 0}\n ==SIZE${size}');
    return size + unitArr[index];
  }
}
