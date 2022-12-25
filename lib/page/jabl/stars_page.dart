import 'package:ehentai_browser/page/jabl/widget/stars_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html/dom.dart' as doc;

import '../../common/const.dart';
import '../../model/video_gallery_model.dart';
import '../../widget/loading_animation.dart';
import '../../widget/paginator.dart';
import '../../xhenhttp/jabl/dao/jabl_dao.dart';

class StarsPage extends StatefulWidget {
  final String categoryName;

  StarsPage({required this.categoryName});

  @override
  State<StarsPage> createState() => _StarsPageState();
}

class _StarsPageState extends State<StarsPage> {
  late int page;
  late int maxpage;
  late PAGE_TYPE pageType;

  late List<VideoStarModel> starList;

  @override
  void initState() {
    super.initState();
    page = 1;
    pageType = PAGE_TYPE.star;
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
                    itemCount: starList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return StarsCard(starList[index]);
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
    doc.Document d = await JableDao.get_document(pageType, page);
    starList = await JableDao.get_stars_list(d , pageType);
    maxpage = JableDao.get_max_page(d, pageType);
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
}
