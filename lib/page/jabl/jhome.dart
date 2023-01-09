import 'package:ehentai_browser/controller/theme_controller.dart';
import 'package:ehentai_browser/page/ehen/startPage.dart';
import 'package:ehentai_browser/page/jabl/sear_page.dart';
import 'package:ehentai_browser/page/jabl/stars_page.dart';
import 'package:ehentai_browser/page/jabl/video_home_tab_page.dart';
import 'package:ehentai_browser/widget/app_bar_ehen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../../common/const.dart';
import '../../../util/color.dart';
import '../../controller/video_controller.dart';

class JHomePage extends StatefulWidget {
  @override
  State<JHomePage> createState() => _JHomePageState();
}

class _JHomePageState extends State<JHomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;

  var sear = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: JAB_HOME_CATEGORIES.length, vsync: this);
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
        Get.to(() => SearchPage(sear));
      }, () {
        Get.to(() => SearchPage(sear));
      }, (text) {
        sear = text;
      }),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => AnimatedContainer(
                color: HomePageTabBgColor(ThemeController.isLightTheme),
                alignment: Alignment.centerLeft,
                duration: Duration(milliseconds: 200),
                child: _tabBar(),
              )),
              Flexible(
                child: TabBarView(
                  controller: _tabController,
                  children: JAB_HOME_CATEGORIES.map((tab) {
                    if (tab == 'AV Stars') return StarsPage(categoryName: tab);
                    return VideoHomeTabPage(categoryName: tab);
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
      tabs: JAB_HOME_CATEGORIES.map<Tab>(
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
