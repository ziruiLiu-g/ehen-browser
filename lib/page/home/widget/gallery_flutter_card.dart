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
import '../../../widget/full_screen_photo.dart';

class GalleryFlutterCard extends StatefulWidget {
  GalleryModel g;

  @override
  State<GalleryFlutterCard> createState() => _GalleryFlutterCardState();

  GalleryFlutterCard(this.g);
}

class _GalleryFlutterCardState extends State<GalleryFlutterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: MediaQuery.of(context).size.height / 7, // 可以选择适配，之后看看效果
        // height: 130,
        // margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => TapablePhoto(widget.g.imgUrl!),
              ),
              child: Image.network(
                widget.g.imgUrl!,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 1 / 4,
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.Gallery, arguments: {'gallery': widget.g}),
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                width: MediaQuery.of(context).size.width * 3 / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // width: 100,
                        child: Obx(
                              () => Text(
                            '${widget.g.title}  (${widget.g.image_count}P)',
                            maxLines: 3,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: galleryTitleColor(ThemeController.isLightTheme),
                              decoration: TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    getCataWidget(widget.g.cata!.split(':')[0].trim(), wid: 75, hei: 26),
                    Text(
                      'Rating: ${widget.g.rating}',
                      style: const TextStyle(fontSize: 10, color: Color(0xffff9db5), decoration: TextDecoration.none),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      // width: 250,
                      child: Text(
                        'Artist: ${widget.g.tags['artist']?.join(',')}',
                        // maxLines: 3,
                        style: const TextStyle(fontSize: 10, color: Color(0xffff9db5), decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Post Date: ${widget.g.post}',
                      style: const TextStyle(fontSize: 10, color: Color(0xffff9db5), decoration: TextDecoration.none),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
