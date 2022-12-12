import 'package:ehentai_browser/crawler/page/gallery_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../common/const.dart';
import '../controller/theme_controller.dart';
import '../model/gallery_object.dart';
import '../util/color.dart';

class GalleryCard extends StatefulWidget {
  Gallery g;
  Function(Gallery) f;

  @override
  State<GalleryCard> createState() => _GalleryCardState();

  GalleryCard(this.g, this.f);

}

class _GalleryCardState extends State<GalleryCard> {


  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        InkWell(
          splashFactory: InkRipple.splashFactory,
          highlightColor: themeColor(ThemeController.isLightTheme),
          splashColor: themeColor(ThemeController.isLightTheme),
          onTap: () {
            Gallery g = widget.g;
            Get.to(() => GalleryPage(g));
          },
          child: widget.f(widget.g),
        ));
  }
}
