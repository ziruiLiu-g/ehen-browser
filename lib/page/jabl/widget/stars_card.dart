import 'package:ehentai_browser/model/video_gallery_model.dart';
import 'package:ehentai_browser/page/jabl/star_video_page.dart';
import 'package:ehentai_browser/page/jabl/video_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import '../../../controller/theme_controller.dart';
import '../../../util/color.dart';
import '../../../widget/full_screen_photo.dart';

class StarsCard extends StatefulWidget {
  VideoStarModel starMo;

  @override
  State<StarsCard> createState() => _StarsCardState();

  StarsCard(this.starMo);
}

class _StarsCardState extends State<StarsCard> {
  late final VideoStarModel starMo;

  @override
  void initState() {
    super.initState();
    starMo = widget.starMo;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(StarVideoPage(starpageLink: starMo.webpage!, starName: starMo.name!,));
      },
      child: SizedBox(
        height: 210,
        child: Card(
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_itemImage(context), _infoText()],
              // children: [_itemImage(context)],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (starMo.avatarUrl! != '')
          FadeInImage.memoryNetwork(
            height: 160,
            width: size.width / 2,
            placeholder: kTransparentImage,
            image: starMo.avatarUrl!,
            fit: BoxFit.cover,
          )
        else
          Container(
            height: 160,
            alignment: Alignment.center,
            child: const Icon(
              Icons.person_outline_rounded,
              size: 140,
              color: Color(0xFFE0C9B0),
            ),
          ),
      ],
    );
  }

  _iconText(IconData? iconData, String count) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconData != null)
            Icon(iconData,
                color: galleryTitleColor(ThemeController.isLightTheme),
                size: 12),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              count,
              style: TextStyle(
                color: galleryTitleColor(ThemeController.isLightTheme),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _infoText() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => Text(
                starMo.name!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: galleryTitleColor(ThemeController.isLightTheme),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _iconText(Icons.video_library, starMo.videoNum!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
