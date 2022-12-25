import 'dart:convert';

import 'package:ehentai_browser/xhenhttp/core/hi_net.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../model/gallery_model.dart';
import '../request/base_request.dart';
import '../request/xhen_request.dart';

class XhenDao {
  static const XHENTAIL_PREFIX = 'https://e-hentai.org/';
  static const XHENTAIL_GALLERY_PREFIX = 'https://e-hentai.org/g/';
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static var header = {
    'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
    "Keep-Alive": "timeout=8",
  };

  static get_gallery(list) {
    return _send(list);
  }

  static get_img(list) {
    return _img_send(list);
  }

  static _send(list) async {
    BaseRequest request;
    request = XhenRequest();

    request.add("method", "gdata").add("gidlist", list).add("namespace", 1);

    var result = await HiNet.getInstace().fire(request);

    return result;
  }

  static _img_send(list) async {
    BaseRequest request;
    request = XhenRequest();

    request.add("method", "gtoken").add("pagelist", list);

    var result = await HiNet.getInstace().fire(request);

    return result;
  }

  static Future<Document> requestPopular() async {
    var url = XHENTAIL_PREFIX + 'popular';
    _logger.i('Collecting data from: $url');
    var html =  await _get_html_respone(url);
    return parse(html);
  }

  /// request galleries metadata for home page
  static Future<String> requestData({String? search, String? cataNum, String? next, String? prev, String? dateBefore}) async {
    var url = XHENTAIL_PREFIX + '?';
    if (cataNum != null && cataNum.isNotEmpty) {
      url += '&f_cats=$cataNum';
    }

    if (search != null && search.isNotEmpty) {
      url += '&f_search=$search';
    }

    if (next != null && next.isNotEmpty) {
      url += '&next=$next';
    }

    if (prev != null && prev.isNotEmpty) {
      url += '&prev=$prev';
    }

    if (dateBefore != null && dateBefore.isNotEmpty) {
      url += '&jump=$dateBefore';
    }

    _logger.i('Collecting data from: $url');

    return await _get_html_respone(url);
  }

  /// parse galleries metadata as list
  static Future<List<GalleryModel>> getGalleryList(Document doc, {List<GalleryModel>? list}) async {
    List<GalleryModel> glist = [];
    if (list != null) {
      glist = list;
    }

    var gls = get_gallery_list(doc);
    var gplist = [];

    for (var g1 in gls) {
      var gparams = g1?.split("/");
      gplist.add([gparams![gparams.length - 3], gparams[gparams.length - 2]]);
    }

    var tempList = [];
    int curIndex = 0;
    while (curIndex + 25 < gplist.length) {
      var tmp = await get_gallery(gplist.sublist(curIndex, curIndex + 25));
      tempList.add(tmp);
      curIndex += 25;
    }
    var tmp = await get_gallery(gplist.sublist(curIndex, gplist.length));
    tempList.add(tmp);

    for (var result in tempList) {
      var jresult = jsonDecode(result)['gmetadata'];
      if (jresult == null || jresult == '') {
        glist.clear();
        return glist;
      }
      for (int gindex = 0; gindex < jresult.length; gindex++) {
        GalleryModel gl = GalleryModel(gplist[gindex][0].toString(), gplist[gindex][1].toString(),
            imgUrl: jresult[gindex]['thumb'].toString(),
            title: jresult[gindex]['title'].toString(),
            image_count: jresult[gindex]['filecount'].toString(),
            cata: jresult[gindex]['category'].toString(),
            tags: jresult[gindex]['tags'] as List,
            rating: jresult[gindex]['rating'].toString(),
            post: jresult[gindex]['posted'].toString());
        glist.add(gl);
      }
    }
    return glist;
  }

  /// parse galleries metadata
  static List<String?> get_gallery_list(document) {
    // use css selector
    List<Element> gl =
    document.querySelectorAll('body > div.ido > div > table > tbody > tr > td.gl3c.glname > a');

    List<String?> data = [];
    if (gl.isNotEmpty) {
      data = List.generate(gl.length, (i) {
        return gl[i].attributes['href'];
      });
    }

    return data;
  }

  /// parse galleries metadata and collect next page
  static String? get_next_page_url(document) {
    List<Element> next = document.querySelectorAll('#unext') as List<Element>;
    String? nextUrl;
    if (next.isNotEmpty) {
      nextUrl = next[0].attributes['href'];
    }
    return nextUrl;
  }

