import 'package:dio/dio.dart';
import './log_util.dart';

class Service {
  static const int CONNECT_TIMEOUT = 60000;
  static const int RECEIVE_TIMEOUT = 60000;

  Dio _dio;

  static final Service _instance = Service._internal();

  factory Service() => _instance;

  Dio get dio => _dio;

  Service._internal() {
    if (_dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );
      _dio = Dio(options);
    }
  }

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void init(
      {String baseUrl,
      int connectTimeout,
      int receiveTimeout,
      List<Interceptor> interceptors}) {
    _dio.options = _dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors..addAll(interceptors);
    }
  }

  /// 修改 baseUrl
  void changeOptions({String baseUrl}) {
    LogUtil.v('baseUrl = $baseUrl');
    _dio.options = _dio.options.copyWith(
      baseUrl: baseUrl,
    );
  }
}
