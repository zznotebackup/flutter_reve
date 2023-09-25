import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/InfoApi.dart';
import 'package:file_preview/file_preview.dart';
import 'package:flutter_application_2/config/SlideUpPageRoute.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../enums/FileType.dart';
import '../../util/SpUtils.dart';
import '../login/users.dart';

/// 主页
class Index extends StatefulWidget {
  Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with AutomaticKeepAliveClientMixin {
  //文件控制器
  FilePreviewController controller = FilePreviewController();

  late List currentList = [];
  var title = "存储";

  // 控件被创建的时候，会执行 initState
  @override
  void initState() {
    super.initState();
    getRootFileList();
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.switch_account_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(context, SlideUpPageRoute(Users())),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
            },
          ),
          PullDownButton(
            itemBuilder: (context) => [
              const PullDownMenuTitle(
                  title: Center(
                child: Text('视图'),
              )),
              PullDownMenuActionsRow.medium(
                items: [
                  PullDownMenuItem(
                    onTap: () {},
                    title: '列表',
                    icon: CupertinoIcons.list_bullet,
                  ),
                  PullDownMenuItem(
                    onTap: () {},
                    title: '网格',
                    icon: CupertinoIcons.grid,
                  ),
                  // PullDownMenuItem(
                  //   onTap: () {},
                  //   title: '中等',
                  //   icon: Icons.rectangle_outlined,
                  // ),
                ],
              ),
              PullDownMenuDivider.large(),
              PullDownMenuItem(
                title: '选择',
                icon: Icons.check_circle_outline,
                onTap: () {},
              ),
              PullDownMenuItem(
                title: '上传文件',
                icon: Icons.file_upload_outlined,
                onTap: () {},
              ),
              PullDownMenuItem(
                title: '新建文件夹',
                icon: Icons.create_new_folder_outlined,
                onTap: () {},
              ),
              PullDownMenuItem(
                title: '新建文件',
                icon: Icons.add,
                onTap: () {},
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.settings),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
            itemCount: currentList.length,
            itemExtent: 65,
            itemBuilder: (context, index) {
              var obj = currentList[index];
              return GestureDetector(
                onLongPressStart: (details) {
                  showMenu(
                    context: context,
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                    ),
                    items: [
                      const PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.download),
                            Text('下载', style: TextStyle(fontSize: 15))
                          ],
                        ),
                        value: 'download',
                      ),
                      const PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            Text('删除',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.red))
                          ],
                        ),
                        value: 'delete',
                      ),
                      const PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.share_location, color: Colors.blue),
                            Text('分享',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.blue))
                          ],
                        ),
                        value: 'delete',
                      ),
                    ],
                    elevation: 8.0,
                  ).then((value) {
                    if (value == 'edit') {
                      // 执行编辑操作
                    } else if (value == 'delete') {
                      // 执行删除操作
                    }
                  });
                },
                child: ListTile(
                  leading: IconTheme(
                    data: IconThemeData(size: 35),
                    child: Icon(
                      FileType.getIconByTypeAndName(obj['type'], obj['name']),
                      color: FileType.getColorByValue(obj['type'], obj['name']),
                    ),
                  ),
                  title: Row(
                    children: [
                      SizedBox(
                        width: pageWidth * 0.7,
                        child:
                            Text(obj['name'], overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "修改于: ",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  onTap: () {
                    inDir(obj);
                  },
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          //悬浮按钮
          child: Icon(Icons.add),
          shape: CircleBorder(),
          onPressed: () {
            print('======清除所有键');
            SpUtils.clearAll();
          }),
    );
  }

  void getRootFileList() async {
    var result = await InfoApi.getRootFileList();
    var objects = result['data']['objects'];
    setState(() {
      currentList = objects;
    });
  }

  void inDir(obj) async {
    if (obj['type'] == FileType.DIR.value) {
      var currentMenu = obj['path'] + "/" + obj['name'];
      await SpUtils.setString('currentMenu', currentMenu);
      var result = await InfoApi.getRootFileList();
      var objects = result['data']['objects'];
      setState(() {
        title = obj['name'];
        currentList = objects;
      });
    }
  }

  Future<void> _refresh() async {
    var result = await InfoApi.getCurrentFileList();
    var objects = result['data']['objects'];
    setState(() {
      currentList = objects;
    });
  }

  /// 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
