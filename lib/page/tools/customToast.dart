import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {Key? key}) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 45),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 5.0), //阴影xy轴偏移量
                      blurRadius: 10.0, //阴影模糊程度
                      spreadRadius: 0.5 //阴影扩散程度
                      )
                ]),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              //icon
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(Icons.warning_amber_rounded,
                    color: Colors.deepOrangeAccent),
              ),

              //msg
              Text('$msg',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ]),
          ),
        )
      ],
    );
  }
}
