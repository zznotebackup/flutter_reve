import 'package:flutter_application_2/util/DioUtil.dart';
import 'package:dio/dio.dart';

class AuthApi {
  // 获取云盘config信息
  static getConfig() async {
    var result =
        await DioUtil().request('/api/v3/site/config', method: DioMethod.get);
    return result;
  }

// 登录
  static login(Map<String, dynamic> params) async {
    var result = await DioUtil()
        .request('/api/v3/user/session', method: DioMethod.post, data: params);
    return result;
  }
}
