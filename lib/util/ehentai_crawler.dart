import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';

import '../model/gallery_model.dart';
import '../xhenhttp/dao/xhen_dao.dart';

var header = {
  'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
  "Keep-Alive": "timeout=8"
};

const XHENTAIL_PREFIX = 'https://e-hentai.org/?';
const XHENTAIL_GALLERY_PREFIX = 'https://e-hentai.org/g/';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

Future<String> requestData(
    {String? search,
    String? cataNum,
    String? next,
    String? prev,
    String? dateBefore}) async {
  var url = XHENTAIL_PREFIX;
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

  var response = await http.get(Uri.parse(url), headers: header);
  if (response.statusCode == 200) {
    return response.body;
  }
  return '<html>error! status:${response.statusCode}</html>';
}

String? get_next_page_url(document) {
  List<Element> next = document.querySelectorAll('#unext');
  String? nextUrl;
  if (next.isNotEmpty) {
    nextUrl = next[0].attributes['href'];
  }
  return nextUrl;
}

String? get_prev_page_url(document) {
  List<Element> prev = document.querySelectorAll('#uprev');
  String? prevUrl;
  if (prev.isNotEmpty) {
    prevUrl = prev[0].attributes['href'];
  }
  return prevUrl;
}

List<String?> get_gallery_list(document) {
  // use css selector
  List<Element> gl = document.querySelectorAll(
      'body > div.ido > div > table > tbody > tr > td.gl3c.glname > a');

  List<String?> data = [];
  if (gl.isNotEmpty) {
    data = List.generate(gl.length, (i) {
      return gl[i].attributes['href'];
    });
  }

  return data;
}

Future<String> requestGalleryData(String gid, String token) async {
  var url = XHENTAIL_GALLERY_PREFIX;
  url += '${gid}/${token}/';

  var response = await http.get(Uri.parse(url), headers: header);
  if (response.statusCode == 200) {
    return response.body;
  }
  return '<html>error! status:${response.statusCode}</html>';
}

String get_Gallery_Show_Img(html) {
  Document document = parse(html);
  // use css selector
  String showImgUrls = (document
      .querySelectorAll('#gd1 > div')[0]
      .attributes['style'] as String);
  int firstP = showImgUrls.indexOf("(") + 1;
  int lastP = showImgUrls.indexOf(")");
  var img = showImgUrls.substring(firstP, lastP);
  return img;
}

int get_Max_Page(html) {
  Document document = parse(html);
  // use css selector

  List<Element> gl =
      document.querySelectorAll("table.ptt > tbody > tr > td > a");

  if (gl.length > 1) {
    return int.parse(gl[gl.length - 2].nodes[0].text!);
  }

  return int.parse(gl[gl.length - 1].nodes[0].text!);
}

Future<Document> loadGallerysHtml(
  bool isPrev, {
  String? search,
  String? cata,
  String? next,
  String? prev,
  String? dateBefore,
}) async {
  var html;
  if (isPrev) {
    html = await requestData(
        search: search, cataNum: cata, prev: prev, dateBefore: dateBefore);
  } else {
    html = await requestData(
        search: search, cataNum: cata, next: next, dateBefore: dateBefore);
  }

  return parse(html);
}

getGalleryNextPage(Document doc) {
  var nextUrl = get_next_page_url(doc);
  var next = nextUrl?.substring(nextUrl.lastIndexOf("=") + 1, nextUrl.length);
  return next;
}

getGalleryPrevPage(Document doc) {
  var prevUrl = get_prev_page_url(doc);
  var prev = prevUrl?.substring(prevUrl.lastIndexOf("=") + 1, prevUrl.length);
  return prev;
}

getGalleryList(Document doc, {List<GalleryModel>? list}) async {
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

  var result = await XhenDao.get_gallery(gplist);
  var jresult = jsonDecode(result)['gmetadata'];
  if (jresult == null || jresult == '') {
    glist.clear();
    return glist;
  }
  for (int gindex = 0; gindex < jresult.length; gindex++) {
    GalleryModel gl = GalleryModel(gplist[gindex][0], gplist[gindex][1],
        imgUrl: jresult[gindex]['thumb'],
        title: jresult[gindex]['title'],
        image_count: jresult[gindex]['filecount'],
        cata: jresult[gindex]['category'],
        tags: jresult[gindex]['tags'],
        rating: jresult[gindex]['rating'],
        post: jresult[gindex]['posted']);
    glist.add(gl);
  }
  return glist;
}

Future<String> requestPicsData(String gid, String token, int page) async {
  var url = XHENTAIL_GALLERY_PREFIX;
  url += '${gid}/${token}/?p=${page}';

  var response = await http.get(Uri.parse(url), headers: header);
  if (response.statusCode == 200) {
    return response.body;
  }
  return '<html>error! status:${response.statusCode}</html>';
}

Future<List<String>> get_page_pics(String gid, String gtoken, int page) async {
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

Future<String> get_img(String url) async {
  var response = await http
      .get(Uri.parse(url), headers: header)
      .timeout(const Duration(milliseconds: 5000));
  String html = response.body;
  Document document = parse(html);

  List<Element> gl = document.querySelectorAll("#img");

  if (gl.isNotEmpty) {
    return gl[0].attributes['src']!;
  }

  return '';
}
