import 'package:ehentai_browser/page/home/widget/gallery_flutter_card.dart';
import 'package:ehentai_browser/page/home/widget/multi_cata_check.dart';
import 'package:ehentai_browser/widget/app_bar_ehen.dart';
import 'package:ehentai_browser/widget/bottom_blur_navigator.dart';
import 'package:ehentai_browser/widget/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/const.dart';
import '../../controller/cata_controller.dart';
import '../../controller/home_controller.dart';
import '../../model/gallery_model.dart';
import '../../xhenhttp/ehen/dao/xhen_dao.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final ctaController = Get.put(CataController());
  final _scrollController = ScrollController();
  final _homeController = Get.put(HomeController());

  List<GalleryModel> glist = [];

  String? prev;
  String? next;
  String? cata;
  String? beforeDate;
  bool? isPrev;

  @override
  void initState() {
    super.initState();
    cata = '${ctaController.cataNum}';
    isPrev = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ehenAppBar((text) {
        next = '';
        setState(() {
          _homeController.galleryVisible = false;
        });
      }, () {
        next = '';
        HapticFeedback.mediumImpact();
        setState(() {
          _homeController.galleryVisible = false;
        });
      }, (text) {
        _homeController.sear = text;
      }, searBarText: _homeController.sear),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildMainContent(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EhenCheck((cataNum) {
                cata = '$cataNum';
              }),
              _nextPrevButton(),
            ],
          )
        ],
      ),
    );
  }

  _buildMainContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.only(
            top: MULTI_SELECT_CATA_BAR_HEIGHT, bottom: BOTTOM_BAR_HEIGHT + 20),
        // child: get_gallery_rows_list(),
        child: FutureBuilder<dynamic>(
            future: _searchGallerys(),
            builder: (context, snapshot) {
              Widget child;
              if (snapshot.connectionState == ConnectionState.waiting) {
                child = Container(
                  key: ValueKey(1),
                  child: LoadingAnimation(),
                );
              } else {
                child = Container(
                  key: ValueKey(0),
                  child: get_gallery_rows_list(),
                );
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: child,
              );
            }),
      ),
    );
  }

  // 后端加载
  _searchGallerys({List<GalleryModel>? list}) async {
    var htmlDoc = await XhenDao.loadGallerysHtml(isPrev!,
        search: _homeController.sear,
        cata: cata,
        prev: prev,
        next: next,
        dateBefore: beforeDate);

    glist = await XhenDao.getGalleryList(htmlDoc, list: list);
    next = XhenDao.getGalleryNextPage(htmlDoc);
    prev = XhenDao.getGalleryPrevPage(htmlDoc);
    beforeDate = null;
    isPrev = false;

    _homeController.galleryVisible = true;
    _scrollController.animateTo(.0,
        duration: Duration(milliseconds: 1000), curve: Curves.linear);
  }

  // 下一页和上一页
  Widget _nextPrevButton() {
    return BottomBlurNavigator(
      widgets: <Widget>[
        TextButton(
          child: Text(
            "<< PREV",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            // await _searchGallerys(true);
            HapticFeedback.mediumImpact();
            setState(() {
              isPrev = true;
              _homeController.galleryVisible = false;
            });
          },
        ),
        TextButton(
          onPressed: _simpleDialog,
          child: Text(
            "JUMP",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          child: Text(
            "NEXT >>",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            setState(() {
              _homeController.galleryVisible = false;
            });
          },
        ),
      ],
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
    beforeDate = date;
    Navigator.pop(context);
    HapticFeedback.mediumImpact();
    setState(() {
      _homeController.galleryVisible = false;
    });
  }

  // 获取卡片列表
  Widget get_gallery_rows_list() {
    Widget content;
    List<Widget> ww = [];
    for (int index = 0; index < glist.length; index++) {
      ww.add(
        // GalleryFlutterCard(glist[index]),
        Obx(
          () => AnimatedOpacity(
            opacity: _homeController.galleryVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: GalleryFlutterCard(glist[index]),
          ),
        ),
      );
      ww.add(SizedBox(
        height: 5,
      ));
    }
    content = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ww,
    );

    return content;
  }

  @override
  bool get wantKeepAlive => true;
}
