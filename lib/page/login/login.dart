import 'package:flutter/material.dart';
import 'package:flutter_application_2/exception/DebugReportException.dart';
import 'package:flutter_application_2/page/index/index.dart';
import 'package:flutter_application_2/page/login/users.dart';
import 'package:flutter_application_2/util/SpUtils.dart';
import 'package:flutter_application_2/util/StringUtil.dart';
import 'package:flutter_application_2/api/AuthApi.dart';
import 'dart:convert';

import '../../config/SlideUpPageRoute.dart';

/// 登录页
class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _siteName = '登录';

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // 控件被创建的时候，会执行 initState
  @override
  void initState() {
    super.initState();
    _emailController.text = "zz@163.com";
    _passwordController.text = "zz379213";
    getTitle();
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              //   leading: IconButton(
              //     icon: Icon(
              //       Icons.arrow_back_ios,
              //     ),
              //     onPressed: () => Navigator.pop(context),
              //   ),
              ),
          body: Center(
            child: Column(
              // 纵轴
              children: <Widget>[
                SizedBox(
                  height: pageHeight * 0.03,
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
                Column(
                  children: [
                    Container(
                      width: 350,
                      height: 50,
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: '用户邮箱',
                          filled: true,
                          fillColor: Colors.white38,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              )),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: '登录密码',
                            filled: true,
                            fillColor: Colors.white38,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            prefixIcon: Icon(Icons.lock)),
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(
                          height: 1.0,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: 350,
                  height: 55,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text(
                      "登录",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () {
                      login(context);
                    },
                  ),
                ),
                SizedBox(height: pageHeight * 0.246),
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
          )),
    );
  }

  void getTitle() async {
    var result = await SpUtils.getString('CurrentTitle');
    setState(() {
      _siteName = result;
    });
  }

  /// 登录
  void login(BuildContext context) async {
    // 校验邮箱和密码
    if (_emailController.text.isEmpty) {
      throw FormatException('邮箱不能为空');
    }
    if (_passwordController.text.isEmpty) {
      throw FormatException('密码不能为空');
    }
    // 登录
    var result = await AuthApi.login({
      'userName': _emailController.text,
      'Password': _passwordController.text,
      'captchaCode': ''
    });
    if (result['code'] == 40020) {
      throw DebugReportException('邮箱或密码错误');
    }

    // 加载本地账号
    var siteUrl = await SpUtils.getString('CurrentBaseUrl');
    Map<String, dynamic> userInfo = {
      'data': result['data'],
      'userName': _emailController.text,
      'Password': _passwordController.text,
      'siteName': _siteName,
      'siteUrl': siteUrl
    };
    convertAvatar(siteUrl, userInfo['data']);

    final accountList = <String>[];
    accountList.add(json.encode(userInfo));

    List<String> localList = await SpUtils.getStringList('accounts');

    if (localList.isNotEmpty) {
      for (var value in localList) {
        Map<String, dynamic> jsonData = json.decode(value);
        if (jsonData['siteUrl'] != siteUrl ||
            jsonData['userName'] != userInfo['userName']) {
          convertAvatar(siteUrl, jsonData['data']);
          accountList.add(value);
        }
      }
    }
    SpUtils.setString('currentUserName', _emailController.text);
    SpUtils.setStringList('accounts', accountList);
    SpUtils.setString('userInfo', json.encode(userInfo));
    SpUtils.setBool("isLogin", true);
    SpUtils.setString('currentMenu', '/');

    // 跳转根目录
    Navigator.pushReplacementNamed(context, "/");
  }

  convertAvatar(String siteUrl, Map<String, dynamic> jsonData) {
    String avatar = siteUrl + '/api/v3/user/avatar/' + jsonData['id'] + '/s';
    jsonData['avatar'] = avatar;
  }
}
