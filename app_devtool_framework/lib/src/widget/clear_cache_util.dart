/*
 * @Author: dvlproad
 * @Date: 2022-05-07 10:54:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-30 18:03:54
 * @Description: 
 */
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './clear_cache_util.dart';

class DirSizeUtil {
// 加载缓存
  static Future<String> loadLibraryCachesSize() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    // print('临时目录大小: ' + value.toString());
    return _renderSize(value);
  }

  static Future<String> loadDocumentsSize() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String dirPath = tempDir.path;
    debugPrint("appDirPath = $dirPath");
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    // print('Documents 目录大小: ' + value.toString());
    return _renderSize(value);
  }

  /// 获取文档目录下的数据库文件大小
  static Future<String> getDocumentDioCacheFileSize() async {
    final dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/DioCache.db');

    try {
      bool exists = await file.exists();
      if (!exists) {
        return "0";
      }
    } catch (e) {
      print(e);
    }

    int length = await file.length();
    double value = double.parse(length.toString());
    // print('Document DioCache.db 大小: ' + value.toString());
    return _renderSize(value);
  }

// 循环计算文件的大小（递归）
  static Future<double> _getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

// 递归方式删除目录
  static Future<Null> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    await file.delete();
  }

// 计算大小
  static _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
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

  /// 清理缓存
  ///
  static void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await _delDir(tempDir);
    await loadLibraryCachesSize();
    ToastUtil.showMessage('清除缓存成功');
  }
}
