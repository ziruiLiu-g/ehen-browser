import 'dart:ui';

import 'package:ehentai_browser/crawler/widget/search_bar.dart';
import 'package:flutter/material.dart';

import 'checkEhenCata.dart';

MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

ehenAppBar(Function(String) searchCallBack) {
  return AppBar(
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        color: Colors.white,
        alignment: Alignment.center,
        height: 75,
        // width: mediaQuery.size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EhenSearchBar(
                  onSubmitted: searchCallBack,
                  hint: "Use single space to search multiple.",
                ),
              ],
            ),
          ],
        ),
      ),
  );
}