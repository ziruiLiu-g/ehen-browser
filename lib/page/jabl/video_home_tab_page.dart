import 'package:ehentai_browser/model/video_gallery_model.dart';
import 'package:ehentai_browser/page/jabl/video_card.dart';
import 'package:ehentai_browser/xhenhttp/jabl/dao/jabl_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../widget/loading_animation.dart';

class VideoHomeTabPage extends StatefulWidget {
  final String categoryName;

  @override
  State<VideoHomeTabPage> createState() => _HomeTabPageState();

  VideoHomeTabPage({required this.categoryName});
}

class _HomeTabPageState extends State<VideoHomeTabPage> with AutomaticKeepAliveClientMixin {
  late List<VideoGalleryModel> videoList;

  int page = 0;

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
            child = Container(
              key: ValueKey(1),
              child: LoadingAnimation(),
            );
          } else {
            child = StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: videoList.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(videoList[index]);
              },
              staggeredTileBuilder: (int index) {
                return StaggeredTile.fit(1);
              },
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
    videoList = await JableDao.get_latest_list_by_post_date(page);
    print(videoList.length);
  }

  @override
  bool get wantKeepAlive => true;
}