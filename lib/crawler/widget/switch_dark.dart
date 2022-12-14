import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/theme_controller.dart';
import '../localdb/local_storage.dart';


class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Switch(
        activeColor: Colors.white,
        value: ThemeController.isLightTheme,
        onChanged: (val) {
          print('${val}');
          ThemeController.isLightTheme = val;
          Get.changeThemeMode(
            ThemeController.isLightTheme ? ThemeMode.light : ThemeMode.dark,
          );
        },
      ),
    );
  }
}
