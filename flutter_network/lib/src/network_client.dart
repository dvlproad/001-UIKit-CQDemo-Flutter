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
  bool hasStart = false;

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
    if (NetworkManager.instance.hasStart == true) {
      //print('本方法只能执行一遍，前面已执行过,防止如initState调用多遍的时候,重复添加interceptors');
      return;
    }

    print('NetworkManager:初始化开始执行中...');
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

    NetworkManager.instance.hasStart = true;
    print('NetworkManager:初始化(设置baseUrl等)完成，此时才可以进行实际请求');
  }

  // 以下代码为 NetworkManager 的 ChangeUtil
  /************************* token 设置 *************************/
  /// 添加/修改token(登录成功后调用)
  static void addOrUpdateToken(String token) {
    Dio dio = NetworkManager.instance.serviceDio;
    Map<String, dynamic> requestHeaders = {'Authorization': token};
    DioChangeUtil.changeHeaders(dio, headers: requestHeaders);
  }

  /// 删除token(退出成功后调用)
  static void removeToken() {
    Dio dio = NetworkManager.instance.serviceDio;
    String removeKey = 'Authorization';
    DioChangeUtil.removeHeadersKey(dio, removeKey);
  }

  /************************* baseUrl 设置 *************************/
  /// 修改 baseUrl
  static void changeOptions({
    String baseUrl,
  }) {
    Dio dio = NetworkManager.instance.serviceDio;
    DioChangeUtil.changeOptions(dio, baseUrl: baseUrl);
  }

  /************************* proxy 设置 *************************/
  static String serviceValidProxyIp; // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，该值会是null)
  // 修改代理 proxy(返回代理设置成功与否，当传入的不是ip地址格式不正确等则无法成功设置代理)
  static bool changeProxy(String proxyIp) {
    Dio dio = NetworkManager.instance.serviceDio;
    bool changeSuccess = DioChangeUtil.changeProxy(dio, proxyIp: proxyIp);
    if (changeSuccess) {
      NetworkManager.serviceValidProxyIp = proxyIp;
    }

    return changeSuccess;
  }
}
