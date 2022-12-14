import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ehentai_browser/model/gallery_model.dart';
import 'package:ehentai_browser/widget/loading_animation.dart';
import 'package:ehentai_browser/xhenhttp/ehen/dao/xhen_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

import '../../common/const.dart';
import '../../controller/theme_controller.dart';
import '../../util/color.dart';
import '../../widget/bottom_blur_navigator.dart';
import '../../widget/dark_mode_switcher.dart';
import '../../util/image_save_load.dart';

class PicsPage extends StatefulWidget {
  @override
  State<PicsPage> createState() => _PicsPageState();
}

class _PicsPageState extends State<PicsPage> {
  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  ScrollController _scrollController = new ScrollController();

  List<String> pics = [];
  List<Widget> loadedUrl = [];
  int thisPage = 0;
  int curPageNum = 0;
  double curPos = 0;

  late GalleryModel g;

  @override
  // 初始化State
  void initState() {
    super.initState();
    g = Get.arguments['gallery'] as GalleryModel;

    _scrollController.addListener(() {
      if (curPos == _scrollController.position.pixels) {
        print('wait for current loaded');
        return;
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        curPos = _scrollController.position.pixels;
        getMorePics(); // 当滑到最底部时
      }
    });

    Future.delayed(Duration.zero, () async {
      await getAllPicsList(g.gid, g.gtoken, 0);
      await getMorePics();
    });
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
            g.title!,
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        actions: const <Widget>[DarkModeSwitch()],
      ),
      body: Stack(
        children: [
          _getBody(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_nextPrevButton()],
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    return loadedUrl.isEmpty
        ? Container()
        : SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.only(bottom: BOTTOM_BAR_HEIGHT + 20),
              child: Column(
                children: [
                  Column(
                    children: loadedUrl,
                  ),
                  if (curPageNum != pics.length)
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: LoadingAnimation(),
                    )
                  else
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          'This is the Bottom of the page!!',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                picsLoadHintColor(ThemeController.isLightTheme),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
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
          onPressed: () async {
            if (thisPage == 0) return;

            thisPage -= 1;
            loadedUrl = [];
            curPageNum = 0;
            await getAllPicsList(g.gid, g.gtoken, thisPage);
            setState(() {
              getMorePics();
              HapticFeedback.mediumImpact();
            });
          },
        ),
        TextButton(
          child: Text(
            '${thisPage + 1}/${g.maxPage}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ),
        TextButton(
          child: Text(
            "NEXT >>",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            if (thisPage == g.maxPage! - 1) return;

            thisPage += 1;
            loadedUrl = [];
            curPageNum = 0;
            HapticFeedback.mediumImpact();
            await getAllPicsList(g.gid, g.gtoken, thisPage);
            setState(() {
              getMorePics();
            });
          },
        ),
      ],
    );
  }

////network
  getMorePics() {
    Future.delayed(const Duration(seconds: 0), getpics());

    setState(() {
      curPageNum = min(curPageNum + 5, pics.length);
    });
  }

  FutureOr<dynamic> Function()? getpics() {
    for (int i = curPageNum; i < min(curPageNum + 5, pics.length); i++) {
      loadedUrl.add(FutureBuilder<String>(
        future: XhenDao.get_pics(pics[i]),
        builder: (context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.connectionState == ConnectionState.waiting) {
            child = Container();
          } else {
            child = GestureDetector(
              onLongPress: () {
                _openDownloadDialog(snapshot.data!);
                HapticFeedback.heavyImpact();
              },
              child: CachedNetworkImage(
                imageUrl: snapshot.data!,
                fit: BoxFit.contain,
                // placeholder: (context, url) => SizedBox(height: 50,child: LoadingAnimation(),),
                errorWidget: (context, url, error) => Container(),
              ),
            );
          }

          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: child);
        },
      ));
    }
  }

  getAllPicsList(String gid, String gtoken, int page) async {
    pics = await XhenDao.get_page_pics(gid, gtoken, page);
    _logger.i(
        'Loading pics from gid: $gid, gtoken: $gtoken, page: $page, curPageNum: $curPageNum');
  }

  _openDownloadDialog(String url) {
    Get.defaultDialog(
      title: "",
      backgroundColor: Colors.grey.withOpacity(0),
      content: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: const Text(
                      "Save Image",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            saveNetworkImage(url),
                            Get.back()
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
