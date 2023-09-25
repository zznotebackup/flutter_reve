import 'package:dio/dio.dart';
import 'package:flutter_application_2/exception/NotLoginException.dart';
import './SpUtils.dart';

/// 请求方法
enum DioMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
}

class DioUtil {
  /// 单例模式
  static DioUtil? _instance;

  factory DioUtil() => _instance ?? DioUtil._internal();

  static DioUtil? get instance => _instance ?? DioUtil._internal();

  /// 连接超时时间
  static const Duration connectTimeout = Duration(milliseconds: 3 * 1000);

  /// 响应超时时间
  static const Duration receiveTimeout = Duration(milliseconds: 60 * 1000);

  /// Dio实例
  static Dio _dio = Dio();

  /// 初始化
  DioUtil._internal() {
    // 初始化基本选项
    _instance = this;
    BaseOptions options = BaseOptions(
        baseUrl: 'http://127.0.0.1:5212',
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout);
    // 初始化dio
    _dio = Dio(options);
    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
  }

  /// 请求拦截器
  void _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 对非open的接口的请求参数全部增加userId
    // if (!options.path.contains("open")) {
    //   options.queryParameters["userId"] = "xxx";
    // }
    // 头部添加token
    // options.headers["Authorization"] = "e59942d9-7783-4f1f-be71-a3748e130c4e";
    String cookie = await SpUtils.getString('Cookie');
    if (cookie.isNotEmpty) {
      options.headers["Cookie"] = cookie;
    }
    // 更多业务需求
    handler.next(options);
    // 切换到当前站点
    options.baseUrl = await selectConfig();
    // super.onRequest(options, handler);
  }

  /// 相应拦截器
  void _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    if (response.statusCode == 1) {
      // ....
    } else if (response.data['code'] == 401) {
      throw NotLoginException("未登录");
    }
    if (response.requestOptions.baseUrl.contains("???????")) {
      // 对某些单独的url返回数据做特殊处理
    }

    String local = await SpUtils.getString('Cookie');
    if (local.isEmpty) {
      var cookie = response.headers.map['set-cookie'];
      if (cookie != null) {
        SpUtils.setString('Cookie', cookie[0]);
      }
    }

    handler.next(response);
  }

  /// 错误处理
  void _onError(DioException error, ErrorInterceptorHandler handler) {
    handler.next(error);
  }

  /// 请求类
  Future<T> request<T>(
    String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    const _methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };
    options ??= Options(method: _methodValues[method]);
    try {
      Response response;
      response = await _dio.request(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// 开启日志打印
  /// 需要打印日志的接口在接口请求前 DioUtil.instance?.openLog();
  void openLog() {
    _dio.interceptors
        .add(LogInterceptor(responseHeader: false, responseBody: true));
  }

  Future<String> selectConfig() async {
    return await SpUtils.getString('CurrentBaseUrl');
  }
}
