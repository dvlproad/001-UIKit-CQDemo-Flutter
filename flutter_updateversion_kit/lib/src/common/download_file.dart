import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/*
 * 文件下载
 * 懒加载单例
 */
class DownLoadFile {
  //用于记录正在下载的url，避免重复下载
//  var downloadingUrls = new List();
  var downloadingUrls = <String, CancelToken>{};

  // 单例公开访问点
  factory DownLoadFile() => _getInstance();

  // 静态私有成员，没有初始化
  static DownLoadFile? _instance;

  // 私有构造函数
  DownLoadFile._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static DownLoadFile _getInstance() {
    _instance ??= DownLoadFile._();
    return _instance!;
  }

  /*
   *下载
   */
  Future download(
    url,
    savePath, {
    required ProgressCallback onReceiveProgress,
    required Function done,
    required Function failed,
  }) async {
    int downloadStart = 0;
    bool fileExists = false;
    File f = File(savePath);
    if (await f.exists()) {
      downloadStart = f.lengthSync();
      fileExists = true;
    }
    debugPrint("开始：" + downloadStart.toString());
    if (fileExists && downloadingUrls.containsKey(url)) {
      //正在下载
      return;
    }
    var dio = Dio();
    int contentLength = await _getContentLength(dio, url);
    if (downloadStart == contentLength) {
      //存在本地文件，命中缓存
      done();
      return;
    }
    CancelToken cancelToken = CancelToken();
    downloadingUrls[url] = cancelToken;

    Future downloadByDio(String url, int start) async {
      try {
        Response response = await dio.get(
          url,
          options: Options(
            responseType: ResponseType.stream,
            followRedirects: false,
            headers: {"range": "bytes=$start-"},
          ),
          cancelToken: cancelToken,
        );
        debugPrint("${response.headers}");
        File file = File(savePath.toString());

        var raf = file.openSync(mode: FileMode.append);
        Completer completer = Completer<Response>();
        Future future = completer.future;

        int received = start;
        String? lengthString =
            response.headers.value(Headers.contentLengthHeader);
        int total = int.parse(lengthString ?? '0');
        Stream<List<int>> stream = response.data.stream;
        StreamSubscription? subscription;
        Future? asyncWrite;
        subscription = stream.listen(
          (data) {
            subscription?.pause();
            // Write file asynchronously
            asyncWrite = raf.writeFrom(data).then((_raf) {
              // Notify progress
              received += data.length;
              onReceiveProgress(received, total);
              raf = _raf;
              if (!cancelToken.isCancelled) {
                subscription?.resume();
              }
            });
          },
          onDone: () async {
            try {
              await asyncWrite;
              await raf.close();
              completer.complete(response);
              downloadingUrls.remove(url);
              done();
            } catch (e) {
              downloadingUrls.remove(url);
              completer
                  .completeError(_assureDioError(response.requestOptions, e));
              failed(e);
            }
          },
          onError: (e) async {
            try {
              await asyncWrite;
              await raf.close();
              downloadingUrls.remove(url);
              failed(e);
            } finally {
              completer
                  .completeError(_assureDioError(response.requestOptions, e));
            }
          },
          cancelOnError: true,
        );
        // ignore: unawaited_futures
        cancelToken.whenCancel.then((_) async {
          await subscription?.cancel();
          await asyncWrite;
          await raf.close();
        });

        return await _listenCancelForAsyncTask(cancelToken, future);
      } catch (e) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e is DioError == false) {
          failed(e);
          return;
        }
        DioError err = e as DioError;
        if (err.response != null) {
          debugPrint("${err.response!.data}");
          debugPrint("${err.response!.headers}");
          debugPrint("${err.response!.requestOptions}");
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          debugPrint("${err.requestOptions}");
          debugPrint(err.message);
        }
        if (CancelToken.isCancel(err)) {
          debugPrint("下载取消");
        } else {
          failed(err);
        }
        downloadingUrls.remove(url);
      }
    }

    await downloadByDio(url, downloadStart);
  }

  /*
   * 获取下载的文件大小
   */
  Future<int> _getContentLength(Dio dio, url) async {
    try {
      Response response = await dio.head(url);
      String? string = response.headers.value(Headers.contentLengthHeader);
      if (string == null) {
        return 0;
      }
      return int.parse(string);
    } catch (e) {
      debugPrint("_getContentLength Failed:" + e.toString());
      return 0;
    }
  }

  void stop(String url) {
    if (downloadingUrls.containsKey(url)) {
      downloadingUrls[url]?.cancel();
    }
  }

  Future<T> _listenCancelForAsyncTask<T>(
      CancelToken cancelToken, Future<T> future) {
    Completer completer = Completer();
    if (cancelToken.cancelError == null) {
      cancelToken.addCompleter(completer);
      return Future.any([completer.future, future]).then<T>((result) {
        cancelToken.removeCompleter(completer);
        return result;
      }).catchError((e) {
        cancelToken.removeCompleter(completer);
        throw e;
      });
    } else {
      return future;
    }
  }

  DioError _assureDioError(RequestOptions requestOptions, dynamic err) {
    if (err is DioError) {
      return err;
    } else {
      var _err = DioError(requestOptions: requestOptions, error: err);
      if (err is Error) {
        if (_err.response != null && err.stackTrace != null) {
          _err.response!.data = err.stackTrace!;
        }
      }
      return _err;
    }
  }
}

extension CancelTokenExtension on CancelToken {
  static List<Completer> completers = [];

  _trigger(Completer completer) {
    if (cancelError != null) {
      completer.completeError(cancelError!);
    }
    completers.remove(completer);
  }

  /// Add a [completer] to the token.
  /// [completer] is used to cancel the request before it's not completed.
  ///
  /// Note: you shouldn't invoke this method by yourself. It's just used inner [Dio].
  /// @nodoc
  void addCompleter(Completer completer) {
    if (cancelError != null) {
      _trigger(completer);
    } else {
      if (!completers.contains(completer)) {
        completers.add(completer);
      }
    }
  }

  /// Remove a [completer] from the token.
  ///
  /// Note: you shouldn't invoke this method by yourself. It's just used inner [Dio].
  /// @nodoc
  void removeCompleter(Completer completer) {
    completers.remove(completer);
  }
}
