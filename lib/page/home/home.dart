import 'dart:convert';

import 'package:ehentai_browser/page/gallery_page.dart';
import 'package:ehentai_browser/page/startPage.dart';
import 'package:ehentai_browser/util/color.dart';
import 'package:ehentai_browser/widget/app_bar_ehen.dart';
import 'package:ehentai_browser/widget/cata_widget.dart';
import 'package:ehentai_browser/page/home/widget/multi_cata_check.dart';
import 'package:ehentai_browser/widget/loading_animation.dart';
import 'package:ehentai_browser/xhenhttp/dao/xhen_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/const.dart';
import '../../controller/theme_controller.dart';
import '../../localdb/local_storage.dart';
import '../../navigator/ehen_navigator.dart';
import '../../util/ehentai_crawler.dart';
import '../../model/gallery_model.dart';
import 'widget/gallery_card.dart';

class HomePage extends StatefulWidget {
  String? sear = '';

  @override
  State<HomePage> createState() => _HomePageState();

  HomePage({this.sear});
}

class _HomePageState extends State<HomePage> {
  var scrollController = ScrollController();
  late List<GalleryModel> glist = [];

  var prev;
  var next;
  var search;
  var cata;
  var beforeDate;
  var listener;

  var isInit = true;

  @override
  void initState() {
    super.initState();

    search = widget.sear;
    EhenNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('home:current: ${current.page}');
      print('home:prev: ${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('Open the Home Page, onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('Home page, onPause');
      }
    });
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
              setState(() {});
            }, () async {
              next = '';
              setState(() {});
            }, (text) {
              search = text;
            }, searBarText: search),
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
          Widget child;
          if (snapshot.connectionState == ConnectionState.waiting) {
            child = Container(
              alignment: Alignment.center,
              child: LoadingAnimation(),
            );
          } else {
            child = _buildMainContent();
          }

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: child,
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
  _searchGallerys(bool isPrev, {List<GalleryModel>? list}) async {
    var htmlDoc = await loadGallerysHtml(isPrev, search: search, cata: cata, prev: prev, next: next, dateBefore: beforeDate);

    glist = await getGalleryList(htmlDoc, list: list);
    next = getGalleryNextPage(htmlDoc);
    prev = getGalleryPrevPage(htmlDoc);
    beforeDate = null;
    isInit = false;
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
    await showDialog(
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
      },
    );
  }

  // 日期选择器回调函数， 负责弹窗
  _date_selector_callback(date, context) async {
    setState(() {
      beforeDate = date;
    });
    Navigator.pop(context);
  }

  // 获取卡片列表
  get_gallery_rows_list() {
    Widget content;
    List<Widget> ww = [];
    for (var g in glist) {
      ww.add(GalleryCard(g));
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
}
