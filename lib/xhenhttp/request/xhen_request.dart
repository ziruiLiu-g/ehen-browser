
import 'package:ehentai_browser/xhenhttp/request/base_request.dart';

class XhenRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  String path() {
    return '/api.php';
  }

}