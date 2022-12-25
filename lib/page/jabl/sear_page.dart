import 'package:ehentai_browser/page/jabl/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html/dom.dart' as doc;

import '../../common/const.dart';
import '../../model/video_gallery_model.dart';
import '../../widget/dark_mode_switcher.dart';
import '../../widget/loading_animation.dart';
import '../../widget/paginator.dart';
import '../../widget/search_bar.dart';
import '../../xhenhttp/jabl/dao/jabl_dao.dart';

class SearchPage extends StatefulWidget {
  var sear;

  @override
  State<SearchPage> createState() => _SearchPageState();

  SearchPage(this.sear);
}

class _SearchPageState extends State<SearchPage> {
  int page = 1;
  late int maxpage;
  late String sear;
  late List<VideoGalleryModel> videoList;

  @override
  void initState() {
    super.initState();
    sear = widget.sear;
    videoList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Stack(
            children: [Container(), DarkModeSwitch()],
          )
        ],
        title: EhenSearchBar(
          searchIconCallBack: () => (text) {
            setState(() {});
          },
          onSubmitted: (text) {
            HapticFeedback.mediumImpact();
            setState(() {});
          },
          inputCallBack: (text) {
            sear = text;
          },
          hint: "Use single space to search multiple.",
        ),
      ),
      body: MediaQuery.removePadding(
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
      ),
    );
  }

  _loadData() async {
    doc.Document d = await JableDao.get_document(PAGE_TYPE.sear, page, sear: sear);
    videoList = await JableDao.get_videoss_list(d, PAGE_TYPE.sear);
    maxpage = JableDao.get_max_page(d, PAGE_TYPE.sear);
  }

  _nextPrevButton() {
    return nextPrevButton(
      () {
        if (page == 1) return;
        HapticFeedback.mediumImpact();
        setState(() {
          page -= 1;
        });
      },
      () {
        HapticFeedback.mediumImpact();
        setState(() {
          page += 1;
        });
      },
      middle: TextButton(
        child: Text(
          '$page/$maxpage',
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