  /// parse galleries metadata and collect prev page
  static String? get_prev_page_url(document) {
    List<Element> prev = document.querySelectorAll('#uprev') as List<Element>;
    String? prevUrl;
    if (prev.isNotEmpty) {
      prevUrl = prev[0].attributes['href'];
    }
    return prevUrl;
  }

  /// request single gallery metadata
  static Future<String> requestGalleryData(String gid, String token) async {
    var url = XHENTAIL_GALLERY_PREFIX;
    url += '${gid}/${token}/';

    return await _get_html_respone(url);
  }

  /// check whether the page is sensitive page
  static Future<String> checkIfSensitivePage(String html) async {
    Document document = parse(html);
    var showImgUrls = document.querySelectorAll('body > div > p > a');
    if (showImgUrls.length == 3) {
      var url = showImgUrls[2].attributes['href'];
      var newHead = header;
      newHead.putIfAbsent('cookie', () => 'nw=1');

      return _get_html_respone(url!);
    } else {
      return html;
    }
  }

  static String get_Gallery_Show_Img(html) {
    Document document = parse(html);
    // use css selector
    String showImgUrls = (document.querySelectorAll('#gd1 > div')[0].attributes['style'] as String);
    int firstP = showImgUrls.indexOf("(") + 1;
    int lastP = showImgUrls.indexOf(")");
    var img = showImgUrls.substring(firstP, lastP);
    return img;
  }

  /// get max page of a gallery
  static int get_Max_Page(html) {
    Document document = parse(html);
    // use css selector
    List<Element> gl = document.querySelectorAll("table.ptt > tbody > tr > td > a");
    if (gl.length > 1) {
      return int.parse(gl[gl.length - 2].nodes[0].text!);
    }

    return int.parse(gl[gl.length - 1].nodes[0].text!);
  }

  /// load html of a gallery page
  static Future<Document> loadGallerysHtml(
      bool isPrev, {
        String? search,
        String? cata,
        String? next,
        String? prev,
        String? dateBefore,
      }) async {
    var html;
    if (isPrev) {
      html = await requestData(search: search, cataNum: cata, prev: prev, dateBefore: dateBefore);
    } else {
      html = await requestData(search: search, cataNum: cata, next: next, dateBefore: dateBefore);
    }

    return parse(html);
  }

  static String? getGalleryNextPage(Document doc) {
    var nextUrl = get_next_page_url(doc);
    var next = nextUrl?.substring(nextUrl.lastIndexOf("=") + 1, nextUrl.length);
    return next;
  }
  static String? getGalleryPrevPage(Document doc) {
    var prevUrl = get_prev_page_url(doc);
    var prev = prevUrl?.substring(prevUrl.lastIndexOf("=") + 1, prevUrl.length);
    return prev;
  }

  /// request real pics data for a specific gallery
  static Future<String> requestPicsData(String gid, String token, int page) async {
    var url = XHENTAIL_GALLERY_PREFIX;
    url += '${gid}/${token}/?p=${page}';

    return await _get_html_respone(url);
  }

  /// get the pics page of the gallery
  static Future<List<String>> get_page_pics(String gid, String gtoken, int page) async {
    String html = await requestPicsData(gid, gtoken, page);
    Document document = parse(html);

    List<Element> gl = document.querySelectorAll("#gdt > div > div > a");
    List<String> data = [];
    if (gl.isNotEmpty) {
      data = List.generate(gl.length, (i) {
        return gl[i].attributes['href']!;
      });
    }

    return data;
  }

  /// get pics
  static Future<String> get_pics(String url) async {
    // first get the fail load path
    var response = await http.get(Uri.parse(url), headers: header).timeout(const Duration(milliseconds: 5000));
    String html = response.body;
    Document document = parse(html);
    var postfix = document.querySelectorAll('#loadfail')[0].attributes['onclick'];
    int firstP = postfix!.indexOf("'") + 1;
    int lastP = postfix.lastIndexOf("'");
    var post = postfix.substring(firstP, lastP);

    url = url + '?nl=' + post;

    // request again with new url
    response = await http.get(Uri.parse(url), headers: header).timeout(const Duration(milliseconds: 5000));
    html = response.body;
    document = parse(html);
    List<Element> gl = document.querySelectorAll("#img");



    if (gl.isNotEmpty) {
      return gl[0].attributes['src']!;
    }

    return '';
  }

  static _get_html_respone(String url) async {
    var response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      return response.body;
    }
    return '<html>error! status:${response.statusCode}</html>';
  }
}
