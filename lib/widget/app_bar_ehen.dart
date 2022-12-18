import 'dart:ui';
import 'package:ehentai_browser/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'dark_mode_switcher.dart';

MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

ehenAppBar(Function(String) searchCallBack, Function() searchIconCallBack,
    Function(String) inputCallBack, {String? searBarText}) {
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
                defaultSearch: searBarText ?? "",
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
