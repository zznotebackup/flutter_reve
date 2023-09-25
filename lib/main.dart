import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/AuthApi.dart';
import 'package:flutter_application_2/page/index/bottomBar.dart';
import 'package:flutter_application_2/page/index/index.dart';
import 'package:flutter_application_2/page/login/users.dart';
import 'package:flutter_application_2/util/SpUtils.dart';
import 'package:flutter_smart_dialog/src/init_dialog.dart';
import 'package:flutter_application_2/page/tools/customToast.dart';
import 'package:flutter_application_2/page/login/login.dart';
import 'package:flutter_application_2/handler/AppExceptionHandle.dart';
import 'package:flutter_application_2/exception/DebugReportException.dart';

import 'config/SlideUpPageRoute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isLogin = await SpUtils.getBool("isLogin");
  AppExceptionHandle().run(MyApp(
    isLogin: isLogin == null ? false : isLogin,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLogin;

  const MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: 'FlutterReve',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: theme,
      initialRoute: isLogin ? "/" : "/home",
      routes: {
        "/": (context) => Bottom(),
        "/login": (context) => Login(),
        "/home": (context) => MyHome(),
        "/users": (context) => Users(),
      },
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(
        //default toast widget
        toastBuilder: (String msg) => CustomToast(msg),
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _siteName = '站点绑定';
  var _siteAddrField = true;
  var _isButtonDisabled = false;

  TextEditingController _siteAddrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;
    _siteAddrController.text = "http://47.122.37.172:5210";
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Center(
              child: Column(
                // 纵轴
                children: <Widget>[
                  SizedBox(
                    height: pageHeight * 0.039,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset('images/favicon.ico',
                        width: 150, height: 150, fit: BoxFit.cover),
                  ),
                  SizedBox(height: pageHeight * 0.025),
                  Text(
                    _siteName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(height: pageHeight * 0.015),
                  Visibility(
                    visible: _siteAddrField,
                    child: Container(
                      width: 350,
                      child: TextField(
                        controller: _siteAddrController,
                        decoration: const InputDecoration(
                            hintText: '站点地址',
                            filled: true,
                            fillColor: Colors.white38,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            prefixIcon: Icon(Icons.public)),
                        maxLength: 40,
                        keyboardType: TextInputType.url,
                        style: TextStyle(
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                      visible: _siteAddrField,
                      child: Container(
                        width: 350,
                        height: 55,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Visibility(
                                visible: !_isButtonDisabled,
                                child: const Text(
                                  "继续",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Visibility(
                                  visible: _isButtonDisabled,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.grey[200],
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.blue),
                                    ),
                                  )),
                            ],
                          ),
                          onPressed: () {
                            selectConfig(_siteAddrController.text, context);
                          },
                        ),
                      )),
                  SizedBox(height: 10),
                  Visibility(
                    visible: _siteAddrField,
                    child: const Column(
                      children: [
                        Text('请输入访问 web 端的站点地址，请确保'),
                        Text('协议 (http/https) 和 web 站点相同'),
                      ],
                    ),
                  ),
                  SizedBox(height: 180),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.purpleAccent,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: 15),
                      IconButton(
                        icon: const Icon(
                          Icons.people_alt,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: () {
                          Navigator.push(context, SlideUpPageRoute(Users()));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Text('使用 FlutterReve 即表示您接受我们的 服务条款'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 查询站点配置信息
  void selectConfig(String text, BuildContext context) async {
    // 校验
    if (_isButtonDisabled) {
      return;
    }
    if (!Uri.parse(_siteAddrController.text).isAbsolute) {
      throw DebugReportException('站点配置错误');
    }
    try {
      setState(() {
        _isButtonDisabled = true;
      });
      String newStr = text[text.length - 1];
      if (newStr == "/") {
        text = text.substring(0, text.length - 1);
      }
      SpUtils.setString('CurrentBaseUrl', text);
      var result = await AuthApi.getConfig();
      SpUtils.setString('CurrentTitle', result['data']['title']);
      //导航到新路由
      Navigator.pushNamed(context, "/login");
    } finally {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  /// 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
