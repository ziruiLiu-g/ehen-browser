import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ehentai_browser/crawler/model/gallery_object.dart';
import 'package:ehentai_browser/crawler/page/index.dart';
import 'package:ehentai_browser/crawler/page/pics_page.dart';
import 'package:ehentai_browser/crawler/util/ehentai_crawler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:logger/logger.dart';

import '../common/const.dart';
import '../controller/theme_controller.dart';
import '../util/color.dart';
import '../util/image_save_load.dart';
import '../widget/cata_widget.dart';
import '../widget/loading_animation.dart';
import '../widget/switch_dark.dart';

class GalleryPage extends StatefulWidget {
  Gallery g;

  @override
  State<GalleryPage> createState() => _GalleryPageState();

  GalleryPage(this.g);
}

class _GalleryPageState extends State<GalleryPage> {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  var scrollController = ScrollController();

  late Gallery g;

  var cover;

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
          onPressed: () {
            Get.back();
          },
        ),
        title: Container(
          child: Text(
            overflow: TextOverflow.clip,
            widget.g.title!,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        actions: <Widget>[DarkModeSwitch()],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ListView(
          children: get_gallery_body(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => InkWell(
          onTap: () {
            Get.to(PicsPage(widget.g, 0));
          },
          child: Container(
            height: 60,
            color: themeColor(ThemeController.isLightTheme),
            alignment: Alignment.center,
            child: const Text(
              "READ",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  get_gallery_body() {
    return <Widget>[
      Container(
        height: 400,
        alignment: Alignment.center,
        child: FutureBuilder<Image>(
          future: get_first_img(widget.g.gid, widget.g.gtoken),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              child = const LoadingAnimation(
                key: ValueKey(1),
              );
            } else {
              child = snapshot.data!;
            }

            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: child,
            );
          },
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Obx(
        () => Text(
          widget.g.title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: galleryPageButtonColor(ThemeController.isLightTheme),
          ),
        ),
      ),
      const SizedBox(height:30),
      get_gallery_details(),
      const SizedBox(height: 20),
      Container(
        // color: Colors.red,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: get_tags_details(),
        ),
      )
    ];
  }

  get_gallery_details() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCataWidget(widget.g.cata!.split(':')[0].trim(), wid: 100, hei: 35),
          const SizedBox(
            height: 10,
          ),
          get_detail_row('Pages', '${widget.g.image_count}'),
          const SizedBox(
            height: 8,
          ),
          get_detail_row('Rating', '${widget.g.rating}'),
          const SizedBox(
            height: 8,
          ),
          get_detail_row('Artist', '${widget.g.tags['artist']?.join(',')}'),
          const SizedBox(
            height: 8,
          ),
          get_detail_row('Posted on', '${widget.g.post}'),
          const SizedBox(
            height: 10,
          ),
          const Divider(height: 0, thickness: 2),
        ],
      ),
    );
  }

  get_tags_details() {
    List<Widget> wl = [];
    for (var t in widget.g.tags.keys) {
      if (t == 'artist') continue;
      var tlist = widget.g.tags[t];

      List<Widget> tagButton = [];
      for (var tb in tlist!) {
        tagButton.add(
          Ink(
            color: Color(hexOfRGBA(226, 225, 210)),
            child: InkWell(
              // splashFactory: InkRipple.splashFactory,
              splashColor: Colors.grey,
              onTap: () {
                Get.to(Xhen(
                  sear: tb,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(width: 2.0, color: Colors.grey),
                ),
                height: 25,
                padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                child: Text(
                  tb,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          )
        );
      }

      var r = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: 100,
            child: Obx(
              () => Text(
                '${t}: ',
                style: TextStyle(
                  fontSize: 15,
                  color: galleryTitleColor(ThemeController.isLightTheme),
                ),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
            spacing: 10,
            runSpacing: 6,
            children: tagButton,
          ),)
        ],
      );

      wl.add(r);
      wl.add(SizedBox(height: 15));
    }
    return wl;
  }

  get_detail_row(String fieldName, String field) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            '$fieldName:',
            style: TextStyle(
              fontSize: 16,
              color: galleryTitleColor(ThemeController.isLightTheme),
            ),
          ),
        ),
        Text(
          '$field',
          style: TextStyle(
            fontSize: 15,
            color: galleryTitleColor(ThemeController.isLightTheme),
          ),
        )
      ],
    );
  }

  Future<Image> get_first_img(String gid, String gtoken) async {
    var html = await requestGalleryData(gid, gtoken);
    String hdPic = get_Gallery_Show_Img(html);
    var cache = await downloadImageBytes(hdPic);

    widget.g.maxPage = get_Max_Page(html);

    return Image.memory(
      cache!,
      key: ValueKey(1),
      fit: BoxFit.contain,
    );
  }
}
