import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_2/exception/NotLoginException.dart';
import 'package:flutter_smart_dialog/src/smart_dialog.dart';
import '../exception/DebugReportException.dart';
import 'package:dio/dio.dart';
import '../util/SpUtils.dart';

//全局异常的捕捉
class AppExceptionHandle {
  run(Widget app) {
    ///Flutter 框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      ///线上环境
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        //开发期间 print
        FlutterError.dumpErrorToConsole(details);
      }
    };

    runZonedGuarded(() {
      //受保护的代码块
      runApp(app);
    }, (error, stack) => {catchError(error, stack)});
  }

  ///对搜集的 异常进行处理  上报等等
  catchError(Object error, StackTrace stack) {
    // Vibration.vibrate(duration: 1000);
    if (error is DebugReportException) {
      SmartDialog.showToast(error.message);
    } else if (error is FormatException) {
      SmartDialog.showToast(error.message);
    } else if (error is NotLoginException) {
      // 登录过期
      SpUtils.remove('Cookie');
      SmartDialog.showToast("登录已过期,请重新登录");
    } else if (error is DioException) {
      if (error.type == DioExceptionType.unknown) {
        SmartDialog.showToast('${error.type.name} 站点配置错误,请检查后重新连接');
      } else if (error.type == DioExceptionType.connectionTimeout) {
        SmartDialog.showToast('${error.type.name} 连接超时');
      } else {
        SmartDialog.showToast(error.type.name);
      }
    } else {
      SmartDialog.showToast("系统错误");
      print(stack);
    }
  }
}
