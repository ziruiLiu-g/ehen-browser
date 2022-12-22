import 'package:ehentai_browser/page/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../common/const.dart';
import '../common/global.dart';
import '../localdb/local_storage.dart';
import '../page/startPage.dart';
import '../router/router.dart';
import '../util/color.dart';
import 'custom_drawer_guitar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
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
      home: CustomGuitarDrawer(
        child: FutureBuilder<dynamic>(
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
              return child;
            }),
      ),
    );
  }

  Future<dynamic> loadingPageTimer() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

class MyHomePage extends StatefulWidget {
  final AppBar appBar;

  MyHomePage({Key? key, required this.appBar}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
