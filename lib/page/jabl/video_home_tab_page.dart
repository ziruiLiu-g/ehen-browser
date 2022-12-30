import 'package:ehentai_browser/model/video_gallery_model.dart';
import 'package:ehentai_browser/page/jabl/video_card.dart';
import 'package:ehentai_browser/xhenhttp/jabl/dao/jabl_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html/dom.dart' as doc;

import '../../common/const.dart';
import '../../widget/loading_animation.dart';
import '../../widget/paginator.dart';

class VideoHomeTabPage extends StatefulWidget {
  final String categoryName;

  @override
  State<VideoHomeTabPage> createState() => _HomeTabPageState();

  VideoHomeTabPage({required this.categoryName});
}

class _HomeTabPageState extends State<VideoHomeTabPage> with AutomaticKeepAliveClientMixin {
  late List<VideoGalleryModel> videoList;
  int page = 0;
  late int maxpage;

  @override
  void initState() {
    videoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: FutureBuilder<dynamic>(
        future: _loadData(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.connectionState == ConnectionState.waiting) {
            child = Center(
              key: ValueKey(1),
              child: LoadingAnimation(),
            );
          } else {
            child = Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: BOTTOM_BAR_HEIGHT),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: videoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return VideoCard(videoList[index]);
                    },
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.fit(1);
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    _nextPrevButton(),
                  ],
                ),
              ],
            );
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: child,
          );
        },
      ),
    );
  }

  _loadData() async {
    doc.Document d = await JableDao.get_latest_document(page);
    videoList = await JableDao.get_videoss_list(d , PAGE_TYPE.latest);
    maxpage = JableDao.get_max_page(d, PAGE_TYPE.latest);
  }

  _nextPrevButton() {
    return nextPrevButton(() {
      if (page == 0) return;
      HapticFeedback.mediumImpact();
      setState(() {
        if (page == 2) page -= 2;
        else page -= 1;
      });
    }, () {
      HapticFeedback.mediumImpact();
      setState(() {
        if (page == 0) page += 2;
        else page += 1;
      });
    },
    middle: TextButton(
      child: Text(
        '${page == 0 ? 1 : page}/$maxpage',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () {},
    ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}