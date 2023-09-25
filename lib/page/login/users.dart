import 'package:flutter/material.dart';
import 'package:flutter_application_2/util/SpUtils.dart';
import 'dart:convert';

/// 账户管理
class Users extends StatefulWidget {
  Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late List userList = [];
  bool _isSelected = false;

  // 控件被创建的时候，会执行 initState
  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("账户管理",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.highlight_off,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.qr_code_scanner),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
              ),
            ],
          ),
          body: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var obj = userList[index];

                return Container(
                  width: 20,
                  height: 110,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(obj['siteName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 15, 101, 239))),
                        ],
                      ),
                      ListView.builder(
                          itemCount: obj['list'].length,
                          itemExtent: 80,
                          shrinkWrap: true,
                          //解决无限高度问题
                          physics: new NeverScrollableScrollPhysics(),
                          //禁用滑动事件
                          itemBuilder: (context, j) {
                            var data = obj['list'][j];
                            return Container(
                              width: 100,
                              decoration: BoxDecoration(
                                // color: data['isCurrent'] ? Colors.black12 : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                // tileColor: data['isCurrent'] ? Colors.black12 : Colors.white,
                                leading: Image.network(data['data']['avatar'],
                                    // width: 150, height: 150, fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                  return Image.asset('images/favicon.ico');
                                }),
                                title: Text(data['data']['nickname'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(data['userName']),
                                trailing: Checkbox(
                                  value: data['isCurrent'],
                                  onChanged: (bool? value) {
                                    login(data);
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    this._isSelected = !this._isSelected;
                                  });
                                },
                              ),
                            );
                          })
                    ],
                  ),
                );
              })),
    );
  }

  void getUserList() async {
    List<Map<String, dynamic>> result = [];
    String currentUserName = await SpUtils.getString('currentUserName');
    String currentBaseUrl = await SpUtils.getString('CurrentBaseUrl');
    List<String> localList = await SpUtils.getStringList('accounts');
    // 根据站点组合
    localList.forEach((data) {
      Map<String, dynamic> jsonData = json.decode(data);
      jsonData['isCurrent'] = false;
      print('\njson: ${jsonData}');
      Map<String, dynamic> bbb = {
        "siteUrl": jsonData['siteUrl'],
        "siteName": jsonData['siteName'],
      };
      List<Map<String, dynamic>> child = [];
      // 站点相同
      var hasSite =
          result.any((value) => value['siteUrl'] == jsonData['siteUrl']);
      if (hasSite) {
        child = result.firstWhere(
            (value) => value['siteUrl'] == jsonData['siteUrl'])['list'];
      }
      // 当前账号

      if (jsonData['siteUrl'] == currentBaseUrl &&
          jsonData['userName'] == currentUserName) {
        jsonData['isCurrent'] = true;
      }
      child.add(jsonData);
      bbb['list'] = child;
      result.add(bbb);
    });
    setState(() {
      userList = result;
    });
  }

  void login(data) {}
}
