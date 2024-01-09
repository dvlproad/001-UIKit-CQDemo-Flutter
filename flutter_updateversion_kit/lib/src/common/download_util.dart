// ignore_for_file: non_constant_identifier_names, unused_element

/*
 * @Author: dvlproad
 * @Date: 2024-01-09 16:12:22
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-09 17:38:05
 * @Description: 
 */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'download_file.dart';

class DownloadUtil {
  // static Future<bool> downloadAppUrl(String url) async {
  //   if (Platform.isAndroid) {
  //     return downloadAndroid(
  //       url,
  //       forceUpdate: forceUpdate,
  //       version: version,
  //       buildNumber: buildNumber,
  //       onReceiveProgress: onReceiveProgress,
  //       done: done,
  //       failed: failed,
  //     );
  //   } else {
  //     return launchAppDownloadUrl(url);
  //   }
  // }

  static Future<bool> launchAppDownloadUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // 拦截PlatformException 避免上报到bugly
      return launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      ).catchError((e) {
        return false;
      });
    } else {
      return false;
    }

    // bool goSuccess = await DownloadUtil.launchAppDownloadUrl(downloadUrl);
    // if (goSuccess != true) {
    //   ToastUtil.showMsg("Error:无法打开网页$downloadUrl", context);
    // }
  }

  static void skipUpdateAndroid(
    String url,
  ) {
    if (Platform.isAndroid) {
      MethodChannel methodChannel = const MethodChannel("android_updater");
      methodChannel.invokeMethod(
        "skip_this_version",
        {
          "url": url,
        },
      );
    }
  }

  static void downloadAndroid(
    String url, {
    required bool forceUpdate,
    required String version,
    required String buildNumber,
    void Function(int progress)? onReceiveProgress,
    void Function(String savePath)? done,
    void Function()? failed,
  }) async {
    // 跳转到应用市场
    if (url.startsWith("market://")) {
      launchAppDownloadUrl(url);
    } else if (url.endsWith('apk')) {
      await _downloadApk_plugin(
        url,
        forceUpdate: forceUpdate,
        version: version,
        buildNumber: buildNumber,
      );
      /*
      await _downloadApk(
        url,
        forceUpdate: forceUpdate,
        version: version,
        buildNumber: buildNumber,
        onReceiveProgress: onReceiveProgress,
        done: done,
        failed: failed,
      );
      */
    } else {
      launchAppDownloadUrl(url);
    }
  }

  static Future _downloadApk_plugin(
    String url, {
    required bool forceUpdate,
    required String version,
    required String buildNumber,
  }) async {
    MethodChannel methodChannel = const MethodChannel("android_updater");
    methodChannel.invokeMethod("DownloadApk", {
      "url": url,
      "forceUpdate": forceUpdate,
      "version": version,
      "buildNumber": buildNumber
    });
  }

  static Future _downloadApk(
    String url, {
    required bool forceUpdate,
    required String version,
    required String buildNumber,
    required void Function(int progress) onReceiveProgress,
    required void Function(String savePath) done,
    required void Function() failed,
  }) async {
    Directory? dir = await getExternalStorageDirectory();
    if (dir == null) {
      return;
    }
    String _storePath = dir.path.toString();
    String _fileName = "dvlproad_" + version + ".apk";
    String _savePath = _storePath + _fileName;
    File file = File(_savePath);
    if (await file.exists()) {
      _delFile(_savePath);
    }
    File tmpF = File(_storePath);
    if (!await tmpF.exists()) {
      Directory(_storePath).createSync();
    }
    await DownLoadFile().download(
      url,
      _savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          var progress = (received / total * 100).floor();
          if (progress == 0) {
            // todo loading判断
          }
          debugPrint(
              "下载已接收:${received.toString()}，总共：${total.toString()}，进度：+$progress%");
          onReceiveProgress(progress);
        }
      },
      done: () {
        done(_savePath);
      },
      failed: failed,
    );
  }

  static void _delFile(String path) {
    Directory(path)
        .delete(recursive: true)
        .then((FileSystemEntity fileSystemEntity) {
      debugPrint('删除path' + fileSystemEntity.path);
    });
  }
}
