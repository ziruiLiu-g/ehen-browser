import '../request/base_request.dart';
import 'hi_net_adaptor.dart';

/// mock data
///

class MockAdaptor extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future.delayed(Duration(milliseconds: 1000), () {
      // {"statusCode":200, "data":{"code":0, "message":"success"}}
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": "success"} as T,
          statusCode: 403);
    });
  }
}
