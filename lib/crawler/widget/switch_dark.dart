import 'package:ehentai_browser/crawler/common/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

import '../controller/theme_controller.dart';
import '../localdb/local_storage.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await LocalStorage.savebool(
            THEME_IS_LIGHT_KEY, Get.isDarkMode ? true : false);
        Get.changeThemeMode(
          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
        );
        ThemeController.setIsLightTheme(Get.isDarkMode);
      },
      icon: Obx(
        () => Icon(
            ThemeController.isLightTheme ? Icons.sunny : Icons.nights_stay),
      ),
      color: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
