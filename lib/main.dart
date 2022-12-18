import 'package:ehentai_browser/localdb/local_storage.dart';
import 'package:ehentai_browser/page/startPage.dart';
import 'package:ehentai_browser/router/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'common/const.dart';
import 'common/global.dart';
import 'page/home/home.dart';
import 'util/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
      themeMode: (LocalStorage.getInstance().get(THEME_IS_LIGHT_KEY) as bool) ? ThemeMode.light : ThemeMode.dark,
      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
      getPages: EhenRouters.pages,
      home: FutureBuilder<dynamic>(
          future: loadingPageTimer(),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              child = const StartPage(
                key: ValueKey(1),
              );
            } else {
              child = HomePage();
            }
            return AnimatedSwitcher(
              duration: Duration(seconds: 3),
              child: child,
            );
          }),
    );
  }

  Future<dynamic> loadingPageTimer() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
