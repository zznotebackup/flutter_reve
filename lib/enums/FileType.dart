import 'package:flutter/material.dart';

enum FileType {
  DIR('dir', Icons.folder_copy, Color.fromARGB(255, 15, 101, 239)),
  FILE('file', Icons.file_copy, Colors.deepOrange),
  PNG('png', Icons.photo, Colors.orange),
  JPG('jpg', Icons.image, Colors.orange),
  HTML('html', Icons.html, Colors.deepOrange),
  JS('js', Icons.javascript_sharp, Colors.deepOrange),
  MD('css', Icons.css, Colors.deepOrange),
  PDF('css', Icons.picture_as_pdf, Colors.red),
  UNKNOW('UNKNOW', Icons.question_mark, Colors.black12),
  ;

  /// 枚举键
  final String value;

  /// 枚举值（数据库保存）
  final IconData icon;

  final Color color;

  const FileType(this.value, this.icon, this.color);

  static IconData getIconByTypeAndName(String type, String name) {
    if (type == "dir") {
      return DIR.icon;
    } else {
      String suffix = name.split('.').last;
      bool hasEnum =
          FileType.values.any((activity) => activity.value == suffix);
      if (hasEnum) {
        return FileType.values
            .firstWhere((activity) => activity.value == suffix)
            .icon;
      }
      return UNKNOW.icon;
    }
  }

  static Color getColorByValue(String type, String name) {
    if (type == "dir") {
      return DIR.color;
    } else {
      String suffix = name.split('.').last;
      bool hasEnum =
          FileType.values.any((activity) => activity.value == suffix);
      if (hasEnum) {
        return FileType.values
            .firstWhere((activity) => activity.value == suffix)
            .color;
      }
      return UNKNOW.color;
    }
  }
}
