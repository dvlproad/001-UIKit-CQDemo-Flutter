import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

import './interceptor/interceptor_request.dart';
import './interceptor/interceptor_response.dart';
import './interceptor/interceptor_error.dart';
import './interceptor/interceptor_log.dart';

class NetworkManager {
  static const int CONNECT_TIMEOUT = 60000;
  static const int RECEIVE_TIMEOUT = 60000;

  Dio serviceDio;
  bool _hasStart = false;

  // 单例
  factory NetworkManager() => _getInstance();
  static NetworkManager get instance => _getInstance();

  static NetworkManager _instance;
  NetworkManager._internal() {
    print('这个单例里的初始化方法只会执行一次');

    Dio dio = serviceDio;
    if (dio == null) {
      BaseOptions options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );
      dio = Dio(options);
      serviceDio = dio;
    }
  }

  static NetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkManager._internal();
    }
    return _instance;
  }

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  static void start({
    String baseUrl,
    int connectTimeout,
    int receiveTimeout,
    List<Interceptor> interceptors,
  }) {
    if (NetworkManager.instance._hasStart == true) {
      //print('本方法只能执行一遍，前面已执行过,防止如initState调用多遍的时候,重复添加interceptors');
      return;
    }

    print('NetworkManager start');
    Dio dio = NetworkManager.instance.serviceDio;
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors..addAll(interceptors);
    }

    NetworkManager.instance._hasStart = true;
  }
}

class NetworkChangeUtil {
  /// 修改 baseUrl
  static void changeOptions({String baseUrl}) {
    Dio dio = NetworkManager.instance.serviceDio;
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
    );
  }

  // 修改代理 proxy
  static void changeProxy(String proxyIp) {
    Dio dio = NetworkManager.instance.serviceDio;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        if (proxyIp != null) {
          return "PROXY $proxyIp";
        } else {
          return 'DIRECT';
        }
      };
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) {
      //   return true;
      // };
    };
  }
}
