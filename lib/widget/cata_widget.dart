import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/color.dart';

Widget getCataWidget(String title, {double? wid, double? hei}) {
  return Container(
    width: wid ?? 75,
    height: hei ?? 25,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: cataMap[title]!['activeColor'] as Color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 2.0, color: Colors.grey)),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
    ),
  );
}
