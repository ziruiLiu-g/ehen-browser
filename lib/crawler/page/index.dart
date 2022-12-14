import 'dart:convert';

import 'package:ehentai_browser/crawler/page/gallery_page.dart';
import 'package:ehentai_browser/crawler/page/startPage.dart';
import 'package:ehentai_browser/crawler/util/color.dart';
import 'package:ehentai_browser/crawler/widget/app_bar_ehen.dart';
import 'package:ehentai_browser/crawler/widget/cata_widget.dart';
import 'package:ehentai_browser/crawler/widget/checkEhenCata.dart';
import 'package:ehentai_browser/crawler/widget/loading_animation.dart';
import 'package:ehentai_browser/crawler/xhenhttp/dao/xhen_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/const.dart';
import '../controller/theme_controller.dart';
import '../localdb/local_storage.dart';
import '../util/ehentai_crawler.dart';
import '../model/gallery_object.dart';
import '../widget/gallery_card.dart';

class Xhen extends StatefulWidget {
  const Xhen({Key? key}) : super(key: key);

  @override
  State<Xhen> createState() => _XhenState();
}

class _XhenState extends State<Xhen> {
  var scrollController = ScrollController();
  late List<Gallery> glist = [];

  var prev;
  var next;
  var search;
  var cata;
  var beforeDate;

  var isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(104.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ehenAppBar((text) async {
              next = '';
              // await _searchGallerys(false);
              setState(() {});
            }, () async {
              next = '';
              // await _searchGallerys(false);
              setState(() {});
            }, (text) {
              search = text;
            }),
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 4),
              alignment: Alignment.center,
              child: EhenCheck((cataNum) {
                cata = '$cataNum';
              }),
            ),
          ],
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: _searchGallerys(false),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return _buildMainContent();
          }
          return Container(
            alignment: Alignment.center,
            child: LoadingAnimation(),
          );
        },
      ),
      bottomNavigationBar: _nextPrevButton(),
    );
  }

  _buildMainContent() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: get_gallery_rows_list(),
    );
  }

  // 后端加载
  _searchGallerys(bool isPrev,
      {List<Gallery>? list}) async {
    var htmlDoc = await loadGallerysHtml(isPrev,
        search: search,
        cata: cata,
        prev: prev,
        next: next,
        dateBefore: beforeDate);

    glist = await getGalleryList(htmlDoc, list: list);
    next = getGalleryNextPage(htmlDoc);
    prev = getGalleryPrevPage(htmlDoc);
    beforeDate = null;
    isInit = false;

    // scrollController.animateTo(
    //   0,
    //   duration: Duration(milliseconds: 600),
    //   curve: Curves.fastOutSlowIn,
    // );

    return 1;
  }

  // 下一页和上一页
  _nextPrevButton() {
    return Container(
      height: 70,
      // color: Colors.red,
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextButton(
            child: Obx(
              () => Text(
                "<< PREV",
                style: TextStyle(
                  fontSize: 20,
                  color: galleryPageButtonColor(ThemeController.isLightTheme),
                ),
              ),
            ),
            onPressed: () async {
              // await _searchGallerys(true);
              setState(() {});
            },
          ),
          TextButton(
            onPressed: _simpleDialog,
            child: Obx(
              () => Text(
                "JUMP",
                style: TextStyle(
                  fontSize: 20,
                  color: galleryPageButtonColor(ThemeController.isLightTheme),
                ),
              ),
            ),
          ),
          TextButton(
            child: Obx(
              () => Text(
                "NEXT >>",
                style: TextStyle(
                  fontSize: 20,
                  color: galleryPageButtonColor(ThemeController.isLightTheme),
                ),
              ),
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // 日期选择器列表
  _simpleDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Uploaded Before: '),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('1 day ago'),
                onPressed: () {
                  _date_selector_callback("1d", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('3 day ago'),
                onPressed: () {
                  _date_selector_callback("3d", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('1 week ago'),
                onPressed: () {
                  _date_selector_callback("1w", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('2 week ago'),
                onPressed: () {
                  _date_selector_callback("2w", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('1 month ago'),
                onPressed: () {
                  _date_selector_callback("1m", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('6 month ago'),
                onPressed: () {
                  _date_selector_callback("6m", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('1 year ago'),
                onPressed: () {
                  _date_selector_callback("1y", context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('2 year ago'),
                onPressed: () {
                  _date_selector_callback("2y", context);
                },
              ),
            ],
          );
        });
  }

  // 日期选择器回调函数， 负责弹窗
  _date_selector_callback(date, context) async {
    setState(() {beforeDate = date;});
    Navigator.pop(context);
  }

  // 获取卡片列表
  get_gallery_rows_list() {
    Widget content;
    List<Widget> ww = [];
    for (var g in glist) {
      ww.add(GalleryCard(g, get_gallery_row));
      ww.add(const Divider(
        height: 1,
        color: Colors.grey,
      ));
    }
    content = Column(
      children: ww,
    );
    return content;
  }

  //  获取单独的gallery卡片
  get_gallery_row(Gallery g) {
    return Container(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            g.imgUrl!,
            height: 130,
            width: 110,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 25),
          SizedBox(
            // color: Colors.yellow,
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 250,
                    child: Obx(
                      () => Text(
                        '${g.title}  (${g.image_count}P)',
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
                getCataWidget(g.cata!.split(':')[0].trim(), wid: 75, hei: 26),
                Text(
                  'Rating: ${g.rating}',
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xffff9db5),
                      decoration: TextDecoration.none),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  width: 250,
                  child: Text(
                    'Artist: ${g.tags['artist']?.join(',')}',
                    // maxLines: 3,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xffff9db5),
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Post Date: ${g.post}',
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
    );
  }
}
