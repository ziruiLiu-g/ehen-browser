import 'package:ehentai_browser/crawler/controller/theme_controller.dart';
import 'package:ehentai_browser/crawler/localdb/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Global {
  // 是否为release版
  // static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    ThemeController.initTheme();
    LocalStorage.initSP();

  }
}