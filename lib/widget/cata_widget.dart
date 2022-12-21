import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/color.dart';

Widget getCataWidget(String title, {double? wid, double? hei, double? fontsize}) {
  return Container(
    // width: wid ?? 75,
    // height: hei ?? 25,
    // alignment: Alignment.center,
    padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
    decoration: BoxDecoration(
        color: cataMap[title]!['activeColor'] as Color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 2.0, color: Colors.grey)),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontsize ?? 10,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
    ),
  );
}
