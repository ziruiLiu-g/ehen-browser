import 'package:get/get.dart';

class HomeController extends GetxController {
  var _galleryVisible = true.obs;

  bool get galleryVisible => _galleryVisible.value;
  set galleryVisible(bool check) => _galleryVisible.value = check;

  @override
  void onInit() {
    super.onInit();
  }
}
