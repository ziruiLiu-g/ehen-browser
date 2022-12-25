import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../model/video_gallery_model.dart';

class JableDao {
  static const JABLE_PREFIX = 'https://jable.tv/';
  static const JABLE_SEARCH_PREFIX = 'https://jable.tv/search/';
  static const JABLE_LATEST_PREFIX = 'https://jable.tv/latest-updates/';
  static const JABLE_LATEST_FROM_POSTDATE_PREFIX =
      'https://jable.tv/latest-updates/?mode=async&function=get_block&block_id=list_videos_latest_videos_list&sort_by=post_date&from=';

  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static var header = {
    'accept-encoding': 'gzip, deflate, br',
    'user-agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
  };

  static get_latest_list_by_post_date(int page) async {
    var html = await _get_html_respone(JABLE_LATEST_PREFIX + '$page' + '/');

    var h = parse(html);
    List<Element> picList =
    h.querySelectorAll('#list_videos_latest_videos_list > div > section > div > div > div > div.img-box.cover-md > a > img');
    List<Element> durationList = h.querySelectorAll('#list_videos_latest_videos_list > div > section > div > div > div > div.img-box.cover-md > a > div.absolute-bottom-right > span');
    List<Element> titleList = h.querySelectorAll('#list_videos_latest_videos_list > div > section > div > div > div > div.detail > h6 > a');
    List<Element> likeAndWatch = h.querySelectorAll('#list_videos_latest_videos_list > div > section > div > div > div > div.detail > p');

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

  static _get_html_respone(String url) async {
    _logger.i('send request to: $url');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
    return '<html>error! status:${response.statusCode}</html>';
  }
}
