import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ehentai_browser/crawler/model/gallery_object.dart';
import 'package:ehentai_browser/crawler/util/ehentai_crawler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
        width: 400,
        padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: get_gallery_body(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => InkWell(
          onTap: () {},
          child: Container(
            height: 60,
            color: ThemeController.isLightTheme ? primary : darkPrimary,
            alignment: Alignment.center,
            child: const Text(
              "Read",
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
              child = const LoadingAnimation(key: ValueKey(1),);
            } else {
              child = snapshot.data!;
            }

            return AnimatedSwitcher(
              duration: Duration(seconds: 1),
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
            color: ThemeController.isLightTheme ? Colors.black : Colors.white60,
          ),
        ),
      ),
      const SizedBox(height: 20),
      get_gallery_details(),
      const SizedBox(height: 20),
      Column(
        children: get_tags_details(),
      ),
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
          get_detail_row('Posted Date', '${widget.g.post}'),
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
        tagButton.add(InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Color(hexOfRGBA(226, 225, 210)),
              border: Border.all(width: 2.0, color: Colors.grey),
            ),
            height: 20,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tb,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  decoration: TextDecoration.none),
            ),
          ),
        ));
      }

      var r = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Obx(
              () => Text(
                '${t}: ',
                style: TextStyle(
                  fontSize: 15,
                  color: ThemeController.isLightTheme
                      ? Colors.black
                      : Colors.white60,
                ),
              ),
            ),
          ),
          Container(
            width: 290,
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: 6,
              children: tagButton,
            ),
          ),
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
              color: ThemeController.isLightTheme ? Colors.black : Colors.white,
            ),
          ),
        ),
        Text(
          '$field',
          style: TextStyle(
            fontSize: 15,
            color: ThemeController.isLightTheme ? Colors.black : Colors.white,
          ),
        )
      ],
    );
  }

  // get_page() async {
  //   var result = await XhenDao.get_gallery([
  //     [2401088, "5adc79095a"]
  //   ]);
  //   var g1 = jsonDecode(result)['gmetadata'][0];
  //   g = Gallery(
  //       url: g1['thumb'],
  //       title: g1['title'],
  //       image_count: g1['filecount'],
  //       cata: g1['category'],
  //       tags: g1['tags'],
  //       rating: g1['rating'],
  //       post: g1['posted']);
  //
  //   print(g1['tags']);
  //   print('${g.tags}');
  //   await get_first_img();
  // }

  Future<Image> get_first_img(String gid, String gtoken) async {
    var html = await requestGalleryData(gid, gtoken);
    String hdPic = get_Gallery_Show_Img(html);
    var cache = await downloadImageBytes(hdPic);

    return Image.memory(
      cache!,
      key: ValueKey(1),
      fit: BoxFit.contain,
    );
  }
}
