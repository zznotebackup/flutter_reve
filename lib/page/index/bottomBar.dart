import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/page/index/account.dart';
import 'package:flutter_application_2/page/index/download.dart';
import 'package:flutter_application_2/page/index/index.dart';

import '../../util/SpUtils.dart';

/// 底部栏
class Bottom extends StatefulWidget {
  Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  //页面控制器
  PageController _pageController = PageController();
  var _selectedIndex = 0;
  late List currentList = [];

  // 控件被创建的时候，会执行 initState
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: [Index(), Download(), Account()],
        ),
        // body: IndexedStack(
        //     index: 0,
        //     children: [PageView(
        //       controller: _pageController,
        //       children: [Index(), Download(), Account()],
        //     )]),
        bottomNavigationBar: SizedBox(
            height: 95,
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              backgroundColor: Colors.white70,
              elevation: 1,
              iconSize: 25,

              // 底部导航
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.cloud_outlined,
                      size: 27,
                    ),
                    label: "存储"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.download_for_offline_outlined, size: 27),
                    label: "下载"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined, size: 27),
                    label: "用户"),
              ],
              fixedColor: Color.fromARGB(255, 15, 101, 239),
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
            )));
  }

  /// 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
