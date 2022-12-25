import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehentai_browser/xhenhttp/core/hi_error.dart';
import 'package:ehentai_browser/xhenhttp/core/hi_net_adaptor.dart';

import '../ehen/request/base_request.dart';

class DioAdaptor extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response;
    var error;

    var options = Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url());
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio().post(request.url(), data: jsonEncode(request.params), options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio().delete(request.url(), data: request.params);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(), data: await buildRes(response, request));
    }

    return buildRes(response, request);
  }

  Future<HiNetResponse<T>> buildRes<T>(Response? response, BaseRequest request) {
    return Future.value(HiNetResponse(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response));
  }
}
