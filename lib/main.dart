import 'package:ehentai_browser/page/ehen/book_open_page_v2.dart';
import 'package:ehentai_browser/page/ehen/home/home.dart';
import 'package:ehentai_browser/page/jabl/jhome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'common/const.dart';
import 'common/global.dart';
import 'localdb/local_storage.dart';
import 'router/router.dart';
import 'util/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then(
    (e) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
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
      home: BookOpenPageV2(
        child: [HomePage(), JHomePage()],
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
