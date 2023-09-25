import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/InfoApi.dart';
import 'package:file_preview/file_preview.dart';
import 'package:flutter_application_2/config/SlideUpPageRoute.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../enums/FileType.dart';
import '../../util/SpUtils.dart';
import '../login/users.dart';

/// 下载页
class Download extends StatefulWidget {
  Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download>
    with SingleTickerProviderStateMixin {
  //文件控制器
  late TabController _tabController;
  late List currentList = [];
  late List downloading = [];
  late List finished = [];

  @override
  void initState() {
    super.initState();
    // 创建一个TabController对象，用于管理Tab标签
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // 释放TabController对象
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '离线下载'),
            Tab(text: '任务队列'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            children: [
              RefreshIndicator(
                  onRefresh: _refresh,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 10,
                        left: pageWidth * 0.05,
                        right: pageWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 238, 238),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 55,
                    child: Row(
                      children: [
                        Text("无下载中任务",
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  )),
            ],
          ),
          Center(child: Text('暂无任务（后续开发）')),
        ],
      ),
    );
  }

  /// 保持页面状态
  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
  }
}
