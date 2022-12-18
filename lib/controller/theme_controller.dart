import 'package:ehentai_browser/localdb/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/const.dart';

class ThemeController extends GetxController {
  static ThemeController? _themeController;


  @override
  void onInit() {
    super.onInit();
    _themeController = ThemeController();
  }

  final RxBool _isLightTheme = (LocalStorage.getInstance().get(THEME_IS_LIGHT_KEY) as bool).obs;

  static bool get isLightTheme => _themeController!._isLightTheme.value;
  static void set isLightTheme(bool x) => _themeController!._isLightTheme.value = x;

  static void setIsLightTheme(bool x) {
    _themeController!._isLightTheme.value = x;
  }
}