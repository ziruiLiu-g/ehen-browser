import 'package:ehentai_browser/navigator/ehen_navigator.dart';
import 'package:ehentai_browser/page/gallery_page.dart';
import 'package:ehentai_browser/router/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../common/const.dart';
import '../../../controller/theme_controller.dart';
import '../../../model/gallery_model.dart';
import '../../../widget/cata_widget.dart';

class GalleryCard extends StatefulWidget {
  GalleryModel g;

  @override
  State<GalleryCard> createState() => _GalleryCardState();

  GalleryCard(this.g);

}

class _GalleryCardState extends State<GalleryCard> {

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        InkWell(
          splashFactory: InkRipple.splashFactory,
          highlightColor: themeColor(ThemeController.isLightTheme),
          splashColor: themeColor(ThemeController.isLightTheme),
          onTap: () => Get.toNamed(Routes.Gallery, arguments: {'gallery': widget.g}),
          child: Container(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.g.imgUrl!,
                  height: 130,
                  width: 110,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  height: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: 100,
                          child: Obx(() => Text(
                              '${widget.g.title}  (${widget.g.image_count}P)',
                              maxLines: 3,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: galleryTitleColor(ThemeController.isLightTheme),
                                decoration: TextDecoration.none,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      getCataWidget(widget.g.cata!.split(':')[0].trim(), wid: 75, hei: 26),
                      Text(
                        'Rating: ${widget.g.rating}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xffff9db5),
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        // width: 250,
                        child: Text(
                          'Artist: ${widget.g.tags['artist']?.join(',')}',
                          // maxLines: 3,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xffff9db5),
                              decoration: TextDecoration.none),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Post Date: ${widget.g.post}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xffff9db5),
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
