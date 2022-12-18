import 'package:ehentai_browser/controller/theme_controller.dart';
import 'package:ehentai_browser/localdb/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:logger/logger.dart';

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
  static init() async {
    await LocalStorage.preInit();
    _logger.i('Global init SharedPreferences.');

    if (LocalStorage.getInstance().get(THEME_IS_LIGHT_KEY) == null) {
      LocalStorage.getInstance().setBool(THEME_IS_LIGHT_KEY, true);
    }

    // init global controller
    Get.put(ThemeController());

    _logger.i(
        'App start with theme: ${(LocalStorage.getInstance().get(THEME_IS_LIGHT_KEY) as bool) ? ThemeMode.light : ThemeMode.dark}');
  }
}
