import 'package:ehentai_browser/model/video_gallery_model.dart';
import 'package:ehentai_browser/widget/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/theme_controller.dart';
import '../../util/color.dart';
import '../../widget/dark_mode_switcher.dart';
import '../../widget/video_widget.dart';
import '../../xhenhttp/jabl/dao/jabl_dao.dart';

class VideoDetailPage extends StatefulWidget {
  VideoGalleryModel vmo;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();

  VideoDetailPage(this.vmo);
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        title: Text(
          overflow: TextOverflow.clip,
          widget.vmo.title!,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: <Widget>[DarkModeSwitch()],
      ),
      body: FutureBuilder(
        future: _fetch_video_detail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                _body_without_video(),
                // ListView(children: [Container(height: 400, color: Colors.red,margin: EdgeInsets.only(top: 260),)],),
                Container(
                  // color: Colors.black,
                  height: 240,
                  child: VideoPlayWidget(widget.vmo.m3u8!),
                ),
              ],
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: LoadingAnimation(),
            );
          }
        },
      ),
    );
  }

  _body_without_video() {
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20),
      children: [
        Container(
          margin: EdgeInsets.only(top: 240),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Obx(
            () => Text(
              widget.vmo.title!,
              textAlign: TextAlign.left,
              maxLines: 3,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: galleryPageButtonColor(ThemeController.isLightTheme),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: _build_stars_list(),
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 6,
              children: _build_cata_list(),
            )),
      ],
    );
  }

  _video_wiget() {
    return Container(
      color: Colors.black,
      height: 240,
      child: VideoPlayWidget(widget.vmo.m3u8!),
    );
  }

  _build_stars_list() {
    List<Widget> stars = [];

    for (var s in widget.vmo.stars) {
      stars.add(
        Container(
          height: 50,
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: s.avatarUrl != ''
                      ? Image.network(
                          s.avatarUrl!,
                          height: 32,
                          width: 32,
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: 32,
                          width: 32,
                          color: Colors.blueAccent,
                          child: Text(
                            s.name![0],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                ),
                Text(
                  s.name!,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return stars;
  }

  _build_cata_list() {
    List<Widget> catas = [];

    for (var s in widget.vmo.catas) {
      catas.add(
        InkWell(
          onTap: () {},
          child: Wrap(
            children: [
              if (s.level == 'cat')
                const Icon(
                  Icons.category_outlined,
                  size: 14,
                  color: Colors.redAccent,
                )
              else
                const Icon(
                  Icons.tag,
                  size: 14,
                  color: Colors.lightBlueAccent,
                ),
              Text(
                textAlign: TextAlign.center,
                s.name!,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return catas;
  }

  _fetch_video_detail() async {
    await JableDao.get_video_details(widget.vmo.videoPageLink!, widget.vmo);
  }
}
