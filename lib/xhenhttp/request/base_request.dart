
enum HttpMethod { GET, POST, DELETE }

// basic requests
abstract class BaseRequest {
  var pathParams;
  var useHttps = true;

  String authority() {
    return "api.e-hentai.org";
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = path();

    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    // http and https switcher
    if (useHttps) {
      uri = Uri.https(authority(), pathStr);
    } else {
      uri = Uri.http(authority(), pathStr);
    }
    return uri.toString();
  }

  Map<String, dynamic> params = Map();

  BaseRequest add(String k, Object v) {
    params[k] = v;
    return this;
  }

  BaseRequest addHeader(String k, Object v) {
    return this;
  }
}
