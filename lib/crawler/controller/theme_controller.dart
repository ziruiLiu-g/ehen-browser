import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController? _themeController;

  static initTheme() {
    _themeController = Get.put(ThemeController());
    print('initialize themecontroller');
  }

  final RxBool _isLightTheme = (!Get.isDarkMode).obs;

  static bool get isLightTheme => _themeController!._isLightTheme.value;
  static void set isLightTheme(bool x) => _themeController!._isLightTheme.value = x;
}