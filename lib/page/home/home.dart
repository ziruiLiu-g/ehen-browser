import 'package:ehentai_browser/page/home/widget/multi_cata_check.dart';
import 'package:ehentai_browser/widget/app_bar_ehen.dart';
import 'package:ehentai_browser/widget/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/const.dart';
import '../../controller/cata_controller.dart';
import '../../controller/theme_controller.dart';
import '../../model/gallery_model.dart';
import '../../util/ehentai_crawler.dart';
import 'widget/gallery_card.dart';

class HomePage extends StatefulWidget {
  String? sear = '';

  @override
  State<HomePage> createState() => _HomePageState();

  HomePage({this.sear});
}

class _HomePageState extends State<HomePage> {
  var scrollController = ScrollController();
  final ctaController = Get.put(CataController());

  late List<GalleryModel> glist = [];

  String? prev;
  String? next;
  String? search;
  String? cata;
  String? beforeDate;
  bool? isPrev;
  var listener;

  var isInit = true;

  @override
  void initState() {
    super.initState();
    cata = '${ctaController.cataNum}';
    isPrev = false;
    search = widget.sear;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(96.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ehenAppBar((text) {
              next = '';
              setState(() {});
            }, () {
              next = '';
              setState(() {});
            }, (text) {
              search = text;
            }, searBarText: search),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: EhenCheck((cataNum) {
                cata = '$cataNum';
              }),
            ),
          ],
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: _searchGallerys(),
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

  Widget _buildMainContent() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: get_gallery_rows_list(),
    );
  }

  // 后端加载
  Future<int> _searchGallerys({List<GalleryModel>? list}) async {
    var htmlDoc = await loadGallerysHtml(isPrev!, search: search, cata: cata, prev: prev, next: next, dateBefore: beforeDate);

    glist = await getGalleryList(htmlDoc, list: list);
    next = getGalleryNextPage(htmlDoc);
    prev = getGalleryPrevPage(htmlDoc);
    beforeDate = null;
    isInit = false;
    return 1;
  }

  // 下一页和上一页
  Widget _nextPrevButton() {
    return Container(
      height: BOTTOM_BAR_HEIGHT,
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
              setState(() {
                isPrev = true;
              });
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
              setState(() {
                isPrev = false;
              });
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
  _date_selector_callback(String date, BuildContext context) async {
    setState(() {
      beforeDate = date;
    });
    Navigator.pop(context);
  }

  // 获取卡片列表
  Widget get_gallery_rows_list() {
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
