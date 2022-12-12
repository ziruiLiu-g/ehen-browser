import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ehentai_browser/crawler/model/gallery_object.dart';
import 'package:ehentai_browser/crawler/widget/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

import '../common/const.dart';
import '../controller/theme_controller.dart';
import '../util/ehentai_crawler.dart';
import '../widget/switch_dark.dart';

class PicsPage extends StatefulWidget {
  Gallery g;
  int page;

  @override
  State<PicsPage> createState() => _PicsPageState();

  PicsPage(this.g, this.page);
}

class _PicsPageState extends State<PicsPage> {
  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  List<String> pics = [];
  List<Widget> loadedUrl = [];
  int curPageNum = 0;
  double curPos = 0;
  ScrollController _scrollController = new ScrollController();

  @override
  // 初始化State
  void initState() {
    super.initState();
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
      await getAllPicsList(widget.g.gid, widget.g.gtoken, 0);
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
            widget.g.title!,
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        actions: const <Widget>[DarkModeSwitch()],
      ),
      body: loadedUrl.isEmpty
          ? Container()
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Column(
                    children: loadedUrl,
                  ),
                  curPageNum != pics.length
                      ? Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: LoadingAnimation(),
                          // child: Obx(() => Text(
                          //       'Scroll up to load more ~',
                          //       style: TextStyle(
                          //         fontSize: 12,
                          //         color: picsLoadHintColor(
                          //             ThemeController.isLightTheme),
                          //       ),
                          //     )),
                        )
                      : Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                                'This is the Bottom of the page!!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: picsLoadHintColor(
                                      ThemeController.isLightTheme),
                                ),
                              )),
                        )
                ],
              ),
            ),
      // : ListView(
      //     controller: _scrollController,
      //     children: [
      //       Column(
      //         children: loadedUrl,
      //       ),
      //       curPageNum != pics.length
      //           ? Container()
      //           : Container(
      //               height: 50,
      //               alignment: Alignment.center,
      //               child: const Text(
      //                 'This is the Bottom of the page!!',
      //                 style: TextStyle(
      //                   fontSize: 12,
      //                   color: Colors.grey,
      //                 ),
      //               ),
      //             )
      //     ],
      //   ),
      bottomNavigationBar: _nextPrevButton(),
    );
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
              if (widget.page == 0) return;

              widget.page -= 1;
              loadedUrl = [];
              curPageNum = 0;
              await getAllPicsList(widget.g.gid, widget.g.gtoken, widget.page);
              setState(() {
                getMorePics();
              });
            },
          ),
          TextButton(
            child: Obx(
              () => Text(
                "${widget.page + 1}/${widget.g.maxPage}",
                style: TextStyle(
                  fontSize: 20,
                  color: galleryPageButtonColor(ThemeController.isLightTheme),
                ),
              ),
            ),
            onPressed: () {},
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
            onPressed: () async {
              if (widget.page == widget.g.maxPage! - 1) return;

              widget.page += 1;
              loadedUrl = [];
              curPageNum = 0;
              await getAllPicsList(widget.g.gid, widget.g.gtoken, widget.page);
              setState(() {
                getMorePics();
              });
            },
          ),
        ],
      ),
    );
  }

////network
  getMorePics() {
    Future.delayed(const Duration(seconds: 0), getpics());

    setState(() {
      curPageNum = min(curPageNum + 5, pics.length);
      print(curPageNum);
    });
  }

  getpics() {
    for (int i = curPageNum; i < min(curPageNum + 5, pics.length); i++) {
      loadedUrl.add(FutureBuilder<String>(
        future: get_img(pics[i]),
        builder: (context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.connectionState == ConnectionState.waiting) {
            child = Container();
          } else {
            // use stack to attach text to image

            // child = Stack(
            //   children: <Widget> [
            //     CachedNetworkImage(
            //       imageUrl: snapshot.data!,
            //       // placeholder: (context, url) => SizedBox(height: 50,child: LoadingAnimation(),),
            //       errorWidget: (context, url, error) => Container(),
            //     ),
            //     Text('${i + 1}', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 30),)
            //   ],
            // );

            child = CachedNetworkImage(
              imageUrl: snapshot.data!,
              fit: BoxFit.contain,
              // placeholder: (context, url) => SizedBox(height: 50,child: LoadingAnimation(),),
              errorWidget: (context, url, error) => Container(),
            );
          }

          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: child);
        },
      ));
    }
  }

  getAllPicsList(String gid, String gtoken, int page) async {
    pics = await get_page_pics(gid, gtoken, page);
    _logger.i(
        'Loading pics from gid: $gid, gtoken: $gtoken, page: $page, curPageNum: $curPageNum');
  }
}
