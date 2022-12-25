import 'package:ehentai_browser/controller/theme_controller.dart';
import 'package:ehentai_browser/page/ehen/home/widget/home_tab_page.dart';
import 'package:ehentai_browser/widget/app_bar_ehen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../../common/const.dart';
import '../../../controller/home_controller.dart';
import '../../../model/gallery_model.dart';
import '../../../util/color.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _homeController = Get.put(HomeController());

  late TabController _tabController;

  List<GalleryModel> glist = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: EHENTAI_HOME_CATEGORIES.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ehenAppBar((text) {
        _homeController.next = '';
        setState(() {
          _homeController.galleryVisible = false;
        });
      }, () {
        _homeController.next = '';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => AnimatedContainer(
                color: HomePageTabBgColor(ThemeController.isLightTheme),
                alignment: Alignment.center,
                duration: Duration(milliseconds: 200),
                child: _tabBar(),
              )),
              Flexible(
                child: TabBarView(
                  controller: _tabController,
                  children: EHENTAI_HOME_CATEGORIES.map((tab) {
                    return HomeTabPage(categoryName: tab);
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _tabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: galleryPageButtonColor(ThemeController.isLightTheme),
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round,
        borderSide: BorderSide(color: galleryPageButtonColor(ThemeController.isLightTheme), width: 3),
        insets: EdgeInsets.only(left: 15, right: 15),
      ),
      tabs: EHENTAI_HOME_CATEGORIES.map<Tab>(
            (tab) {
          return Tab(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                tab,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ).toList(),
    );
  }


  @override
  bool get wantKeepAlive => true;
}