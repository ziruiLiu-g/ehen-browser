import 'package:ehentai_browser/crawler/localdb/local_storage.dart';
import 'package:ehentai_browser/crawler/model/gallery_object.dart';
import 'package:ehentai_browser/crawler/page/startPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'crawler/common/global.dart';
import 'crawler/controller/theme_controller.dart';
import 'crawler/page/gallery_page.dart';
import 'crawler/page/index.dart';
import 'crawler/util/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Global.init().then((e) => runApp(const MyApp()));
  Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: darkPrimary,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: primary,
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
      home: FutureBuilder<dynamic>(
          future: loadingPageTimer(),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              child = const StartPage(
                key: ValueKey(1),
              );
            } else {
              child = const Xhen(
                key: ValueKey(0),
              );
            }
            return AnimatedSwitcher(
              duration: Duration(seconds: 3),
              child: child,
            );
          }),
    );
  }

  loadingPageTimer() async {
    await Future.delayed(Duration(milliseconds: 1500), () {
      print("loading page end.");
    });
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
