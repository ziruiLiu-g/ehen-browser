import 'package:ehentai_browser/model/gallery_model.dart';
import 'package:ehentai_browser/widget/paginator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/const.dart';
import '../../../../controller/cata_controller.dart';
import '../../../../controller/home_controller.dart';
import '../../../../widget/bottom_blur_navigator.dart';
import '../../../../widget/loading_animation.dart';
import '../../../../xhenhttp/ehen/dao/xhen_dao.dart';
import 'gallery_flutter_card.dart';
import 'multi_cata_check.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();

  HomeTabPage({required this.categoryName});
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  final ctaController = Get.put(CataController());
  final _scrollController = ScrollController();
  final _homeController = Get.put(HomeController());

  List<GalleryModel> glist = [];

  @override
  void initState() {
    super.initState();
    _homeController.cata = '${ctaController.cataNum}';
    _homeController.isPrev = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            padding: EdgeInsets.only(
                top: widget.categoryName == 'Home'
                    ? MULTI_SELECT_CATA_BAR_HEIGHT
                    : 0,
                bottom: BOTTOM_BAR_HEIGHT + 20),
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
                  _scrollController.animateTo(.0,
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.linear);
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: child,
                );
              },
            ),
          ),
        ),
        if (widget.categoryName == 'Home')
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EhenCheck((cataNum) {
                _homeController.cata = '$cataNum';
              }),
              Spacer(),
              _nextPrevButton(),
            ],
          ),
      ],
    );
  }

  // 后端加载
  _searchGallerys({List<GalleryModel>? list}) async {
    if (widget.categoryName == 'Home') {
      var htmlDoc = await XhenDao.loadGallerysHtml(_homeController.isPrev!,
          search: _homeController.sear,
          cata: _homeController.cata,
          prev: _homeController.prev,
          next: _homeController.next,
          dateBefore: _homeController.beforeDate);

      glist = await XhenDao.getGalleryList(htmlDoc, list: list);
      _homeController.next = XhenDao.getGalleryNextPage(htmlDoc) ?? '';
      _homeController.prev = XhenDao.getGalleryPrevPage(htmlDoc) ?? '';
      _homeController.beforeDate = '';
      _homeController.isPrev = false;
      _homeController.galleryVisible = true;
    } else if (widget.categoryName == 'Popular') {
      var htmlDoc = await XhenDao.requestPopular();
      glist = await XhenDao.getGalleryList(htmlDoc);
    }
  }

  // 获取卡片列表
  Widget get_gallery_rows_list() {
    Widget content;
    List<Widget> ww = [];
    for (int index = 0; index < glist.length; index++) {
      ww.add(
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

  // 下一页和上一页
  Widget _nextPrevButton() {
    return nextPrevButton(
      () {
        HapticFeedback.mediumImpact();
        setState(() {
          print("xxxx");
          _homeController.isPrev = true;
          _homeController.galleryVisible = false;
        });
      },
      () {
        HapticFeedback.mediumImpact();
        setState(() {
          _homeController.galleryVisible = false;
        });
      },
      selector: _simpleDialog,
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
    _homeController.beforeDate = date;
    Navigator.pop(context);
    HapticFeedback.mediumImpact();
    setState(() {
      _homeController.galleryVisible = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
