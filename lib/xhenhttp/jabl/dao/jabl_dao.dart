import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../model/video_gallery_model.dart';

enum PAGE_TYPE {sear, latest, week, today, star, starVideos}

class JableDao {
  static const JABLE_PREFIX = 'https://jable.tv/';
  static const JABLE_STARS_PREFIX = 'https://jable.tv/models/?from=';
  static const JABLE_PREFIX_HOT_WEEK = 'https://jable.tv/hot/?&sort_by=video_viewed_week&from=';
  static const JABLE_PREFIX_HOT_DAY = 'https://jable.tv/hot/?&sort_by=video_viewed_today&from=';
  static const JABLE_SEARCH_PREFIX = 'https://jable.tv/search/';
  static const JABLE_LATEST_PREFIX = 'https://jable.tv/latest-updates/';
  static const JABLE_LATEST_FROM_POSTDATE_PREFIX =
      'https://jable.tv/latest-updates/?mode=async&function=get_block&block_id=list_videos_latest_videos_list&sort_by=post_date&from=';

  static const SEARCH_SELECTOR_PREFIX = '#list_videos_videos_list_search_result';
  static const LATEST_SELECTOR_PREFIX = '#list_videos_latest_videos_list';
  static const COMMON_SELECTOR_PREFIX = '#list_videos_common_videos_list';
  static const HOT_STARS_PREFIX = '#list_models_models_list';

  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static var header = {
    'accept-encoding': 'gzip, deflate, br',
    'user-agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
  };

  static get_document(PAGE_TYPE pg, int page, {String? sear, String? link}) async {
    var html;
    switch (pg) {
      case PAGE_TYPE.sear:
        html = await _get_html_respone(JABLE_SEARCH_PREFIX + '$sear/' + '?&from_videos=$page');
        break;
      case PAGE_TYPE.latest:
        html = await _get_html_respone(JABLE_LATEST_PREFIX + '$page' + '/');
        break;
      case PAGE_TYPE.week:
        html = await _get_html_respone(JABLE_PREFIX_HOT_WEEK + '$page');
        break;
      case PAGE_TYPE.today:
        html = await _get_html_respone(JABLE_PREFIX_HOT_DAY + '$page');
        break;
      case PAGE_TYPE.star:
        html = await _get_html_respone(JABLE_STARS_PREFIX + '$page');
        break;
      case PAGE_TYPE.starVideos:
        html = await _get_html_respone(link! + '?&from=$page');
        break;
    }

    var h = parse(html);
    return h;
  }

  static get_stars_list(Document h, PAGE_TYPE pageType) {
    List<Element> starPics =
    h.querySelectorAll('#list_models_models_list > div > section > div > div > div > a > div > img');
    List<Element> starName = h.querySelectorAll('#list_models_models_list > div > section > div > div > div > a > div > div > h6');
    List<Element> starVideosNum = h.querySelectorAll('#list_models_models_list > div > section > div > div > div > a > div > div > span');
    List<Element> starPage = h.querySelectorAll('#list_models_models_list > div > section > div > div > div > a');

    List<VideoStarModel> sl = [];
    for (int i = 0; i < starPics.length; i++) {
      var name = starName[i].nodes[0].text;
      var pic = starPics[i].attributes['src'];
      var videonum = starVideosNum[i].nodes[0].text;
      var page = starPage[i].attributes['href'];

      if(pic!.endsWith('svg')) {
        pic = '';
      }

      VideoStarModel vs = VideoStarModel(name, pic, page, videoNum: videonum);
      sl.add(vs);
    }

    return sl;
  }

  static get_max_page(Document h, PAGE_TYPE pageType) {
    String selectorHead = _get_selector_head(pageType);

    List<Element> page =
    h.querySelectorAll('$selectorHead > div > section > ul > li > a');
    if (page.length == 0) return 1;
    return int.parse(page.last.attributes['data-parameters'].toString().split(':').last.toString());
  }

