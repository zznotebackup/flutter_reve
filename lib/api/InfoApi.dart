import 'package:flutter_application_2/util/DioUtil.dart';
import 'package:dio/dio.dart';

import '../util/SpUtils.dart';

class InfoApi {
  // 获取最上层列表
  static getRootFileList() async {
    String menu = await SpUtils.getString('currentMenu');
    var result = await DioUtil()
        .request('/api/v3/directory' + menu, method: DioMethod.get);
    return result;
  }

  // 获取当前列表
  static getCurrentFileList() async {
    String menu = await SpUtils.getString('currentMenu');
    var result = await DioUtil()
        .request('/api/v3/directory' + menu, method: DioMethod.get);
    return result;
  }

  static getStorage() async {
    var result =
        await DioUtil().request('/api/v3/user/storage', method: DioMethod.get);
    return result;
  }
}
