import 'package:ehentai_browser/router/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controller/theme_controller.dart';
import '../../../model/gallery_model.dart';
import '../../../util/color.dart';
import '../../../widget/cata_widget.dart';
import '../../../widget/full_screen_photo.dart';

class GalleryCard extends StatefulWidget {
  GalleryModel g;

  @override
  State<GalleryCard> createState() => _GalleryCardState();

  GalleryCard(this.g);
}

class _GalleryCardState extends State<GalleryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height / 6, // 可以选择适配，之后看看效果
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => TapablePhoto(widget.g.imgUrl!),
            ),
            child: Image.network(
              widget.g.imgUrl!,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 4,
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.Gallery, arguments: {'gallery': widget.g});
              HapticFeedback.mediumImpact();
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 3 / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      // width: 100,
                      child: Obx(
                    () => Text(
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
                  getCataWidget(widget.g.cata!.split(':')[0].trim(),
                      wid: 75, hei: 26),
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
          )
        ],
      ),
    );
  }
}
