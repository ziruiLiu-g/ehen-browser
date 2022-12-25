import 'package:get/get.dart';

class HomeController extends GetxController {
  var _galleryVisible = false.obs;
  var _sear = '';
  var prev = '';
  var next = '';
  var cata = '';
  var beforeDate = '';
  var isPrev = false;

  bool get galleryVisible => _galleryVisible.value;
  set galleryVisible(bool check) => _galleryVisible.value = check;

  String get sear => _sear;
  set sear(String s) => _sear = s;

  @override
  void onInit() {
    super.onInit();
  }
}
