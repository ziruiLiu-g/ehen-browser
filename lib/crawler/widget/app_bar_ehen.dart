import 'dart:ui';

import 'package:ehentai_browser/crawler/controller/theme_controller.dart';
import 'package:ehentai_browser/crawler/util/color.dart';
import 'package:ehentai_browser/crawler/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'switch_dark.dart';

MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

ehenAppBar(Function(String) searchCallBack, Function() searchIconCallBack,
    Function(String) inputCallBack) {
  return AppBar(
    titleSpacing: 0,
    elevation: 0,
    actions: <Widget>[DarkModeSwitch()],
    title: SizedBox(
      height: 75,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EhenSearchBar(
                searchIconCallBack: searchIconCallBack,
                onSubmitted: searchCallBack,
                inputCallBack: inputCallBack,
                hint: "Use single space to search multiple.",
              ),
            ],
          ),
        ],
      ),
    ),
    leading: IconButton(
      color: Colors.white,
      icon: Icon(Icons.more_horiz),
      onPressed: () {},
    ),
  );
}
