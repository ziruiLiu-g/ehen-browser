import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../common/const.dart';
import '../controller/theme_controller.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => CircularProgressIndicator(
          semanticsValue: "Loading..",
          strokeWidth: 3,
          color: loadingCircleColr(ThemeController.isLightTheme),
        ));
  }
}
