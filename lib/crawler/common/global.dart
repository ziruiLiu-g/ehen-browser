import 'dart:developer';

import 'package:ehentai_browser/crawler/controller/theme_controller.dart';
import 'package:ehentai_browser/crawler/localdb/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class Global {
  // 是否为release版
  // static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
    ),
  );

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    await LocalStorage.initSP();
    _logger.i('Global init SharedPreferences.');


    ThemeController.initTheme();

    _logger.i('App start with theme: ${LocalStorage.getbool(THEME_IS_LIGHT_KEY)
        ? ThemeMode.light
        : ThemeMode.dark }');
  }
}