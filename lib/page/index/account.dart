import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/InfoApi.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../util/SpUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

/// 用户信息页
class Account extends StatefulWidget {
  Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with AutomaticKeepAliveClientMixin {
  late Map<String, dynamic> _userInfo = {
    "data": {
      "avatar": "",
      "nickname": "",
      "group": {"name": ""}
    },
    "userName": ""
  };
  final Uri _url = Uri.parse('https://forum.cloudreve.org');
  late String _freshTime = "";
  late int _free = 0;
  late int _total = 1;

  // 控件被创建的时候，会执行 initState
  @override
  void initState() {
    super.initState();
    getUserInfo();
    // getStorage();
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                    left: pageWidth * 0.05, right: pageWidth * 0.05),
                child: Column(
                  children: [
                    Container(
                      // 距离顶端
                      margin: EdgeInsets.only(top: pageHeight * 0.05),
                      width: 110,
                      height: 110,
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
                      child: Image.network(_userInfo['data']['avatar'],
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                        return Image.asset('images/favicon.ico');
                      }),
                    ),
                    Text(
                      _userInfo['data']['nickname'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    Text(_userInfo['userName'],
                        style: TextStyle(fontSize: 20, color: Colors.black26)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(224, 241, 227, 193),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 60,
                          width: pageWidth * 0.28,
                          child: Container(
                            margin: EdgeInsets.only(left: pageWidth * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text("UID",
                                    style: TextStyle(color: Colors.black54)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    _userInfo['data']['group']['id'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: pageWidth * 0.02),
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(224, 231, 224, 220),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 60,
                          width: pageWidth * 0.28,
                          child: Container(
                            margin: EdgeInsets.only(left: pageWidth * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text("用户组",
                                    style: TextStyle(color: Colors.black54)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(_userInfo['data']['group']['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: pageWidth * 0.02),
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(224, 221, 255, 210),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 60,
                          width: pageWidth * 0.28,
                          child: Container(
                            margin: EdgeInsets.only(left: pageWidth * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text("webdav",
                                    style: TextStyle(color: Colors.black54)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    _userInfo['data']['group']['webdav']
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: pageWidth * 0.03),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(224, 205, 221, 248),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 130,
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: pageWidth * 0.03, top: 8),
                              width: pageWidth * 0.55,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("可用容量",
                                      style: TextStyle(color: Colors.black54)),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                      formatBytes(_free) +
                                          " / " +
                                          formatBytes(_total),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(height: 28),
                                  Text("更新于：$_freshTime",
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.black54)),
                                ],
                              )),
// SizedBox(width: pageWidth * 0.25),
                          CircularPercentIndicator(
                            radius: 52.0,
                            lineWidth: 10.0,
                            percent: (_free / _total),
                            center: new Text(
                              (100 * _free / _total)
                                      .toDouble()
                                      .floor()
                                      .toString() +
                                  " %",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            progressColor: Color.fromARGB(255, 38, 143, 236),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.only(left: pageWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(219, 26, 111, 255),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.lock,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: pageWidth * 0.04),
                              const Expanded(
                                child: Text("隐私和安全",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(right: pageWidth * 0.02),
                                  child: Icon(Icons.chevron_right))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.only(left: pageWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(219, 96, 213, 184),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.accessibility,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: pageWidth * 0.04),
                              const Expanded(
                                child: Text("外观偏好",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(right: pageWidth * 0.02),
                                  child: Icon(Icons.chevron_right))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          launchUrl(_url);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.only(left: pageWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(219, 255, 145, 17),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.speaker_notes,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: pageWidth * 0.04),
                              const Expanded(
                                child: Text("用户论坛",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(right: pageWidth * 0.02),
                                  child: Icon(Icons.chevron_right))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GiffyDialog.image(
                                  Image.asset('images/warming.png', height: 50),
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    '确认',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  content: const Text(
                                    '你确认要退出登录吗？\n所有正在运行中的任务，比如上传 / 下载均会停止',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 215, 100, 6)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      child: const Stack(
                                        children: [
                                          Text(
                                            "退出登录",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        // 切换登录状态
                                        SpUtils.setBool("isLogin", false);
                                        // 跳转路由
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, "/home", (route) => false);
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 234, 233, 233)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      child: const Stack(
                                        children: [
                                          Text(
                                            "取消",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                      },
                                    )
                                  ],
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  entryAnimation: EntryAnimation.bottom);
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.only(left: pageWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(219, 255, 17, 81),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_circle_right,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: pageWidth * 0.03),
                              const Expanded(
                                child: Text("退出登录",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(right: pageWidth * 0.02),
                                  child: Icon(Icons.chevron_right))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  /// 保持页面状态
  @override
  bool get wantKeepAlive => true;

  void getUserInfo() async {
    var result = await SpUtils.getString('userInfo');
    Map<String, dynamic> jsondata = jsonDecode(result);
    setState(() {
      _userInfo = jsondata;
    });
    getStorage();
  }

  /// 空间使用情况
  void getStorage() async {
    var result = await InfoApi.getStorage();
    print(result);
    if (result['code'] == 0) {
      final timeFormat = DateFormat('yyyy/MM/dd');
      setState(() {
        _total = result['data']['total'];
        _free = result['data']['free'];
        _freshTime = timeFormat.format(DateTime.now());
      });
      SpUtils.setString('freshTime', _freshTime);
    } else {
      // 拿缓存时间
      var time = await SpUtils.getString('freshTime');
      setState(() {
        _freshTime = time;
      });
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    getUserInfo();
  }

  String formatBytes(int fileSize) {
    final numberFormat = NumberFormat('#,##0');
    final kiloBytes = 1024;
    final megaBytes = kiloBytes * 1024;
    final gigaBytes = megaBytes * 1024;
    final teraBytes = gigaBytes * 1024;

    String fileSizeString;
    if (fileSize < kiloBytes) {
      fileSizeString = '${numberFormat.format(fileSize)} B';
    } else if (fileSize < megaBytes) {
      fileSizeString = '${numberFormat.format(fileSize / kiloBytes)} KB';
    } else if (fileSize < gigaBytes) {
      fileSizeString = '${numberFormat.format(fileSize / megaBytes)} MB';
    } else if (fileSize < teraBytes) {
      fileSizeString = '${numberFormat.format(fileSize / gigaBytes)} GB';
    } else {
      fileSizeString = '${numberFormat.format(fileSize / teraBytes)} TB';
    }

    return fileSizeString;
  }
}
