import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

import './interceptor/interceptor_request.dart';
import './interceptor/interceptor_response.dart';
import './interceptor/interceptor_error.dart';
import './interceptor/interceptor_log.dart';

import './network_change_util.dart';

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

    _init();
  }

  _init() {
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
    Map<String, dynamic> headers,
    List<Interceptor> interceptors,
    bool nouseDefalutInterceptors = false,
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
      headers: headers,
    );

    List<Interceptor> lastInterceptors = [];
    if (nouseDefalutInterceptors == null || nouseDefalutInterceptors == false) {
      List<Interceptor> defaultInterceptors = [
        RequestInterceptor(),
        ResponseInterceptor(),
        ErrorInterceptor(),
        DioLogInterceptor(),
      ];
      lastInterceptors.addAll(defaultInterceptors);
    }

    if (interceptors != null && interceptors.isNotEmpty) {
      lastInterceptors..addAll(interceptors);
    }

    dio.interceptors..addAll(lastInterceptors);

    NetworkManager.instance._hasStart = true;
  }
}

class NetworkChangeUtil {
  static String serviceValidProxyIp; // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，该值会是null)

  /// 修改 baseUrl
  static void changeOptions({
    String baseUrl,
  }) {
    Dio dio = NetworkManager.instance.serviceDio;
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
    );
  }

  static void changeHeaders({
    Map<String, dynamic> headers,
  }) {
    Dio dio = NetworkManager.instance.serviceDio;

    // Options options = Options(headers: headers);
    // dio.options = options;
    dio.options = dio.options.copyWith(
      headers: headers,
    );
  }

  // 修改代理 proxy(返回代理设置成功与否，当传入的ip地址格式不正确等则无法成功设置代理)
  static bool changeProxy(String proxyIp) {
    isValidProxyIp(proxyIp) {
      return false;
    }

    String serviceValidProxyIp = proxyIp;
    NetworkChangeUtil.serviceValidProxyIp = serviceValidProxyIp;

    Dio dio = NetworkManager.instance.serviceDio;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        if (serviceValidProxyIp != null) {
          return "PROXY $serviceValidProxyIp";
        } else {
          return 'DIRECT';
        }
      };
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) {
      //   return true;
      // };
    };

    return true;
  }

  // 判断是否是有效的代理ip地址
  static bool isValidProxyIp(String ipString) {
    if (ipString == null) {
      return false;
    }

    final reg = RegExp(r'^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}');

    bool isMatch = reg.hasMatch(ipString);
    return isMatch;
  }
}
