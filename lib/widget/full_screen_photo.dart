import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TapablePhoto extends StatelessWidget {
  TapablePhoto(this.picUrl);

  String picUrl;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      title: Container(
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Image.network(
              this.picUrl,
              // width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 2 / 3,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