  static get_videoss_list(Document h, PAGE_TYPE pageType) async {
    String selectorHead = _get_selector_head(pageType);


    List<Element> picList =
    h.querySelectorAll('$selectorHead > div > section > div > div > div > div.img-box.cover-md > a > img');
    List<Element> durationList = h.querySelectorAll('$selectorHead > div > section > div > div > div > div.img-box.cover-md > a > div.absolute-bottom-right > span');
    List<Element> titleList = h.querySelectorAll('$selectorHead > div > section > div > div > div > div.detail > h6 > a');
    List<Element> likeAndWatch = h.querySelectorAll('$selectorHead > div > section > div > div > div > div.detail > p');

    List<VideoGalleryModel> vl = [];
    for (int i = 0; i < picList.length; i++) {
      var videoPageLink = titleList[i].attributes['href'];
      String title = titleList[i].nodes[0].toString();
      var vid = title.split(' ')[0];
      var like =  likeAndWatch[i].nodes[4].toString().replaceAll('\n', '');
      var watch =  likeAndWatch[i].nodes[2].toString().replaceAll('\n', '');
      var duration = durationList[i].nodes[0].toString();
      var pics = picList[i].attributes['data-src'];
      var mp4 = picList[i].attributes['data-preview'];

      VideoGalleryModel v = VideoGalleryModel(
        vid: vid.substring(1, vid.length - 1),
        videoPageLink: videoPageLink,
        like_count: like.substring(1, like.length - 1),
        watch: watch.substring(1, watch.length - 1),
        duration: duration.substring(1, duration.length - 1),
        imgUrl: pics,
        mp4: mp4,
        title: title.substring(1, title.length - 1),
      );
      vl.add(v);
    }

    return vl;
  }

  static get_video_details(String url, VideoGalleryModel vmo) async {
    var html = await _get_html_respone(url);
    var h = parse(html);

    List<Element> m3u8 =
    h.querySelectorAll('#site-content > div > div > div > section.pb-3.pb-e-lg-30 > script');
    RegExp m3u8Exp=RegExp(r"http(.*?).m3u8");
    var videoStream = m3u8Exp.firstMatch(m3u8[1].nodes[0].text!)![0];
    vmo.m3u8 = videoStream;

    List<Element> starsE =
    h.querySelectorAll('#site-content > div > div > div > section.video-info.pb-3 > div.info-header > div.header-left > h6 > div > a');
    List<VideoStarModel> starsList = [];
    for (var e in starsE) {
      var webpage = e.attributes['href'].toString();
      var name = e.nodes[1].attributes['title'];
      var avatar = e.nodes[1].attributes['src'] ?? '';
      starsList.add(VideoStarModel(name, avatar, webpage));
    }
    vmo.stars = starsList;

    List<Element> cataE =
    h.querySelectorAll('#site-content > div > div > div > section.video-info.pb-3 > div.text-center > h5 > a');
    List<VideoCataModel> catas = [];
    for (var e in cataE) {
      var url = e.attributes['href'];
      var name = e.nodes[0].text ?? '';
      var level = e.attributes['class'] ?? 'tags';
      catas.add(VideoCataModel(name, url, level));
    }
    vmo.catas = catas;
  }

  static _get_selector_head(PAGE_TYPE pg) {
    switch (pg) {
      case PAGE_TYPE.sear:
        return SEARCH_SELECTOR_PREFIX;
      case PAGE_TYPE.latest:
        return LATEST_SELECTOR_PREFIX;
      case PAGE_TYPE.week:
      case PAGE_TYPE.starVideos:
      case PAGE_TYPE.today:
        return COMMON_SELECTOR_PREFIX;
      case PAGE_TYPE.star:
        return HOT_STARS_PREFIX;

    }
  }

  static _get_html_respone(String url) async {
    _logger.i('send request to: $url');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
    return '<html>error! status:${response.statusCode}</html>';
  }
}
