import 'dart:convert';

import 'package:ehentai_browser/xhenhttp/request/base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T> (BaseRequest request);
}

class HiNetResponse<T> {
  HiNetResponse({this.data, required this.request, this.statusCode, this.statusMessage, this.extra});

  T? data;
  BaseRequest request;
  int? statusCode;
  String? statusMessage;
  late dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }

    return data.toString();
  }


}