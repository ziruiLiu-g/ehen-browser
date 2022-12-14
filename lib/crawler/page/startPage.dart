import 'package:ehentai_browser/crawler/util/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/getwidget.dart';

import '../controller/theme_controller.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  // var themeController = ThemeController.themeController;

  late AnimationController controller = AnimationController(
    vsync: this,
    value: 1.0,
    lowerBound: 0.4,
    upperBound: 1.0,
    duration: const Duration(milliseconds: 300),
  );

  late Animation<double> animation =
  CurvedAnimation(parent: controller, curve: Curves.linear);

  bool isShowLoader = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.reverse();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isShowLoader = true;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery
        .of(context)
        .size
        .width / 3;
    return Container(
      color: ThemeController.isLightTheme ? Colors.white : Colors.black,
      child: Center(
        child: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GFAnimation(
                scaleAnimation: animation,
                controller: controller,
                type: GFAnimationType.scaleTransition,
                alignment: Alignment.center,
                child: Obx(
                      () =>
                      Text(
                        "EhBrowser",
                        style: TextStyle(
                          color: ThemeController.isLightTheme
                              ? primary
                              : Colors.white,
                          fontSize: size / 4,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
