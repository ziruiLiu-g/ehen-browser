

import 'dart:convert';

import 'package:ehentai_browser/crawler/xhenhttp/core/hi_net.dart';
import 'package:ehentai_browser/crawler/xhenhttp/request/base_request.dart';

import '../request/xhen_request.dart';

class XhenDao {
  static get_gallery(list) {
    return _send(list);
  }

  static _send(list) async {
    BaseRequest request;
    request = XhenRequest();

    request
        .add("method", "gdata")
        .add("gidlist", list)
        .add("namespace", 1);

    var result = await HiNet.getInstace().fire(request);


    return result;
  }
}
