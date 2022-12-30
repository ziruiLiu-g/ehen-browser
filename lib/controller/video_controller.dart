import 'package:get/get.dart';

class VideoController extends GetxController {
  var _sear = '';
  var _page = 0.obs;

  String get sear => _sear;
  set sear(String s) => _sear = s;

  int get page => _page.value;
  set page(int s) => _page.value = s;

  @override
  void onInit() {
    super.onInit();
  }
}
