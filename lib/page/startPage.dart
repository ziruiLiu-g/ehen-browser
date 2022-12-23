import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../util/color.dart';
import 'book_open_page.dart';
import 'home/home.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      curve: Curves.easeInCirc,
      animationDuration: Duration(milliseconds: 1500),
      backgroundColor: themeColor(!Get.isDarkMode),
      splash: Text(
        "EhBrowser",
        style: TextStyle(
          // color: galleryPageButtonColor(!Get.isDarkMode),
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width / (3 * 4),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      ),
      nextScreen: BookOpenPage(
        child: HomePage(),
      ),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
