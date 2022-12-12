
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';


var header = {
  'user-agent' : 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) '+
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
};

const XHENTAIL_PREFIX = 'https://e-hentai.org/?';

Future<String> requestData({String? search, String? cataNum, String? next}) async {
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
  
  print(url);
  
  var response = await http.get(url, headers: header);
  if (response.statusCode == 200) {
    return response.body;
  }
  return '<html>error! status:${response.statusCode}</html>';
}

String? get_next_page_url(html) {
  Document document = parse(html);
  List<Element> next = document.querySelectorAll('#unext');
  String? nextUrl;
  if(next.isNotEmpty){
    nextUrl = next[0].attributes['href'];
  }
  return nextUrl;
}

String? get_prev_page_url(html) {
  Document document = parse(html);
  List<Element> prev = document.querySelectorAll('#uprev');
  String? prevUrl;
  if(prev.isNotEmpty){
    prevUrl = prev[0].attributes['href'];
  }
  return prevUrl;
}

List<String?> get_gallery_list(html) {
  Document document = parse(html);
  // use css selector
  List<Element> gl = document.querySelectorAll('body > div.ido > div > table > tbody > tr > td.gl3c.glname > a');

  List<String?> data = [];
  if(gl.isNotEmpty){
    data = List.generate(gl.length, (i){
      return gl[i].attributes['href'];
    });
  }

  return data;
}